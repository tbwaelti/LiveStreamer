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

-(void) gstreamerInitialized
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.play_button.enabled = TRUE;
        self.pause_button.enabled = TRUE;
        self.message_label.text = @"Ready";
    });
}

-(void) gstreamerSetUIMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.message_label.text = message;
    });
}

@end
