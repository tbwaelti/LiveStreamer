//
//  DetailViewController.m
//  LiveStreamer
//
//  Created by Kai Waelti on 13/05/14.
//  Copyright (c) 2014 Kai Waelti. All rights reserved.
//

#import "DetailViewController.h"
#import "GStreamerBackend.h"
#import <UIKit/UIKit.h>
#import <GLKit/GLKView.h>

@interface DetailViewController () {
    GStreamerBackend *gst_backend;
    int media_width;                /* Width of the clip */
    int media_height;               /* height ofthe clip */
    Boolean is_local_media;         /* Whether this clip is stored locally or is being streamed */
    Boolean is_playing_desired;     /* Whether the user asked to go to PLAYING */
}
- (void)configureView;
@end

@implementation DetailViewController

@synthesize uri;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.toolbarLabel.text = [NSString stringWithFormat:@"Now streaming: \n%@", [self.detailItem valueForKey:@"name"]];
        self.uri = [self.detailItem valueForKey:@"feed"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    gst_backend = [[GStreamerBackend alloc] init:self videoView:self.video_view];
    
    NSLog([gst_backend getGStreamerVersion]);
    self.play_button.enabled = FALSE;
    self.pause_button.enabled = FALSE;
    
    myImageRect = CGRectMake(0.0f, 150.0f, 325.0f, 225.0f);
    myImage = [[UIImageView alloc] initWithFrame:myImageRect];
    [myImage setImage:[UIImage imageNamed:@"crosshair"]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    myImage = nil;
    [gst_backend deinit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play_pushed:(UIBarButtonItem *)sender {
    NSLog(@"play pushed");
    [gst_backend play];
}

- (IBAction)pause_pushed:(UIBarButtonItem *)sender {
    NSLog(@"Pause pushed");
    [gst_backend pause];
}

- (IBAction)crosshairChanged:(UISwitch *)sender {
    if (sender.on) {
        [self.view addSubview:myImage];
    } else if (!sender.on) {
        if (myImage != nil) {
            [self.view sendSubviewToBack:myImage];
        }
    }
}

- (IBAction)editPressed:(UIButton *)sender {
    [gst_backend pause];
    myImage = nil;
    [gst_backend deinit];
    self.editViewController = (ELEditViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"editViewStb"];
    [self.editViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self.editViewController setDetailItem:self.detailItem];
    [self presentViewController:self.editViewController animated:YES completion:NULL];
    gst_backend = [[GStreamerBackend alloc] init:self videoView:self.video_view];
    self.toolbarLabel.text = [NSString stringWithFormat:@"Now streaming: \n%@", [self.detailItem valueForKey:@"name"]];
    self.uri = [self.detailItem valueForKey:@"feed"];
    [gst_backend setUri:self.uri];
    [gst_backend play];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if ((fromInterfaceOrientation == UIInterfaceOrientationPortrait) || (fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
        
        [self.view sendSubviewToBack:myImage];
        myImageRect = CGRectMake(125.0f, 50.0f, 320.0f, 200.0f);
        myImage = [[UIImageView alloc] initWithFrame:myImageRect];
        [myImage setImage:[UIImage imageNamed:@"crosshair"]];
        [self crosshairChanged:self.crosshairSwitch];
    }
    if ((fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
        
        [self.view sendSubviewToBack:myImage];
        myImageRect = CGRectMake(0.0f, 150.0f, 325.0f, 225.0f);
        myImage = [[UIImageView alloc] initWithFrame:myImageRect];
        [myImage setImage:[UIImage imageNamed:@"crosshair"]];
        [self crosshairChanged:self.crosshairSwitch];
    }
    if ((fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
        
        [self.view sendSubviewToBack:myImage];
        myImageRect = CGRectMake(0.0f, 150.0f, 325.0f, 225.0f);
        myImage = [[UIImageView alloc] initWithFrame:myImageRect];
        [myImage setImage:[UIImage imageNamed:@"crosshair"]];
        [self crosshairChanged:self.crosshairSwitch];
    }
}

-(void) gstreamerInitialized
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.play_button.enabled = TRUE;
        self.pause_button.enabled = TRUE;
        self.message_label.text = @"Ready to stream";
        [gst_backend setUri:self.uri];
    });
}

-(void) gstreamerSetUIMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.message_label.text = message;
    });
}

@end
