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
    self.play_button.enabled = FALSE;
    self.pause_button.enabled = FALSE;
    
    /* As soon as the GStreamer backend knows the real values, these ones will be replaced */
    media_width = 320;
    media_height = 240;
    
    gst_backend = [[GStreamerBackend alloc] init:self videoView:self.video_view];
    
    [self configureView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(UIBarButtonItem *)sender {
    [gst_backend play];
    is_playing_desired = YES;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (IBAction)pause:(UIBarButtonItem *)sender {
    [gst_backend pause];
    is_playing_desired = NO;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (IBAction)crosshairSwitchPressed:(UIBarButtonItem *)sender {
}

-(void) gstreamerInitialized
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.play_button.enabled = TRUE;
        self.pause_button.enabled = TRUE;
        self.message_label.text = @"Ready";
        is_local_media = [uri hasPrefix:@"file://"];
        is_playing_desired = NO;
    });
}

-(void) gstreamerSetUIMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.message_label.text = message;
    });
}

@end
