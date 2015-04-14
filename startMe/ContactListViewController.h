//
//  ContactListViewController.h
//  startMe
//
//  Created by sheng rong on 4/16/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactListViewController : CustomViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *contactlistTable;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segementControl;

@property (nonatomic, retain) NSMutableArray *arrUsers;

@property (assign) ListType listType;
@property (nonatomic, assign) NSString *user_id;
@property (nonatomic, assign) NSString *post_id;

@property (nonatomic, retain) NSString *nickname;

@end
