//
//  SevenTabBar.m
//  CET4Lite
//
//  Created by Seven Lee on 12-4-9.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "SevenTabBar.h"
#import "JSBadgeView.h"
#define TabBarBackgroundImageViewTag 11111

@implementation SevenTabBar
@synthesize tabBarBackgroundImage                       = _tabBarBackgroundImage;
@synthesize unSelectedImageArray                        = _unSelectedImageArray;
@synthesize selectedImageArray                          = _selectedImageArray;
@synthesize itemBgImageViewArray                        = _itemBgImageViewArray;
@synthesize lastSelectedIndex                           = _lastSelectedIndex;
@synthesize hiddenIndex                                 = _hiddenIndex;
@synthesize itemBadgeViewArray                          = _itemBadgeViewArray;

//- (void)dealloc
//{   
//    self.tabBarBackgroundImage = nil;
//    self.unSelectedImageArray = nil;
//    self.selectedImageArray = nil;
//    self.itemBgImageViewArray = nil;
//    [super dealloc];
//}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    self.tabBarBackgroundImage = nil;
    
}

- (id)initWithTabBarBackgroundImage:(UIImage *)barBackgroundImage 
               unSelectedImageArray:(NSMutableArray *)unImageArray
                 selectedImageArray:(NSMutableArray *)imageArray {
    self = [super init];
    if (self) {
        
		self.tabBarBackgroundImage = barBackgroundImage;
        self.unSelectedImageArray = unImageArray;
        self.selectedImageArray = imageArray;
        
        self.itemBgImageViewArray = [NSMutableArray array];
        _lastSelectedIndex = 0;
        _hiddenIndex = -1;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.tabBarBackgroundImage = [UIImage imageNamed:@"Tabbar.png"];
        //        self.tabBarBackgroundImage = nil;
        
        NSMutableArray *aunSelectedImageArray = [[NSMutableArray alloc] initWithObjects:
												 [UIImage imageNamed:@"TabItem0.png"], 
                                                 [UIImage imageNamed:@"TabItem1.png"], 
                                                 [UIImage imageNamed:@"TabItem2.png"], 
                                                 [UIImage imageNamed:@"TabItem3.png"],
                                                 [UIImage imageNamed:@"TabItem4.png"], nil];
        self.unSelectedImageArray = aunSelectedImageArray;
        //        [aunSelectedImageArray release];
        
        NSMutableArray *aselectedImageArray = [[NSMutableArray alloc] initWithObjects:
											   [UIImage imageNamed:@"TabItem0_Select.png"], 
                                               [UIImage imageNamed:@"TabItem1_Select.png"], 
                                               [UIImage imageNamed:@"TabItem2_Select.png"], 
                                               [UIImage imageNamed:@"TabItem3_Select.png"], 
                                               [UIImage imageNamed:@"TabItem4_Select.png"],nil];
        self.selectedImageArray = aselectedImageArray;
        //        [aselectedImageArray release];
        
        self.itemBgImageViewArray = [NSMutableArray array];
        _lastSelectedIndex = 0;
        _hiddenIndex = -1;
        
    }
    return self;
}


#pragma mark - itemIndex methods

