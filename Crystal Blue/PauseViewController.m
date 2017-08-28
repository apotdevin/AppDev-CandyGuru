//
//  PauseViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/3/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "PauseViewController.h"
#import "CrystalAppDelegate.h"
#import "ClientsAtHome.h"
#import "BannerHelper.h"
#import "SoundHelper.h"
#import "RMStore.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ParseHelper.h"

@interface PauseViewController ()

@end

@implementation PauseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends", @"publish_actions"];
    
    BOOL productPurchased=NO;
    if ([GameSaveState sharedGameData].removeBanners==641) {
        productPurchased=YES;
    }
    if (!productPurchased) {
        [self.view addSubview:[BannerHelper sharedAd].bannerView];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height-25);
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"terminoTutorial"]!=YES) {
        [BannerHelper sharedAd].bannerView.alpha = 0;
    }
    
    [self startControl];
    [self startInterface];
    
    if ([PFUser currentUser] && // Check if user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [facebookButton setTitle:@"Log out" forState:UIControlStateNormal];
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LastSaveDate"]!=nil) {
        NSDate *StrDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"LastSaveDate"];
        NSDateFormatter *Dateformat = [[NSDateFormatter alloc]init];
        [Dateformat setDateFormat:@"HH:mm:ss  dd-MM"];
        NSString *DateStr = [Dateformat stringFromDate:StrDate];
        
        lastSaveLabel.text = [NSString stringWithFormat:@"Last: %@",DateStr];
    }
    else
    {
        lastSaveLabel.text = @"Last: Never Saved";
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startControl
{
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    pageControl.backgroundColor = [UIColor colorWithRed:0.6039216 green:0.7411765 blue:0.9058824 alpha:1];
}

- (void)resetDefaults {
    
    [[GameCenterHelper sharedGC] resetAchievements];
    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewApp"];
    [[GameSaveState sharedGameData] newGame];
    [[ClientsAtHome sharedClientData] newGame];
    
    [[GameSaveState sharedGameData]saveGame];
    [[ClientsAtHome sharedClientData]saveGame];
}

- (void)startInterface
{
    soundOnOrOff = [[NSUserDefaults standardUserDefaults]integerForKey:@"soundOnOrOff"];
    
    muteButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    creditsButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    tutorialButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    resetGameButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    backHomeButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    resetYesButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    resetNoButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    questionLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    contactButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    gameCenterButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    restorePurchasesButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    rateButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    
    /*[muteButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [creditsButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [tutorialButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [resetGameButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [backHomeButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [resetYesButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [resetNoButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    questionLabel.textColor = [UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1];
    [contactButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [gameCenterButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [restorePurchasesButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [rateButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];*/
    
    resetYesButton.hidden = YES;
    resetNoButton.hidden = YES;
    questionLabel.hidden = YES;
    
    if (soundOnOrOff==0) {
        [muteButton setTitle:@"Mute Game" forState:UIControlStateNormal];
    }
    else
    {
        [muteButton setTitle:@"Unmute Game" forState:UIControlStateNormal];
    }
    
    creditsImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [creditsImageButton addTarget:self action:@selector(creditsDismissButton:) forControlEvents:UIControlEventTouchUpInside];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    creditsImageButton.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    creditsImageButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    creditsImageButton.titleLabel.numberOfLines = 20;
    creditsImageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    creditsImageButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:24];
    [creditsImageButton setTitle:@"\n...Anthony...\n...and...\n...Christian...\n\n...Potdevin..." forState:UIControlStateNormal];
    //[creditsImageButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [creditsImageButton setBackgroundColor:[UIColor blackColor]];
    creditsImageButton.alpha = 0.9;
    creditsImageButton.hidden = YES;
    [self.view addSubview:creditsImageButton];
    /*
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstViewPause"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewPause"];
        [tutorialButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }*/
}

- (IBAction)creditsDismissButton:(id)sender
{
    creditsImageButton.hidden = YES;
}

- (IBAction)muteButtonPressed:(id)sender
{
    if (soundOnOrOff==0) {
        soundOnOrOff=1;
        [[NSUserDefaults standardUserDefaults]setInteger:soundOnOrOff forKey:@"soundOnOrOff"];
        [[SoundHelper sharedSoundInstance] stopBackground];
        [muteButton setTitle:@"Unmute Game" forState:UIControlStateNormal];
    }
    else
    {
        soundOnOrOff=0;
        [[NSUserDefaults standardUserDefaults]setInteger:soundOnOrOff forKey:@"soundOnOrOff"];
        [[SoundHelper sharedSoundInstance] playBackground];
        [muteButton setTitle:@"Mute Game" forState:UIControlStateNormal];
    }
}

- (IBAction)creditsButtonPressed:(id)sender
{
    creditsImageButton.hidden = NO;
}

- (IBAction)resetGameButtonPressed:(id)sender
{
    resetGameButton.hidden = YES;
    resetYesButton.hidden = NO;
    resetNoButton.hidden = NO;
    questionLabel.hidden = NO;
}

- (IBAction)resetYesButtonPressed:(id)sender
{
    //questionLabel.center = CGPointMake(160, 195-34*[GameSaveState sharedGameData].screenSize);
    //questionLabel.text = @"Game was Reset!";
    [resetGameButton setTitle:@"Game was Reset!" forState:UIControlStateNormal];
    resetGameButton.hidden = NO;
    resetGameButton.enabled = NO;
    questionLabel.hidden = YES;
    resetYesButton.hidden = YES;
    resetNoButton.hidden = YES;
    [self resetDefaults];
    [[ParseHelper sharedParseData] saveOldGame];
}

