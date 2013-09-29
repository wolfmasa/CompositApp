//
//  JBImageManager.m
//  CompositApp
//
//  Created by 上原 将司 on 2013/09/28.
//  Copyright (c) 2013年 ProjectJB. All rights reserved.
//

#import "JBImageManager.h"

@implementation JBImageManager

- (id)init
{
    self.compositList = [NSMutableArray new];
    [self.compositList addObject:@"加算"];
    [self.compositList addObject:@"減算"];
    [self.compositList addObject:@"比較：明"];
    [self.compositList addObject:@"比較：暗"];
    
    self.compositMode = 0;
    self.ratio = 0.5;
    self.startPoint = CGPointMake(0, 0);
    
    self.needUpdate = NO;
    return self;
}

-(UInt8 *)getBytes:(UIImage *)image BytesPerLine:(size_t*)bytesPerRow
{
    UIImage *img = image;
    CGImageRef cgImage = [img CGImage];
    *bytesPerRow = CGImageGetBytesPerRow(cgImage);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    return (UInt8*)CFDataGetBytePtr(data);
}

-(void)composit_KasanGensan:(UInt8*)src1 target:(UInt8*)src2 result:(UInt8*)dst mode:(BOOL)isKasan
{
    for(int i=0; i<3; i++)
    {
        UInt8 p = src1[2-i];
        UInt8 q = src2[2-i];
        if(src2 == nil)
            dst[i] = p;
        else if(isKasan)
            dst[i] = p*self.ratio + q*(1-self.ratio);
        else
            dst[i] = p - q*(1-self.ratio);
        
        if(dst[i] < 0) dst[i] = 0;
        else if(dst[i] >255) dst[i]=255;
    }
    
    dst[3] = src1[3];
}

-(void)composit_HikakuMeiAn:(UInt8*)src1 target:(UInt8*)src2 result:(UInt8*)dst mode:(BOOL)isMei
{
    /*
     Y =   0.257R + 0.504G + 0.098B + 16
     Cb = -0.148R - 0.291G + 0.439B + 128
     Cr =  0.439R - 0.368G - 0.071B + 128
     */
    
    UInt8 y1 = 0.257*src1[0] + 0.504*src1[1] + 0.098*src1[2] + 16;
    UInt8 y2 = 0.257*src2[0] + 0.504*src2[1] + 0.098*src2[2] + 16;
    
    if((y1 > y2 && (isMei==YES)) || (y1 < y2&& (isMei==NO)))
    {
        dst[0] = src1[2];
        dst[1] = src1[1];
        dst[2] = src1[0];
        dst[3] = src1[3];
    }
    else
    {
        dst[0] = src2[2];
        dst[1] = src2[1];
        dst[2] = src2[0];
        dst[3] = src2[3];
    }
}

-(void)compositPixel:(UInt8*)src1 target:(UInt8*)src2 result:(UInt8*)dst
{
    
    switch (self.compositMode) {
        case 0:
            [self composit_KasanGensan:src1 target:src2 result:dst mode:YES];
            break;
        case 1:
            [self composit_KasanGensan:src1 target:src2 result:dst mode:NO];
            break;
        case 2:
            [self composit_HikakuMeiAn:src1 target:src2 result:dst mode:YES];
            break;
        case 3:
            [self composit_HikakuMeiAn:src1 target:src2 result:dst mode:NO];
            break;
        default:
            break;
    }
}

-(void)composit
{
    UIImage *img = self.image1;
    size_t bytesPerRow1 = 0;
    UInt8 *pixels1 = [self getBytes:self.image1 BytesPerLine:&bytesPerRow1];
    
    size_t bytesPerRow2 = 0;
    UInt8 *pixels2 = [self getBytes:self.image2 BytesPerLine:&bytesPerRow2];
    
    long buffSize =sizeof(UInt8)*img.size.width*img.size.height*4;
    UInt8 *buff = (UInt8 *)malloc(buffSize);
    size_t bytesPerRowDst = img.size.width*4*sizeof(UInt8);
    
    // 画像処理
    for (int y = 0 ; y < img.size.height; y++){
        for (int x = 0; x < img.size.width; x++){
            UInt8* src1 = pixels1 + y * bytesPerRow1 + x * 4;
            UInt8* src2 = nil;
            if(x -self.startPoint.x >= 0 && y -self.startPoint.y>=0)
                src2 = pixels2 + (int)(y -self.startPoint.y) * bytesPerRow2 + (int)(x -self.startPoint.x) * 4;
            UInt8* dst = buff +y * bytesPerRowDst + x * 4;
            
            [self compositPixel:src1 target:src2 result:dst];
        }
    }
    
    // pixel値からUIImageの再合成
    CFDataRef resultData = CFDataCreate(NULL, buff, buffSize);
    CGDataProviderRef resultDataProvider = CGDataProviderCreateWithCFData(resultData);
    CGImageRef resultCgImage = CGImageCreate(img.size.width, img.size.height,8,32,bytesPerRowDst,
                                            CGColorSpaceCreateDeviceRGB(),kCGBitmapByteOrderDefault,resultDataProvider, NULL, YES, kCGRenderingIntentDefault);
    self.result = [[UIImage alloc] initWithCGImage:resultCgImage];
    
    self.needUpdate = NO;
    
    // 後処理
    CGImageRelease(resultCgImage);
    CFRelease(resultDataProvider);
    CFRelease(resultData);
    free(buff);
}

-(BOOL)isNeedRatio
{
    BOOL ret = YES;
    switch (self.compositMode) {
        case 0:
        case 1:
            ret = YES;
            break;
        default:
            ret = NO;
            break;
    }
    return ret;
}

@end
