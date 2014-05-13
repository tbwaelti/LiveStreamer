//
//  DetailViewController.h
//  LiveStreamer
//
//  Created by Kai Waelti on 13/05/14.
//  Copyright (c) 2014 Kai Waelti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaglUIView.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *play_button;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pause_button;
@property (weak, nonatomic) IBOutlet UILabel *message_label;
@property (weak, nonatomic) IBOutlet EaglUIView *video_view;
@property (weak, nonatomic) IBOutlet UIView *video_container_view;

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *toolbarLabel;
@property (weak, nonatomic) NSString *uri;

- (IBAction)play:(UIBarButtonItem *)sender;
- (IBAction)pause:(UIBarButtonItem *)sender;
- (IBAction)crosshairSwitchPressed:(UIBarButtonItem *)sender;

/* From GStreamerBackendDelegate */
-(void) gstreamerInitialized;
-(void) gstreamerSetUIMessage:(NSString *)message;

@end
