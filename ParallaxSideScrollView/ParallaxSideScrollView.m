//
//  ParallaxSideScrollView.m
//  Parallax Side Scroll
//
//  Created by Carlos López on 10/06/14.
//  Copyright (c) 2014 vin. All rights reserved.
//

#import "ParallaxSideScrollView.h"

@interface ParallaxSideScrollView()

@property (nonatomic,assign) NSInteger currentPageNumber;
@property (nonatomic,assign) NSInteger otherPageNumber;     //Not the main page being scrolled, its the other page that is being pulled.
@property (nonatomic,assign) CGFloat   percentageMultiplier;//Change to play around with amount of parallax
@property (nonatomic,assign) CGFloat   lastContentOffset;

@end

@implementation ParallaxSideScrollView

- (id)init {
  self = [super init];
  if (self) {
    // Initialization code
    [self initDefaults];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self initDefaults];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame andViews:(NSArray*)views
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      self.views = views;
      [self initDefaults];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andImageNames:(NSArray*)imageNames
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.imageNames = imageNames;
    [self initDefaults];
  }
  return self;
}

- (void)awakeFromNib {
  [self initDefaults];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
  [self loadParallax];
}

- (void)initDefaults {
  self.delegate = self;
  self.borderWidth = 1;
  self.percentageMultiplier = 0.3; //Change to play around with amount of parallax
}

- (void)loadParallax {
  for (int i = 0; i < _views.count; i++) {
    UIView *view = [_views objectAtIndex:i];
    
    CGRect frame = CGRectMake((CGRectGetWidth(self.frame) * i), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    UIView *subview = [[UIView alloc] initWithFrame:frame];
    
    UIScrollView *internalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.borderWidth, 0, CGRectGetWidth(self.frame) - self.borderWidth * 2, CGRectGetHeight(self.frame))];
    [internalScrollView setScrollEnabled:NO];
    internalScrollView.tag = (i + 1) * 10;
    
    view.frame = CGRectMake( 0, 0, CGRectGetWidth(internalScrollView.frame), CGRectGetHeight(self.frame));
    
    [internalScrollView addSubview:view];
    [subview addSubview:internalScrollView];
    [self addSubview:subview];
  }
  
  self.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * _views.count, CGRectGetHeight(self.frame));
}

- (NSArray*)getViewsFromImageNames:(NSArray*)imageNames {
  NSMutableArray *imageViews = [NSMutableArray array];
  
  for (NSString *imageName in imageNames) {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:nil]];
    imgView.image = img;
    [imageViews addObject:imgView];
  }
  
  return imageViews;
}

#pragma mark - Setters

- (void)setViews:(NSArray *)views {
  if (_views) {
    for (UIView *view in _views) {
      [view removeFromSuperview];
    }
    _views = nil;
  }
  _views = views;
  [self setNeedsDisplay];
}

- (void)setImageNames:(NSArray *)imageNames {
  _imageNames = imageNames;
  self.views = [self getViewsFromImageNames:imageNames];
}

#pragma mark - Scroll View Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  UIScrollView *internalScrollView = (UIScrollView *)[scrollView viewWithTag:(self.currentPageNumber+1)*10];
  UIScrollView *otherScrollView = (UIScrollView *)[scrollView viewWithTag:(self.otherPageNumber+1)*10];
  
  [internalScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
  [otherScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
  
  self.currentPageNumber = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  ScrollDirection scrollDirection = ScrollDirectionNone;
  int signMultiplier = 1;
  
  if (self.lastContentOffset > scrollView.contentOffset.x) {
    scrollDirection = ScrollDirectionRight;
    self.currentPageNumber = ceilf(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame));
    if (self.currentPageNumber > 0) {
      self.otherPageNumber = self.currentPageNumber - 1;
    }
    signMultiplier = -1;
  } else if (self.lastContentOffset < scrollView.contentOffset.x) {
    scrollDirection = ScrollDirectionLeft;
    self.currentPageNumber = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    if (self.currentPageNumber < self.views.count) {
      self.otherPageNumber = self.currentPageNumber + 1;
    }
    signMultiplier = 1;
  }
  
  self.lastContentOffset = scrollView.contentOffset.x;
  CGFloat offset = scrollView.contentOffset.x;
  UIScrollView *internalScrollView = (UIScrollView *)[scrollView viewWithTag:(self.currentPageNumber+1)*10];
  UIScrollView *otherScrollView = (UIScrollView *)[scrollView viewWithTag:(self.otherPageNumber+1)*10];
  
  //Set offset to create parallax effect
  [internalScrollView setContentOffset:CGPointMake(-self.percentageMultiplier * (offset - CGRectGetWidth(self.frame) * self.currentPageNumber), 0) animated:NO];
  if (internalScrollView != otherScrollView) {
    [otherScrollView setContentOffset:CGPointMake(signMultiplier * self.percentageMultiplier * CGRectGetWidth(self.frame) - self.percentageMultiplier * (offset - CGRectGetWidth(self.frame) * self.currentPageNumber), 0) animated:NO];
  }
}

@end
