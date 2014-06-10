//
//  ParallaxSideScrollView.h
//  Parallax Side Scroll
//
//  Created by Carlos López on 10/06/14.
//  Copyright (c) 2014 vin. All rights reserved.
//

@import UIKit;

typedef enum ScrollDirection {
  ScrollDirectionNone,
  ScrollDirectionRight,
  ScrollDirectionLeft
} ScrollDirection;

@interface ParallaxSideScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *views;
@property (nonatomic,strong) NSArray *imageNames;
@property (nonatomic,assign) CGFloat borderWidth;

- (id)initWithFrame:(CGRect)frame andViews:(NSArray*)views;
- (id)initWithFrame:(CGRect)frame andImageNames:(NSArray*)imageNames;

@end
