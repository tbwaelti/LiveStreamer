//
//  DetailViewController.h
//  LiveStreamer
//
//  Created by Kai Waelti on 13/05/14.
//  Copyright (c) 2014 Kai Waelti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELEditViewController.h"
#import "EaglUIView.h"

@interface DetailViewController : UIViewController {
    UIImageView *myImage;
    CGRect myImageRect;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *play_button;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pause_button;
@property (weak, nonatomic) IBOutlet UILabel *message_label;
@property (weak, nonatomic) IBOutlet EaglUIView *video_view;
@property (weak, nonatomic) IBOutlet UIView *video_container_view;
@property (weak, nonatomic) IBOutlet UISwitch *crosshairSwitch;

@property (strong, nonatomic) id detailItem;
@property ELEditViewController *editViewController;

@property (weak, nonatomic) IBOutlet UILabel *toolbarLabel;
@property (weak, nonatomic) NSString *uri;

- (IBAction)play_pushed:(UIBarButtonItem *)sender;
- (IBAction)pause_pushed:(UIBarButtonItem *)sender;
- (IBAction)crosshairChanged:(UISwitch *)sender;
- (IBAction)editPressed:(UIButton *)sender;

/* From GStreamerBackendDelegate */
-(void) gstreamerInitialized;
-(void) gstreamerSetUIMessage:(NSString *)message;

@end
