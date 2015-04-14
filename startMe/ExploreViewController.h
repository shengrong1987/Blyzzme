//
//  HomeViewController.h
//  startMe
//
//  Created by Matteo Gobbi on 31/12/12.
//  Copyright (c) 2012 Matteo Gobbi. All rights reserved.
//


#import "RefreshTableViewController.h"
#import "STTweetLabel.h"
#import "Post.h"
#import "User.h"
#import <MessageUI/MessageUI.h>
#import <iAd/iAd.h>
#import "MLPAutoCompleteTextFieldDataSource.h"

@interface ExploreViewController : RefreshTableViewController  <MFMailComposeViewControllerDelegate, UIWebViewDelegate, UIScrollViewDelegate, ADBannerViewDelegate, MLPAutoCompleteTextFieldDataSource, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet CustomTableView *tableList;
@property (strong, nonatomic) NSMutableArray *tagsArray;

@property (retain, nonatomic) NSString *id_from;
@property (retain, nonatomic) NSString *nickname;

@property (retain, nonatomic) NSString *hashtag;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *actLoad;
@property (retain, nonatomic) IBOutlet UIView *settingView;
@property (strong, nonatomic) IBOutlet UIButton *settingBtn;
@property (retain, nonatomic) IBOutlet UIButton *logoutBtn;

@property (strong, nonatomic) User *userInfo;

+(ADBannerView *)bannerView;

@end
