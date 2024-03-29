//
//  SevenTabBar.h
//  CET4Lite
//
//  Created by Seven Lee on 12-4-9.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SevenTabBar : UITabBarController{
	UIImage                             *_tabBarBackgroundImage;  //整个tabBar的背景
    NSMutableArray                       *_unSelectedImageArray;   //非选中效果的tabBarItem数组
    NSMutableArray                       *_selectedImageArray;     //选中效果的tabBarItem数组
    NSMutableArray                       *_itemBgImageViewArray;     //item背景UIIMageView数组
    NSMutableArray                       *_itemBadgeViewArray;     //itemBadgeView数组
    int                                  _lastSelectedIndex;   //上一次选中的tabBarItem的index
    int                                  _hiddenIndex;
}

@property (nonatomic, retain) UIImage                           *tabBarBackgroundImage;
@property (nonatomic, retain) NSMutableArray                    *unSelectedImageArray;
@property (nonatomic, retain) NSMutableArray                    *selectedImageArray;
@property (nonatomic, retain) NSMutableArray                    *itemBgImageViewArray;
@property (nonatomic, assign) int                               lastSelectedIndex;
@property (nonatomic, assign) int                               hiddenIndex;
@property (nonatomic, strong)NSMutableArray * itemBadgeViewArray;

- (id)initWithTabBarBackgroundImage:(UIImage *)barBackgroundImage 
               unSelectedImageArray:(NSMutableArray *)unImageArray
                 selectedImageArray:(NSMutableArray *)imageArray;

//隐藏某个tabBarItem的图片
-(void)hiddeItemImageView:(int)index;
//显示某个tabBarItem的图片
-(void)showItemImageView:(int)index;

- (void)setBadgeValue:(NSString *)value atIndex:(int)index;

@end
