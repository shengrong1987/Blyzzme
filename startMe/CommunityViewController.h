//
//  CommunityViewController.h
//  startMe
//
//  Created by Matteo Gobbi on 31/07/13.
//  Copyright (c) 2013 Matteo Gobbi. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomTabBar.h"

@interface CommunityViewController : BaseViewController 

@property (nonatomic, assign) BOOL chooseImage;
@property (retain, nonatomic) IBOutlet CustomTabBar *myTabBar;

@end
