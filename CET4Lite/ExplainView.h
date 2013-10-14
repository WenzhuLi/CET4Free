//
//  ExplainView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Explain.h"
#import "SevenLabel.h"

@interface ExplainView : UIView{
    Explain * myExp;
}
- (id)initWithFrame:(CGRect)frame andExplain:(Explain *)explain;
@end
