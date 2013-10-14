//
//  QuestioinABView.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "QuestioinABView.h"
#import "AppDelegate.h"

@implementation QuestioinABView
@synthesize answerHandler;
@synthesize delegate;
@synthesize myQ;
//初始化
- (id)initWithFrame:(CGRect)frame andQ:(SingleChoice *)q
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        myQ = q;
        ABCDArray = [NSArray arrayWithObjects:@"A", @"B",@"C",@"D",nil];
        delegate = nil;
        [self drawView];
    }
    return self;
}

//绘图
- (void)drawView{
    
    //几个基本点
    CGFloat pointX = 0;
    CGFloat pointY = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
//    //题号Label,在最左上角
//    UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    number.text = [NSString stringWithFormat:@"%d",myQ.Number];
//    number.backgroundColor = [UIColor clearColor];
//    [self addSubview:number];
    
    //Question label
    UILabel * qLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-80-44, 8, 80, 22)];
    qLabel.textColor = [AppDelegate isPad] ? [UIColor brownColor] : [UIColor whiteColor];
    qLabel.text = @"Question:";
    qLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:qLabel];
    //Question按钮
    questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    questionBtn.frame = CGRectMake(qLabel.frame.origin.x + qLabel.frame.size.width, 5, 44, 29);
//    UIImageView * animateImg = questionBtn.imageView;
//    UIImage * img1 = [UIImage imageNamed:@"birdQuestion.png"];
//    UIImage * img2 = [UIImage imageNamed:@"birdQuestion_selected.png"];
    
    UIImage * img1 = [UIImage imageNamed:@"birdQuestionImg1.png"];
    UIImage * img2 = [UIImage imageNamed:@"birdQuestionImg2.png"];
    UIImage * img3 = [UIImage imageNamed:@"birdQuestionImg3.png"];
    [questionBtn setBackgroundImage:[UIImage imageNamed:@"birdQuestionBG.png"] forState:UIControlStateNormal];
    [questionBtn setImage:img3 forState:UIControlStateNormal];
    [questionBtn setImage:img3 forState:UIControlStateHighlighted];
    [questionBtn setImage:img3 forState:UIControlStateSelected];
    imgArray = [[NSArray alloc ]initWithObjects:img1,img2,img3, nil];
    [questionBtn setBackgroundImage:[UIImage imageNamed:@"birdQuestion_selected.png"] forState:UIControlStateHighlighted];
//    [questionBtn setImage:img1 forState:UIControlStateNormal];
//    [questionBtn setImage:img2 forState:UIControlStateHighlighted];
//    [questionBtn setImage:img2 forState:UIControlStateSelected];
    [questionBtn.imageView setAnimationImages:imgArray ];
//    questionBtn.imageView.image = img1;
    [questionBtn.imageView setAnimationRepeatCount:-1];
    [questionBtn.imageView setAnimationDuration:0.5];
    [questionBtn setImage:[imgArray objectAtIndex:2] forState:UIControlStateNormal];
//    [questionBtn setTitle:@"Question" forState:UIControlStateNormal];
//    questionBtn.showsTouchWhenHighlighted = YES;
    questionBtn.tag = 10;
    [questionBtn addTarget:self action:@selector(playQuestionSound) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:questionBtn];
    pointY += [AppDelegate isPad] ? 60 : 40;
    //添加四个选项
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(pointX, pointY, width, height-pointY)];
    ABCDButtonsArray = [[NSMutableArray alloc] init];
    pointY = 0;
    for (int i = 0; i < 4; i++) {
        //str为选项要显示的句子
        NSString * str = [myQ.ForChoices objectAtIndex:i];

        ABCDView * choiceView = [[ABCDView alloc] initWithFrame:CGRectMake(pointX, pointY, width, 0) ChoiceNo:[ABCDArray objectAtIndex:i] Content:str];
        
        choiceView.tag = i;
        UITapGestureRecognizer * tapEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAnswer:)];
        [choiceView addGestureRecognizer:tapEvent];
        [scroll addSubview:choiceView];
        [ABCDButtonsArray addObject:choiceView];
        //选项ABCD的按钮,现在用1\2\3\4代替,套UI后用图片
//        UIButton * choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        choiceBtn.frame = CGRectMake(pointX, choice.frame.origin.y , 30, 30) ;
//        choiceBtn.tag = i;
//        [choiceBtn setBackgroundImage:[UIImage imageNamed:@"buttonback.png"] forState:UIControlStateNormal];
//        [choiceBtn setBackgroundImage:[UIImage imageNamed:@"buttonSelected.png"] forState:UIControlStateSelected];
//        [choiceBtn setTitle:[NSString stringWithFormat:@"%@",[ABCDArray objectAtIndex:i]] forState:UIControlStateNormal];
//        choiceBtn.titleLabel.textColor = [UIColor whiteColor];
////        [choiceBtn setTitle:@"已选" forState:UIControlStateSelected];
//        [ABCDButtonsArray addObject:choiceBtn];
//        [choiceBtn addTarget:self action:@selector(chooseAnswer:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:choiceBtn];
        
        //计算下一个选项的Y坐标,若该选项只有一行,则两选项中间空10个单位
        pointY += choiceView.frame.size.height+ ([AppDelegate isPad]? 30 : 10);
    }
    scroll.contentSize = CGSizeMake(width, pointY);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    [self addSubview:scroll];
}

- (void)playQuestionSound{
    [delegate PlayCurrentQuestionSound:nil];
}
- (void)chooseAnswer:(UITapGestureRecognizer *)sender{
//    sender.selected = YES;
    ABCDView * view =(ABCDView *) sender.view;
    for (UIImageView * img in [self subviews]) {
        if (img.tag == 99) 
            [img removeFromSuperview];
    }
    for (int i = 0; i < 4; i++) {
        if ([[ABCDButtonsArray objectAtIndex:i] tag] != view.tag) {
            [[ABCDButtonsArray objectAtIndex:i] setHighlighted:NO];
        }
    }
    [view setHighlighted:YES];
    [answerHandler restoreCustomAnswer:[ABCDArray objectAtIndex:view.tag] ofNumber:myQ.Number];
//    [self rightOrWrong:sender];
    
}

- (void)ShowRightOrWrongAndDisable{
    
    for (int i = 0; i < 4; i++ ) {
        ABCDView * button = [ABCDButtonsArray objectAtIndex:i];
        button.userInteractionEnabled = NO;
        if ([button.ChoiceName isEqualToString:myQ.answer]) {
            [self addRightOrWrongImage:@"RightTick.png" ofBtn:button];
        }
        else {
//            if (myQ.YourAnswer && ![myQ.YourAnswer isEqualToString:myQ.answer]) {
                [self addRightOrWrongImage:@"WrongX.png" ofBtn:button];
//            }
        }
    }
}

- (void)addRightOrWrongImage:(NSString *)imagename ofBtn:(ABCDView *)button{
    CGFloat width = 16;
    CGFloat height = 14;
//    CGFloat mywid = width > height ? height : width;
    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagename]];
    imgView.tag = 99;
    CGFloat poinX = button.frame.origin.x;
    CGFloat poinY = button.frame.origin.y + height;
    imgView.frame = CGRectMake(poinX, poinY, width , height);
    [scroll addSubview:imgView];
}

- (void)startQuestionButtonAimation{
    [questionBtn.imageView setAnimationImages:imgArray];
    [questionBtn.imageView setAnimationDuration:1];
    [questionBtn.imageView setAnimationRepeatCount:-1];
    [questionBtn.imageView startAnimating];
}
- (void)stopQuestionButtonAimation{
    [questionBtn.imageView stopAnimating];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
