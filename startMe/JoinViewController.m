//
//  JoinViewController.m
//  startMe
//
//  Created by Matteo Gobbi on 20/12/12.
//  Copyright (c) 2012 Matteo Gobbi. All rights reserved.
//

#import "JoinViewController.h"
#import "MasterViewController.h"
#import "ExploreViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation JoinViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];

    btJoin = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(join:)] autorelease];
    [self.navigationItem setRightBarButtonItem:btJoin];
}

-(void)initializeUIView{
    firstName.layer.borderColor=[UIColor grayColor].CGColor;
    firstName.layer.borderWidth=1.0f;
    lastName.layer.borderColor=[UIColor grayColor].CGColor;
    lastName.layer.borderWidth=1.0f;
    emailTF.layer.borderColor=[UIColor grayColor].CGColor;
    emailTF.layer.borderWidth=1.0f;
    emailConfirm.layer.borderColor=[UIColor grayColor].CGColor;
    emailConfirm.layer.borderWidth=1.0f;
    passwordTF.layer.borderColor=[UIColor grayColor].CGColor;
    passwordTF.layer.borderWidth=1.0f;
    passwordTF.secureTextEntry = YES;
    passwordConfirm.layer.borderColor=[UIColor grayColor].CGColor;
    passwordConfirm.layer.borderWidth=1.0f;
    passwordConfirm.secureTextEntry = YES;
    termsofuse.layer.borderColor=[UIColor grayColor].CGColor;
    termsofuse.layer.borderWidth=1.0f;
    if(_user){
        emailTF.text = _user.email;
        firstName.text = _user.name;
        lastName.text = _user.surname;
        passwordTF.placeholder = @"new password";
        passwordConfirm.placeholder = @"new password confirm";
        [termsofuse setHidden:YES];
        [joinFB setHidden:YES];
    }
    [self.navigationItem setTitle:NSLocalizedString((_user) ? @"titleEditProfile" : @"titleSignUp", nil)];
}

-(void)viewDidLoad {
    /***Localized string nib***/
    [self initializeUIView];
    /********/
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)setUser:(User *)user
{
    _user = user;
    [self initializeUIView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ProfileToEdit"]){
        ExploreViewController *source = (ExploreViewController *)segue.sourceViewController;
        _user = source.userInfo;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"sectionProfile",nil);
            break;
        case 1:
            return NSLocalizedString(@"sectionEmail",nil);
        case 2:
            return NSLocalizedString(@"sectionPassword",nil);
        default:
            break;
    }
    
    return @"";
}
/******/

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField)
    [myScroll setContentOffset:CGPointMake(0, -myScroll.contentInset.bottom) animated:YES];
    
    return YES;
}


- (BOOL) textFieldShouldReturn:(UITextField*)textField {
    if([textField isEqual:passwordConfirm]){
        [textField resignFirstResponder];
        [self join:self];
        return YES;
    }else{
        [self.view endEditing:YES];
        [myScroll setContentOffset:CGPointMake(0, -myScroll.contentInset.top) animated:YES];
    }
    return YES ;
}


#pragma mark - My Methods


-(void)join:(id)sender {
    [self startModeLoadingWithText:(_user) ? NSLocalizedString(@"Refresh", nil) : NSLocalizedString(@"Sign up", nil)];
    
    NSString *name = firstName.text;
    NSString *surname = lastName.text;
    NSString *email = emailTF.text;
    NSString *password = passwordTF.text;
    NSString *passwordC = passwordConfirm.text;
     
    
    name = [Utility encryptString:name];
    surname = [Utility encryptString:surname];
    email = [Utility encryptString:email];
    password = [Utility encryptString:password];
    passwordC = [Utility encryptString:passwordC];
    
    NSString *str = [URL_SERVER stringByAppendingString:(_user) ? @"edit_profile.php" : @"register.php"];
    
    //Start parser thread
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:email forKey:@"email"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:passwordC forKey:@"passwordC"];
    [request setPostValue:name forKey:@"name"];
    [request setPostValue:surname forKey:@"surname"];
    
    if(_user) {
        NSString *device = [Utility encryptString:[Utility getDeviceAppId]];
        NSString *session = [Utility encryptString:[Utility getSession]];
        NSString *token = [Utility encryptString:[Utility getDeviceToken]];
        
        [request setPostValue:device forKey:@"device"];
        [request setPostValue:session forKey:@"session"];
        [request setPostValue:token forKey:@"token"];
        [request setPostValue:[Utility encryptString:[Utility getAppVersion]] forKey:@"app_version"];
    }
    
    [request setDelegate:self];
    [request startAsynchronous];
}


