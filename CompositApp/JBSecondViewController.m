//
//  JBSecondViewController.m
//  CompositApp
//
//  Created by 上原 将司 on 2013/09/28.
//  Copyright (c) 2013年 ProjectJB. All rights reserved.
//

#import "JBSecondViewController.h"

@interface JBSecondViewController ()

@end

@implementation JBSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    JBAppDelegate *appDelegate = (JBAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.imageManager =  appDelegate.imageManager;
    
    [self.tabBarController setDelegate:self];
    [self updateImageView];
}

-(void)updateImageView
{
    if(self.imageManager.needUpdate != YES) return;
    [self.compositImageView removeFromSuperview];
    
    /*
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc]
                            initWithFrame:CGRectMake(260.0, 12.0, 25.0, 25.0)];
    ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
//    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
    [self.scrollView addSubview:ai];
    [ai startAnimating];
*/
     
    [self.imageManager composit];
    /*
    [ai stopAnimating];
    [ai removeFromSuperview];
     */
    
    self.compositImageView = [[UIImageView alloc] initWithImage:self.imageManager.result];

    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.scrollEnabled = YES;
    [self.scrollView setContentSize:self.compositImageView.frame.size];
    [self.scrollView setDelegate:self];
    [self.scrollView setMinimumZoomScale:0.1];
    [self.scrollView setMaximumZoomScale:10.0];
    
	[self.view addSubview:self.scrollView];
	[self.scrollView addSubview:self.compositImageView];
    

    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *view = nil;
    if (scrollView == self.scrollView) {
        view = self.compositImageView;
    }
    return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITabBar

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    self.modeLabel.text = [self.imageManager.compositList objectAtIndex:self.imageManager.compositMode];
    [self.compositSlider setEnabled:[self.imageManager isNeedRatio]];
    [self updateImageView];
}

- (IBAction)changeRatio:(id)sender {
    if(self.imageManager.ratio != self.compositSlider.value)
    {
        self.imageManager.ratio = self.compositSlider.value;
        self.imageManager.needUpdate = YES;
    }
    [self updateImageView];
}

- (IBAction)saveImage:(id)sender {
    //画像保存完了時のセレクタ指定
    SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
    //画像を保存する
    UIImageWriteToSavedPhotosAlbum(self.imageManager.result, self, selector, NULL);
}

//画像保存完了時のセレクタ
- (void)onCompleteCapture:(UIImage *)screenImage
 didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"画像を保存しました";
    if (error) message = @"画像の保存に失敗しました";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @""
                                                    message: message
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (IBAction)changeZoomMode:(id)sender {
}

- (IBAction)changeDragMode:(id)sender {
}
@end
