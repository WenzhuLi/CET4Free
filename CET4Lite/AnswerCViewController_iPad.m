//
//  AnswerCViewController_iPad.m
//  CET4Lite
//
//  Created by Seven Lee on 12-9-27.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "AnswerCViewController_iPad.h"


@interface AnswerCViewController_iPad ()

@end

@implementation AnswerCViewController_iPad
@synthesize navigationItem;
@synthesize question = _question;
@synthesize delegate = _delegate;

- (IBAction)addToFavorate:(id)sender {
    if ([self.delegate respondsToSelector:@selector(AddToFavorite)]) {
        [self.delegate AddToFavorite:nil];
    }
}

- (IBAction)playSound:(id)sender {
    if ([self.delegate respondsToSelector:@selector(PlayCurrentQuestionSound)]) {
        [self.delegate PlayCurrentQuestionSound:nil];
    }
}

- (id) initWithQuestion:(FillingTheBlank *)q adapter:(id<QuestionABViewDelegate,AnswerCDelegate>)adpter
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.question = q;
        self.delegate = adpter;
        AnswerCSingleView * single = [[AnswerCSingleView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, self.view.frame.size.height / 2) Delegate:adpter Question:self.question Collection:YES];
        [self.view addSubview:single];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNavigationItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
