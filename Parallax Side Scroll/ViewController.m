//
//  ViewController.m
//  Parallax Side Scroll
//
//  Created by Vinay Nair on 19/04/14.
//  Copyright (c) 2014 vin. All rights reserved.
//

#import "ViewController.h"
#import "ParallaxSideScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSMutableArray *imageViews = [NSMutableArray array];
  
  for (int i = 0; i < 3; i++) {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    
    NSString *imagePath = [NSString stringWithFormat:@"bg_temp_%d.jpg", i+1];
    imageView.image = [UIImage imageNamed:imagePath];
    
    [imageViews addObject:imageView];
  }

  self.mainScrollView.borderWidth = 1;
  self.mainScrollView.views = imageViews;
  
//  self.mainScrollView.imageNames = @[@"bg_temp_3.jpg",@"bg_temp_2.jpg",@"bg_temp_1.jpg"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
