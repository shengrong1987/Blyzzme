//
//  JoinViewController.h
//  startMe
//
//  Created by Matteo Gobbi on 20/12/12.
//  Copyright (c) 2012 Matteo Gobbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "CustomButton.h"

#import "User.h"

@interface JoinViewController : CustomViewController <UITextFieldDelegate, UIScrollViewDelegate, MBProgressHUDDelegate> {
    UIBarButtonItem *btJoin;
    
    IBOutlet UITableView *tb;
    IBOutlet UIScrollView *myScroll;
    IBOutlet UITextField *lastName;
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *emailTF;
    IBOutlet UITextField *emailConfirm;
    IBOutlet UITextField *passwordTF;
    IBOutlet UITextField *passwordConfirm;
    IBOutlet UITextField *termsofuse;
    IBOutlet CustomButton *joinFB;
}

@property (nonatomic, retain) User *user;

@end
