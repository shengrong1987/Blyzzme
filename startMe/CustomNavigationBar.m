//
//  CustomNavigationBar.m
//  startMe
//
//  Created by Matteo Gobbi on 14/10/13.
//  Copyright (c) 2013 Matteo Gobbi. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

-(void)awakeFromNib {
    
    [self setBarTintColor:NAVBAR_BACKGROUND_COLOR];
    [self setTintColor:NAVBAR_BUTTON_COLOR];
    
    [self
     setTitleTextAttributes:@{
                              NSFontAttributeName:NAVBAR_FONT,
                              NSForegroundColorAttributeName:NAVBAR_TITLE_COLOR,
                              }];
}

@end