//Login parser end
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self stopModeLoading];
    if (request.responseStatusCode == 200) {
        NSString *responseString = [request responseString];
        NSDictionary *responseDict = [responseString JSONValue];
        
        //If i'm editing profile check if i'm logged
        if(_user) {
            NSString *logged = [responseDict valueForKey:@"logged"];
        
            if([logged isEqualToString:@"OLDappVersion"]) {
                //Show alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:NSLocalizedString(@"messageVersionOld", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [[DataManager getInstance] logout];
                [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
            } else if([logged isEqualToString:@"-1"]) {
                //Show alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Server error", nil) message:NSLocalizedString(@"messageDatabaseError", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                return;
            } else if([logged isEqualToString:@"0"]) {
                //Show alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:[NSString stringWithFormat:NSLocalizedString(@"errorSession", nil), APP_TITLE] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [[DataManager getInstance] logout];
                [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
                
                return;
            }
        }
        
        
        NSString *response = [responseDict valueForKey:@"join"];
        
        NSString *message = [[[NSString alloc] init] autorelease];
    
        if([response isEqualToString:@"OKjoin"]) {
            //Get masterViewController
            if(!_user) {
                [self login];
            } else {
                NSString *name = firstName.text;
                NSString *surname = lastName.text;
                NSString *email = emailTF.text;
                
                [_user setName:name];
                [_user setSurname:surname];
                [_user setEmail:email];
                
                [self.navigationController popViewControllerAnimated:YES];
                ExploreViewController *profileView = (ExploreViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 1];
                
                [profileView.tableList reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            return;
            
        } else if([response isEqualToString:@"KOjoin"]) {
            if(_user)
                message = NSLocalizedString(@"errorEditAccount", nil);
            else
                message = NSLocalizedString(@"errorCreateAccount", nil);
        } else if([response isEqualToString:@"INVALIDname"]) {
            message = NSLocalizedString(@"INVALIDname", nil);
        } else if([response isEqualToString:@"INVALIDsurname"]) {
            message = NSLocalizedString(@"INVALIDsurname", nil);
        } else if([response isEqualToString:@"EXISTemail"]) {
            message = NSLocalizedString(@"EXISTemail", nil);
        } else if([response isEqualToString:@"INVALIDpass"]) {
            message = NSLocalizedString(@"INVALIDpass", nil);
        } else if([response isEqualToString:@"INVALIDmail"]) {
            message = NSLocalizedString(@"INVALIDmail", nil);
        } else if([response isEqualToString:@"INEQUALpass"]) {
            message = NSLocalizedString(@"INEQUALpass", nil);
        } else if([response isEqualToString:@"INEQUALmail"]) {
            message = NSLocalizedString(@"INEQUALmail", nil);
        }
        
        //Show alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error", nil) message:NSLocalizedString(@"messageConnectionError", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self stopModeLoading];
    NSError *error = [request error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error", nil) message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

//Disable command and active loading
-(void)setModeLoading:(BOOL)active withText:(NSString *)text {
    [super setModeLoading:active withText:text];
    
    //Set extra controls (ex. Button item on navBar)
    btJoin.enabled = !active;
}


//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [myScroll setContentOffset:CGPointMake(0, -myScroll.contentInset.top) animated:YES];
    [self.view endEditing:YES];
}



-(void)login {
    //Launch login from loginViewController
    
    //Get masterViewController
    MasterViewController *master = (MasterViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    //Get value from self
    NSString *email = emailTF.text;
    NSString *password = passwordTF.text;
    
    //Set field
    ((UITextField *)[[master.tb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:11]).text = email;
    ((UITextField *)[[master.tb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] viewWithTag:11]).text = password;
    
    //Login
    [master login];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
    [joinFB release];
    [super dealloc];
}

@end