- (void)setLastSelectedIndex:(int)lastSelectedIndex {
    if (_lastSelectedIndex != lastSelectedIndex) {
        //将上次的选中效果取消
        UIImageView *lastSelectedImageView = (UIImageView *)[_itemBgImageViewArray objectAtIndex:_lastSelectedIndex];;
        lastSelectedImageView.image = [_unSelectedImageArray objectAtIndex:_lastSelectedIndex];
        
        _lastSelectedIndex = lastSelectedIndex;
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    //将上次的选中效果取消
    self.lastSelectedIndex = selectedIndex;
    //将本次的选中效果显示
    UIImageView *selectedImageView = (UIImageView *)[_itemBgImageViewArray objectAtIndex:selectedIndex];
    selectedImageView.image = [_selectedImageArray objectAtIndex:selectedIndex];
	
}

//隐藏某个tabBarItem的图片
- (void)hiddeItemImageView:(int)index {
    if (_hiddenIndex != index) {
        _hiddenIndex = index;
        
        UIImageView *hiddenImageView = (UIImageView *)[_itemBgImageViewArray objectAtIndex:_hiddenIndex];
        hiddenImageView.hidden = YES;
    }
}

//显示某个tabBarItem的图片
- (void)showItemImageView:(int)index {
    if (_hiddenIndex == index) {
        
        UIImageView *hiddenImageView = (UIImageView *)[_itemBgImageViewArray objectAtIndex:_hiddenIndex];
        hiddenImageView.hidden = NO;
        
        _hiddenIndex = -1;
    }
}

#pragma mark - View lifecycle

#if 1
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
	
    self.tabBarBackgroundImage = [UIImage imageNamed:@"Tabbar.png"];
    
    NSMutableArray *aunSelectedImageArray = [[NSMutableArray alloc] initWithObjects:
                                             [UIImage imageNamed:@"TabItem0.png"], 
                                             [UIImage imageNamed:@"TabItem1.png"], 
                                             [UIImage imageNamed:@"TabItem2.png"], 
                                             [UIImage imageNamed:@"TabItem3.png"],
                                             [UIImage imageNamed:@"TabItem4.png"], nil];
    self.unSelectedImageArray = aunSelectedImageArray;
    //        [aunSelectedImageArray release];
    
    NSMutableArray *aselectedImageArray = [[NSMutableArray alloc] initWithObjects:
                                           [UIImage imageNamed:@"TabItem0_Select.png"], 
                                           [UIImage imageNamed:@"TabItem1_Select.png"], 
                                           [UIImage imageNamed:@"TabItem2_Select.png"], 
                                           [UIImage imageNamed:@"TabItem3_Select.png"], 
                                           [UIImage imageNamed:@"TabItem4_Select.png"],nil];
    self.selectedImageArray = aselectedImageArray;
    
    //    [aselectedImageArray release];
    self.itemBadgeViewArray = [[NSMutableArray alloc] init];
    self.itemBgImageViewArray = [NSMutableArray array];
    _lastSelectedIndex = 0;
    _hiddenIndex = -1;
}
#endif


#define ItemWidth 62//50
#define ItemHeight 75//49
#define SideMarginX 7////7
#define SideMarginY -18
#define Spacing 0

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *tabBarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -21, self.tabBar.frame.size.width, self.tabBar.frame.size.height + 40)];
    tabBarBackgroundImageView.tag = TabBarBackgroundImageViewTag;
    tabBarBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    tabBarBackgroundImageView.image = _tabBarBackgroundImage;
    //[self.tabBar insertSubview:tabBarBackgroundImageView atIndex:0];
	UITabBar *image = nil;
	for (int i = 0; i < [self.view.subviews count]; i++) {
		if ([[self.view.subviews objectAtIndex:i] isKindOfClass:[UITabBar class]]) {
			image = [self.view.subviews objectAtIndex:i];
			//NSLog(@"%@", image);
		}
	}
	[self.tabBar insertSubview:tabBarBackgroundImageView belowSubview:image];
	//- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview
    //	for (int i = 0; i < [self.view.subviews count]; i++) {
    //		if ([[self.view.subviews objectAtIndex:i] isKindOfClass:[UIView class]]) {
    //			UIView *image = [self.view.subviews objectAtIndex:i];
    //			NSLog(@"i = %d,width is %f", i, image.frame.size.width);
    //		}
    //	}
	//[self.tabBar addSubview:tabBarBackgroundImageView];
    //    [tabBarBackgroundImageView release];
	for (int i = 0; i < 5; i++) {////////////5--4
		UIImageView *itemBg  = [[UIImageView alloc] initWithFrame:CGRectMake(SideMarginX +ItemWidth * i + Spacing * i, SideMarginY, ItemWidth, ItemHeight)];
		itemBg.contentMode = UIViewContentModeScaleAspectFit;
		itemBg.image = [_unSelectedImageArray objectAtIndex:i];
		//[self.tabBar insertSubview:itemBg atIndex:5];
		[self.tabBar insertSubview:itemBg aboveSubview:self.tabBar];
		[_itemBgImageViewArray addObject:itemBg];
        JSBadgeView * badge = [[JSBadgeView alloc] initWithParentView:itemBg alignment:JSBadgeViewAlignmentCenterRight];
        badge.badgePositionAdjustment = CGPointMake(- 10, SideMarginY);
        [badge setBadgeText:@""];
        [self.itemBadgeViewArray addObject:badge];
	}
//    UILabel * badge = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 15, 20)];
//    badge.backgroundColor = [UIColor redColor];
//    badge.text = @"1";
//    [self.tabBar addSubview:badge];
    self.selectedIndex = 0;
}
- (void)setBadgeValue:(NSString *)value atIndex:(int)index{
    JSBadgeView * badge = [self.itemBadgeViewArray objectAtIndex:index];
    [badge setBadgeText:value];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.itemBgImageViewArray = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    self.selectedIndex = [tabBar.items indexOfObject:item];
}

@end
