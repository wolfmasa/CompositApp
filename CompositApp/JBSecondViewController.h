//
//  JBSecondViewController.h
//  CompositApp
//
//  Created by 上原 将司 on 2013/09/28.
//  Copyright (c) 2013年 ProjectJB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBAppDelegate.h"

@interface JBSecondViewController : UIViewController<UITabBarControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) JBImageManager *imageManager;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) UIImageView *compositImageView;

//Mode Controll
@property (weak, nonatomic) IBOutlet UISegmentedControl *zoomMode;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dragMode;
- (IBAction)changeZoomMode:(id)sender;
- (IBAction)changeDragMode:(id)sender;

//Ratio Slider
@property (weak, nonatomic) IBOutlet UISlider *compositSlider;
- (IBAction)changeRatio:(id)sender;

- (IBAction)saveImage:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *modeLabel;

@end
