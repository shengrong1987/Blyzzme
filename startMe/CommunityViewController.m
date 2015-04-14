//
//  CommunityViewController.m
//  startMe
//
//  Created by Matteo Gobbi on 31/07/13.
//  Copyright (c) 2013 Matteo Gobbi. All rights reserved.
//

#import "CommunityViewController.h"
#import "ChooseProfileImageViewController.h"



@interface CommunityViewController (){
    NSArray * _viewControllers;
}
@end

@implementation CommunityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self addCenterButtonWithImage:[UIImage imageNamed:@"share2.png"] highlightImage:nil];
    
    DataManager *dman = [DataManager getInstance];
    [dman setCommunityViewController:self];
    [dman updateBadgeNotification];
    
    if([Utility userIsLogged]) [[DataManager getInstance] getNotifications];
    
    [self changeTabBarItem:INDEX_OF_FOLLOWING withImagedName:@"btn_home"];
    [self changeTabBarItem:INDEX_OF_EXPLORE withImagedName:@"btn_explore"];
    [self changeTabBarItem:INDEX_OF_CONTACELIST withImagedName:@"btn_contactlist"];
    [self changeTabBarItem:INDEX_OF_NOTIFICATIONS withImagedName:@"btn_information"];
    [self changeTabBarItem:INDEX_OF_PROFILE withImagedName:@"btn_profile"];
}

-(void)changeTabBarItem:(int)index withImagedName:(NSString *)image{
    UITabBarItem *item = [self.tabBar.items objectAtIndex:index];
    UIImage *img1 = [[UIImage imageNamed:[image stringByAppendingString:@".png"]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img2 = [[UIImage imageNamed:[image stringByAppendingString:@"_on.png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //[self.view addSubview:[[UIImageView alloc]initWithImage:img1]];
    item.image = img1;
    item.selectedImage = img2;
    item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    item.title = @"";
}

-(UIButton *)renderTabIcons:(int)index withTitle:(NSString *)title withImagedName:(NSString *)image{
    
    CGFloat x = index * BAR_BUTTON_WIDTH;
    CGFloat y = 0;
    CGFloat width = BAR_BUTTON_WIDTH;
    CGFloat height = BAR_BUTTON_HEIGHT;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, width, height)];
    UIImage *img1 = [UIImage imageNamed:[image stringByAppendingString:@".png"]];
    UIImage *img2 = [UIImage imageNamed:[image stringByAppendingString:@"_on.png"]];
    [btn setBackgroundImage:img1 forState:UIControlStateNormal];
    [btn setBackgroundImage:img2 forState:UIControlStateSelected];
    [btn setTag:index];
    [btn addTarget:self action:@selector(barItemClicked:) forControlEvents:UIControlEventTouchDown];
    if(index==INDEX_OF_EXPLORE){
        [btn setSelected:YES];
        [self.myTabBar selectTab:index];
        [self goToOtherPages:index];
    }
    [self.myTabBar addSubview:btn];
    return btn;
}

-(void)barItemClicked:(UIButton *)sender{
    [self.myTabBar selectTab:(int)sender.tag];
    [self goToOtherPages:(int)sender.tag];
}

-(void)goToOtherPages:(int)index{
    //UIViewController *viewTogo;
    switch (index) {
        case INDEX_OF_EXPLORE:
            break;
        default:
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if(_chooseImage) {
        [self performSegueWithIdentifier:@"CommunityToChooseImageProfile" sender:self];
        _chooseImage = NO;
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"CommunityToChooseImageProfile"]) {
        ((ChooseProfileImageViewController *)segue.destinationViewController).modalityNick = YES;
    }
}


-(void)centerButtonPressed {
    if([DataManager getInstance].isSendingPost) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:NSLocalizedString(@"messageSendingPost", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [super centerButtonPressed];
    
    [self performSegueWithIdentifier:@"CommunityToShare" sender:self];
}

- (void)dealloc {
    [_myTabBar release];
    [super dealloc];
}
@end
