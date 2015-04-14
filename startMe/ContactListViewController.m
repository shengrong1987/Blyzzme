//
//  ContactListViewController.m
//  startMe
//
//  Created by sheng rong on 4/16/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "ContactListViewController.h"
#import "ExploreViewController.h"
#import "User.h"
#import "Utility.h"

#define TAG_BUTTON_CONTROL 99;

@interface ContactListViewController (){
    CGRect tabBarOriginalSize;
}
@end

@implementation ContactListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrUsers = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.navigationItem.backBarButtonItem setTitle:(_nickname && ![_nickname isEqualToString:@""]) ? [@"@" stringByAppendingString:_nickname] : @""];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{
                              NSFontAttributeName:NAVBAR_FONT,
                              NSForegroundColorAttributeName:NAVBAR_TITLE_COLOR,
                              }];
    
    _listType = (_listType == kListTypeNone? kListTypeFollowing : _listType);
    _user_id = !_user_id ? [Utility getUserId] : _user_id;
    _nickname = !_nickname ? [Utility getNickname] : _nickname;
    tabBarOriginalSize = self.tabBarController.tabBar.frame;
    
    switch (_listType) {
        case kListTypeFollowers:
            [self.navigationItem setTitle:NSLocalizedString(@"titleFollower", nil)];
            break;
        case kListTypeFollowing:
            [self.navigationItem setTitle:NSLocalizedString(@"titleFollowing", nil)];
            break;
        case kListTypeLike:
            [self.navigationItem setTitle:NSLocalizedString(@"titleLike", nil)];
            [self.segementControl setSelected:NO];
            [self.segementControl setSelectedSegmentIndex:-1];
            break;
        default:
            break;
    }
    
    self.contactlistTable.delegate = self;
    self.contactlistTable.dataSource = self;
    
    [self.segementControl setFrame:CGRectMake(self.segementControl.frame.origin.x, self.segementControl.frame.origin.y, self.segementControl.frame.size.width, 40)];
    
    [self.segementControl setTintColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]];
    [self.segementControl addTarget:self action:@selector(switchFollowingAndFollowed) forControlEvents:UIControlEventValueChanged];
    
    [self refresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.frame = tabBarOriginalSize;
}

-(void)switchFollowingAndFollowed{
    int index = (int)[self.segementControl selectedSegmentIndex];
    if(index==0){
        //goto Following
        _listType = kListTypeFollowing;
        [self refresh];
        
    }else{
        //goto Followers
        _listType = kListTypeFollowers;
        [self refresh];
    }
}

