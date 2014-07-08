//
//  ComposeTweetViewController.m
//  TwitterClient
//
//  Created by Lin Zhang on 6/27/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "UserInfo.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ComposeTweetViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *handle;
@property (nonatomic, strong) UILabel *charsLeft;

@end

@implementation ComposeTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textView.delegate = self;
    
    self.charsLeft = [[UILabel alloc] initWithFrame:CGRectMake(200,20,30,30)];
    self.charsLeft.text = @"140";
    self.charsLeft.textColor = [UIColor grayColor];
    
    //Creating some buttons:
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(didClickCancel)];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(didClickTweet)];
    UIBarButtonItem *countButton = [[UIBarButtonItem alloc] initWithCustomView:self.charsLeft];
                                   
    //Putting the Buttons on the Carrier
    [self.navItem setLeftBarButtonItem:cancelButton];
    
    NSArray *rightBarButtonItems = [[NSArray alloc] initWithObjects: sendButton, countButton, nil];
    
    [self.navItem setRightBarButtonItems:rightBarButtonItems];
    
    self.fullName.text = [User currentUser].data[@"name"];
    self.handle.text = [NSString stringWithFormat:@"@%@",[User currentUser].data[@"screen_name"]];
    
    NSURL *avatarURL = [NSURL URLWithString:[User currentUser].data[@"profile_image_url"]];
    
    [self.avatar setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    //borrow from Guozhang Ge's post
    self.avatar.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.avatar.layer.shadowRadius = 5.0;
    self.avatar.layer.shadowOpacity = 1.0;
    self.avatar.layer.shadowOffset = CGSizeMake(0, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.avatar.bounds cornerRadius:5.0];
    self.avatar.layer.shadowPath = path.CGPath;
    self.avatar.layer.cornerRadius = 5.0;
    self.avatar.layer.borderColor = [[UIColor grayColor] CGColor];
    self.avatar.layer.borderWidth = 1.0;
    self.avatar.layer.masksToBounds = YES;
    
    [self.textView becomeFirstResponder];
    self.textView.keyboardType = UIKeyboardTypeTwitter;
    
    if (self.replyData) {
        self.textView.text = [NSString stringWithFormat:@"@%@ ", self.replyData[@"handle"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ComposeTweetViewController *)initWithReplyData:(NSDictionary *)replyData {
    self = [super init];
    _replyData = replyData;
    return self;
}

#pragma Button Click actions
- (void)didClickTweet {
    [self.view endEditing:YES];
    [self sendTweet:[self createDictionary]];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didClickCancel {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
    return;
}

#pragma TextView Delegate methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    else {
        self.charsLeft.text=[NSString stringWithFormat:@"%lu",140-(textView.text.length + text.length)];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma Custom functions

-(NSDictionary *)createDictionary {
    NSDictionary *dict;
    
    if (self.replyData) {
        dict = @{@"in_reply_to_status_id":self.replyData[@"in_reply_to_status_id"], @"status":self.textView.text};
    }
    else {
        dict = @{@"status":self.textView.text};
    }

    return dict;
}

-(void)sendTweet:(NSDictionary *)dictionary {
    if ([self.delegate respondsToSelector:@selector(sendTweet:)]) {
        [self.delegate sendTweet:dictionary];
    }
}

@end
