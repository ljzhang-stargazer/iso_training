//
//  TweetCell.m
//  TwitterClient
//
//  Created by Lin Zhang on 6/27/14.
//  Copyright (c) 2014 Lin Zhang. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (void)awakeFromNib
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(displayProfile:)];
    [self.avatar setUserInteractionEnabled:YES];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.avatar addGestureRecognizer:tapRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayProfile:(UIGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(displayProfile:)]) {
        [self.delegate displayProfile:sender];
    }
}

@end
