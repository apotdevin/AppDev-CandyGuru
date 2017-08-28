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
#import "RMStore.h"

@interface PauseViewController ()

@end

@implementation PauseViewController

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    BOOL productPurchased=NO;
    if ([GameSaveState sharedGameData].removeBanners==641) {
        productPurchased=YES;
    }
    if (!productPurchased) {
        [self.view addSubview:[BannerHelper sharedAd].bannerView];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height-25);
    }
    else
    {
        NSLog(@"Banner removed");
    }
    [self startControl];
    [self startInterface];
    
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
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1];
    pageControl.backgroundColor = [UIColor blackColor];
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
    
    muteButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    creditsButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    tutorialButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    resetGameButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    backHomeButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    resetYesButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    resetNoButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    questionLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    contactButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    gameCenterButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    restorePurchasesButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    rateButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    
    [muteButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
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
    [rateButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    
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
    creditsImageButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:24];
    [creditsImageButton setTitle:@"\n\n\n\n\n\n\n\n\n...Anthony...\n...Christian...\n\n...Potdevin..." forState:UIControlStateNormal];
    [creditsImageButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [creditsImageButton setBackgroundColor:[UIColor blackColor]];
    creditsImageButton.alpha = 0.9;
    creditsImageButton.hidden = YES;
    [self.view addSubview:creditsImageButton];
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
        [muteButton setTitle:@"Unmute Game" forState:UIControlStateNormal];
    }
    else
    {
        soundOnOrOff=0;
        [[NSUserDefaults standardUserDefaults]setInteger:soundOnOrOff forKey:@"soundOnOrOff"];
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[BannerHelper sharedAd].bannerView removeFromSuperview];
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

@end