- (IBAction)resetNoButtonPressed:(id)sender
{
    resetGameButton.hidden = NO;
    resetYesButton.hidden = YES;
    resetNoButton.hidden = YES;
    questionLabel.hidden = YES;
}

- (IBAction)contactButtonPressed:(id)sender
{
    NSString *emailTitle = @"App Support";
    NSArray *toRecipents = [NSArray arrayWithObject:@"tipsyelephantapps@gmail.com"];
    
    MFMailComposeViewController *mailC = [[MFMailComposeViewController alloc] init];
    mailC.mailComposeDelegate = self;
    [mailC setSubject:emailTitle];
    [mailC setToRecipients:toRecipents];
    
    [self presentViewController:mailC animated:YES completion:NULL];
}

- (IBAction)shareButtonPressed:(id)sender
{
    [[GameCenterHelper sharedGC] reportScore];
    [[GameCenterHelper sharedGC] showLeaderboardOnViewController:self];
}

- (IBAction)restorePurchasesButtonPressed:(id)sender
{
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^{
        NSLog(@"Transactions restored");
    } failure:^(NSError *error) {
        NSLog(@"Something went wrong");
    }];
}

- (IBAction)rateButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=910024025&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
}

- (IBAction)facebookButtonPressed:(id)sender
{
    if ([facebookButton.titleLabel.text isEqualToString:@"Log in with Facebook"]) {
        // Set permissions required from the facebook user account
        NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends"];
        
        // Login PFUser using Facebook
        [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            //[activityIndicator stopAnimating]; // Hide loading indicator
            
            if (!user) {
                //NSString *errorMessage = nil;
                if (!error) {
                    NSLog(@"Uh oh. The user cancelled the Facebook login.");
                    //errorMessage = @"Uh oh. The user cancelled the Facebook login.";
                } else {
                    NSLog(@"Uh oh. An error occurred: %@", error);
                    //errorMessage = [error localizedDescription];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                                    message:@"Please try again later."
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"Dismiss", nil];
                    [alert show];
                }
            } else {
                
                int loadView=0;
                
                if (user.isNew) {
                    NSLog(@"User with facebook signed up and logged in!");
                    
                    user[@"Modify"]=@0;
                    [[ParseHelper sharedParseData] saveOldGame];
                } else {
                    NSLog(@"User with facebook logged in!");
                    
                    loadView=1;
                }
                FBRequest *request = [FBRequest requestForMe];
                [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // result is a dictionary with the user's Facebook data
                        NSDictionary *userData = (NSDictionary *)result;
                        
                        NSString *name = userData[@"name"];
                        NSString *firstName = [[name componentsSeparatedByString:@" "] objectAtIndex:0];
                        
                        PFUser *user = [PFUser currentUser];
                        user[@"Name"]=name;
                        user[@"FBID"]=[result objectForKey:@"id"];
                        [user saveInBackground];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:firstName forKey:@"facebookUser"];
                        [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"facebookCompleteName"];
                    }
                }];
                [facebookButton setTitle:@"Log out" forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedInFacebook"];
                
                if (loadView==1) {
                    NSString *storyboardName = @"Main";
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                    UIViewController *fbl = [storyboard instantiateViewControllerWithIdentifier:@"loadScreen"];
                    fbl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:fbl animated:YES completion:nil];
                }
                
            }
        }];
    }
    else
    {
        [PFUser logOut]; // Log out
        [facebookButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedInFacebook"];
    }
}

- (IBAction)saveButtonPressed:(id)sender
{
    if ([PFUser currentUser] &&[PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        [[ParseHelper sharedParseData] saveOldGame];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LastSaveDate"]!=nil) {
            NSDate *StrDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"LastSaveDate"];
            NSDateFormatter *Dateformat = [[NSDateFormatter alloc]init];
            [Dateformat setDateFormat:@"HH:mm:ss  dd-MM"];
            NSString *DateStr = [Dateformat stringFromDate:StrDate];
            
            lastSaveLabel.text = [NSString stringWithFormat:@"Last: %@",DateStr];
        }
        else
        {
            lastSaveLabel.text = @"Last: Never Saved";
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not logged in"
                                                        message:@"Log in with Facebook to save your game!"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[BannerHelper sharedAd].bannerView removeFromSuperview];
    [super viewWillDisappear:animated];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)unwindToPause:(UIStoryboardSegue*)unwindSegue
{
    
}
/*
// Call method when user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookUser"] isEqualToString:user.first_name]) {
        PFObject *userObject = [PFObject objectWithClassName:@"FbUser"];
        userObject[@"Name"] = user.name;
        userObject[@"Link"] = user.link;
        userObject[@"Email"] = [user objectForKey:@"email"];
        [userObject saveEventually];
        
        [[NSUserDefaults standardUserDefaults] setObject:user.first_name forKey:@"facebookUser"];
        [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:@"facebookCompleteName"];
        [[NSUserDefaults standardUserDefaults] setObject:user.link forKey:@"facebookUserLink"];
        [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"email"] forKey:@"facebookUserEmail"];
    }
}

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [[NSUserDefaults standardUserDefaults] setObject:@"NONE" forKey:@"facebookUser"];
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user performs an action outside of you app to recover,
    // the SDK provides a message, you just need to surface it.
    // This handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}*/




@end
