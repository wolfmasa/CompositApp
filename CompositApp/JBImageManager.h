//
//  JBImageManager.h
//  CompositApp
//
//  Created by 上原 将司 on 2013/09/28.
//  Copyright (c) 2013年 ProjectJB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBImageManager : NSObject

@property(weak, nonatomic)UIImage *image1;
@property(weak, nonatomic)UIImage *image2;

@property(retain, nonatomic)UIImage *result;

@property float ratio;
@property CGPoint startPoint;

@property BOOL needUpdate;

@property NSInteger compositMode;
@property(nonatomic)NSMutableArray *compositList;

-(void)composit;
-(BOOL)isNeedRatio;
@end
