//
//  JBFirstViewController.m
//  CompositApp
//
//  Created by 上原 将司 on 2013/09/28.
//  Copyright (c) 2013年 ProjectJB. All rights reserved.
//

#import "JBFirstViewController.h"
#import "JBAppDelegate.h"

@interface JBFirstViewController ()

@end

@implementation JBFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    JBAppDelegate *appDelegate = (JBAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.imageManager =  appDelegate.imageManager;
    
    self.CompositParam.delegate = self;
    self.CompositParam.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startPicker
{
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark ImageView

- (IBAction)OpenImage1:(id)sender {
    
    self.openMode = 1;
    [self startPicker];
}
- (IBAction)OpenImage2:(id)sender {
    self.openMode = 2;
    [self startPicker];
}

-(void) updateImageView
{
    self.Image1View.image = self.imageManager.image1;
    self.Image2View.image = self.imageManager.image2;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"picker:%.2fx%.2f", image.size.width, image.size.height);
    
    if(self.openMode == 1)
        self.imageManager.image1 = image;
    else if(self.openMode == 2)
        self.imageManager.image2 = image;

    self.imageManager.needUpdate = YES;
    [self updateImageView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self updateImageView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark PickerView

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.imageManager.compositList count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.imageManager.compositList objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row != self.imageManager.compositMode)
    {
        self.imageManager.compositMode = row;
        self.imageManager.needUpdate = YES;
    }
}



@end
