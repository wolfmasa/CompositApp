//
//  JBAppDelegate.h
//  CompositApp
//
//  Created by 上原 将司 on 2013/09/28.
//  Copyright (c) 2013年 ProjectJB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBImageManager.h"

@interface JBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) JBImageManager *imageManager;

@end
