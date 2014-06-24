//
//  ToggleViewCell.m
//  Yelp
//
//  Created by Lin Zhang on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ToggleViewCell.h"

@implementation ToggleViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didToggle:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sender:didToggle:)]) {
        [self.delegate sender:self didToggle:((UISwitch*)self.accessoryView).on];
    }
}

@end
