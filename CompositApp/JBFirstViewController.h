//
//  JBFirstViewController.h
//  CompositApp
//
//  Created by 上原 将司 on 2013/09/28.
//  Copyright (c) 2013年 ProjectJB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBImageManager.h"

@interface JBFirstViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property(weak, nonatomic) JBImageManager *imageManager;
@property int openMode;

//Image1
@property (weak, nonatomic) IBOutlet UIButton *ButtonOpenImage1;
@property (weak, nonatomic) IBOutlet UIImageView *Image1View;
- (IBAction)OpenImage1:(id)sender;

//Image2
@property (weak, nonatomic) IBOutlet UIButton *ButtonOpenImage2;
@property (weak, nonatomic) IBOutlet UIImageView *Image2View;
- (IBAction)OpenImage2:(id)sender;


//PickerVew
@property (weak, nonatomic) IBOutlet UIPickerView *CompositParam;


@end
