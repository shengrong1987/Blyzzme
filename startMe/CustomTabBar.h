//
//  CustomTabBar.h
//  startMe
//
//  Created by sheng rong on 4/15/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBar : UITabBar
-(void)hideBars:(BOOL)hide;
-(void)selectTab:(int)tag;
-(void)setBarItems:(NSArray *)items;
@end
