//
//  AnswerCViewController_iPad.h
//  CET4Lite
//
//  Created by Seven Lee on 12-9-27.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FillingTheBlank.h"
#import "AnswerCSingleView.h"

//@class CETAdapter;

@interface AnswerCViewController_iPad : UIViewController{
    FillingTheBlank * _question;
    id<QuestionABViewDelegate,AnswerCDelegate>_delegate;
}
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, strong)FillingTheBlank * question;
@property (nonatomic, strong)id<QuestionABViewDelegate,AnswerCDelegate>delegate;
- (IBAction)addToFavorate:(id)sender;
- (IBAction)playSound:(id)sender;
- (id) initWithQuestion:(FillingTheBlank *)q adapter:(id<QuestionABViewDelegate,AnswerCDelegate>)adpter;
@end