-(void)refresh{
    [self.segementControl setImage:[[UIImage imageNamed:@"following_normal.jpg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
    [self.segementControl setImage:[[UIImage imageNamed:@"follower_normal.jpg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
    switch (_listType) {
        case kListTypeFollowers:
            [self.segementControl setImage:[[UIImage imageNamed:@"follower_selected.jpg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
            [self.navigationItem setTitle:NSLocalizedString(@"titleFollower", nil)];
            break;
        case kListTypeFollowing:
            [self.segementControl setImage:[[UIImage imageNamed:@"following_selected.jpg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
            [self.navigationItem setTitle:NSLocalizedString(@"titleFollowing", nil)];
            break;
        case kListTypeLike:
            [self.navigationItem setTitle:NSLocalizedString(@"titleLike", nil)];
            break;
        default:
            break;
    }
    [self startModeLoadingWithText:NSLocalizedString(@"Loading", nil)];
    
    //Send request
    NSString *device = [Utility encryptString:[Utility getDeviceAppId]];
    NSString *session = [Utility encryptString:[Utility getSession]];
    NSString *token = [Utility encryptString:[Utility getDeviceToken]];
    NSString *user_list_type = [Utility encryptString:[NSString stringWithFormat:@"%lu",(unsigned long)_listType]];
    NSString *myId = [Utility encryptString:(_listType == kListTypeLike) ? _post_id : _user_id];
    
    NSString *str = [URL_SERVER stringByAppendingString:@"get_users.php"];
    
    //Start parser thread
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:device forKey:@"device"];
    [request setPostValue:session forKey:@"session"];
    [request setPostValue:token forKey:@"token"];
    [request setPostValue:[Utility encryptString:[Utility getAppVersion]] forKey:@"app_version"];
    [request setPostValue:user_list_type forKey:@"user_list_type"];
    [request setPostValue:myId forKey:(_listType == kListTypeLike) ? @"post_id" : @"user_id"];
    [request setPostValue:[Utility encryptString:[Utility getUserId]] forKey:@"me_id"];
    
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)followRequest:(BOOL)follow userId:(NSString *)user_id
{
    //Start parser thread
    NSString *device = [Utility encryptString:[Utility getDeviceAppId]];
    NSString *session = [Utility encryptString:[Utility getSession]];
    NSString *token = [Utility encryptString:[Utility getDeviceToken]];
    NSString *followed_id = [Utility encryptString:user_id];
    NSString *value = [Utility encryptString:[NSString stringWithFormat:@"%d", follow]];
    
    //Attach last followed received
    NSString *followed_last_refresh = [Utility getDefaultValueForKey:FOLLOWED_LAST_REFRESH];
    followed_last_refresh = (![followed_last_refresh isEqualToString:@""]) ? [Utility encryptString:followed_last_refresh] : [Utility encryptString:@"0"];
    //***
    
    NSString *str = [URL_SERVER stringByAppendingString:@"follow.php"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:device forKey:@"device"];
    [request setPostValue:session forKey:@"session"];
    [request setPostValue:token forKey:@"token"];
    [request setPostValue:[Utility encryptString:[Utility getAppVersion]] forKey:@"app_version"];
    [request setPostValue:followed_id forKey:@"followed_id"];
    [request setPostValue:value forKey:@"value"];
    [request setPostValue:followed_last_refresh forKey:@"followed_last_refresh"];
    [request setMethod:SERVICE_FOLLOW];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //Only if controller isn't presented with curl
    [self stopModeLoading];
    //[self.refreshControl endRefreshing];
    
    
    if (request.responseStatusCode == 200) {
        NSString *responseString = [request responseString];
        NSDictionary *responseDict = [responseString JSONValue];
        
        NSString *logged = [responseDict valueForKey:@"logged"];
        
        if([logged isEqualToString:@"1"]) {
            
            //Session valid
            NSString *response = [responseDict valueForKey:@"response"];
            
            
            if([response isEqualToString:@"-1"]) {
                
                //Show alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore del server" message:@"C'è stato un errore nella connessione al database! Riprova più tardi, grazie." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            } else if([response isEqualToString:@"1"]) {
                
                //GOOD Response
                [_arrUsers removeAllObjects];
                
                NSArray *users = (NSArray *)[responseDict valueForKey:@"users"];
                if([users count] > 0) {
                    for(NSDictionary *u in users) {
                        User *user = [[User alloc] initWithEncryptedDictonary:u];
                        [_arrUsers addObject:user];
                        [user release];
                    }
                }
                
                [self.contactlistTable reloadData];
            }
            
        } else if([logged isEqualToString:@"OLDappVersion"]) {
            //Show alert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:NSLocalizedString(@"messageVersionOld", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            [[DataManager getInstance] logout];
            [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
        } else if([logged isEqualToString:@"-1"]) {
            //Show alert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore del server" message:@"C'è stato un errore nella connessione al database, riprova più tardi, grazie." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else if([logged isEqualToString:@"0"]) {
            //Show alert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:[NSString stringWithFormat:@"La sessione di login non è valida, accedi nuovamente a %@!", APP_TITLE] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            [[DataManager getInstance] logout];
            [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore di connessione" message:@"C'è stato un errore durante la connessione al server. Assicurati di avere una connessione ad internet attiva oppure riprova più tardi, grazie." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_arrUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIButton *control = (UIButton *)[cell viewWithTag:99];
    [control setHidden:((_listType==kListTypeFollowing||_listType==kListTypeLike)?NO:YES)];
    [control setBackgroundImage:[UIImage imageNamed:@"contact_followed.png"] forState:UIControlStateSelected];
    [control setBackgroundImage:[UIImage imageNamed:@"contact_following.png"] forState:UIControlStateNormal];
    [control setTitle:@"Following" forState:UIControlStateNormal];
    [control setTitle:@"Follow" forState:UIControlStateSelected];
    
    [control addTarget:self action:@selector(followedORUnfollowed:) forControlEvents:UIControlEventTouchUpInside];
    RoundCornerImageView *imgProfileView = (RoundCornerImageView *)[cell viewWithTag:10];
    [imgProfileView setCircleMask];
    UILabel *name = (UILabel *)[cell viewWithTag:11];
    UILabel *nickname = (UILabel *)[cell viewWithTag:12];
    
    User *user = [_arrUsers objectAtIndex:indexPath.row];
    
    [control setSelected:!user.is_followed];
    
    [name setText:[NSString stringWithFormat:@"%@ %@",user.name,user.surname]];
    [nickname setText:user.nickname];
    [imgProfileView setImage:user.imgProfile];
    
    return cell;
}

#pragma mark - table delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    User *user = (User *)[_arrUsers objectAtIndex:index];
    
    ExploreViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    vc.id_from = user.user_id;
    vc.nickname = [user.nickname stringByReplacingOccurrencesOfString:@"@" withString:@""];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TARGET ACTION
-(void)followedORUnfollowed:(UIButton *)sender{
    CGPoint p = sender.center;
    p = [self.contactlistTable convertPoint:p fromView:sender.superview];
    NSIndexPath *path = [self.contactlistTable indexPathForRowAtPoint:p];
    User *user = [_arrUsers objectAtIndex:path.row];
    NSString *my_id = [Utility getUserId];
    if([user.user_id isEqualToString:my_id]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can't followed yourself." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    [self followRequest:sender.selected userId:user.user_id];
    [sender setSelected:!sender.selected];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    User *u = [_arrUsers objectAtIndex:[(UITableView *)self.view indexPathForCell:(UITableViewCell *)sender].row];
 
    ExploreViewController *vc = (ExploreViewController *)segue.destinationViewController;
    vc.nickname = [u.nickname substringFromIndex:1];
}

- (void)dealloc {
    [_contactlistTable release];
    [super dealloc];
}
@end
