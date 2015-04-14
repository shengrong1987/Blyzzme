//
//  CustomTabBar.m
//  startMe
//
//  Created by sheng rong on 4/15/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar{
    NSArray * _items;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)selectTab:(int)tag
{
    for (UIButton *item in _items) {
        if(item.tag == tag)
            [item setSelected:YES];
        else
            [item setSelected:NO];
    }
}

-(void)setBarItems:(NSArray *)items
{
    _items = items;
}

-(void)hideBars:(BOOL)hide
{
    for (UIButton *item in _items) {
        [item setHidden:hide];
    }
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
