//
//  GlassViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/5/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "GlassViewController.h"
#import "BannerHelper.h"

@interface GlassViewController ()

@end

@implementation GlassViewController

- (void)viewDidLoad
{
    BOOL productPurchased=NO;
    if ([GameSaveState sharedGameData].removeBanners==641) {
        productPurchased=YES;
    }
    if (!productPurchased) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        progress.center = CGPointMake(screenBounds.size.width/2, 90);
        [self.view addSubview:[BannerHelper sharedAd].bannerView];
        [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, 25);
        NSLog(@"added banner");
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"terminoTutorial"]!=YES) {
        [BannerHelper sharedAd].bannerView.alpha = 0;
    }
    /*if ([[NSUserDefaults standardUserDefaults] boolForKey:@"terminoTutorial"]!=YES)
    {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height+25);
        NSLog(@"Banner no por tutorial");
    }  */
    
    currentBowl = [GameSaveState sharedGameData].currentBowl;
    
    background.image = [UIImage imageNamed:@"1_MatchBox"];
    
    progress.font = [UIFont fontWithName:@"AllerDisplay" size:70];
    //progress.textColor = [UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1];
    progress.text = [NSString stringWithFormat:@"0.0%%"];
    
    matchBoxes.text = [NSString stringWithFormat:@"Red Taffy: %li",(long)[GameSaveState sharedGameData].matchbox];
    redPowder.text = [NSString stringWithFormat:@"Taffy Dust: %li",(long)[GameSaveState sharedGameData].redPowder];
    matchBoxes.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    redPowder.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    
    backButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    //[backButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    
    tutLabel = [[UILabel alloc]init];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    tutLabel.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    tutLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tutLabel.numberOfLines = 30;
    tutLabel.textAlignment = NSTextAlignmentCenter;
    tutLabel.font = [UIFont fontWithName:@"AllerDisplay" size:50];
    tutLabel.textColor = [UIColor yellowColor];
    tutLabel.text = @"\n\n\n\nSwipe the Screen!";
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"tutGlass"]!=YES)
    {
        tutLabel.hidden = NO;
    }
    else
    {
        tutLabel.hidden = YES;
    }
    
    [self.view addSubview:tutLabel];
    
    
    dificulty=0;
    if (currentBowl==1)
    {
        dificulty=0.5;
    }
    else if (currentBowl==2)
    {
        dificulty=0.8;
    }
    else if (currentBowl==3)
    {
        dificulty=1.2;
    }
    else
    {
        dificulty=1.5;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([GameSaveState sharedGameData].matchbox>=1) {
        if (glassProgress>=100)
        {
            glassProgress=100;
            [progress setText: [NSString stringWithFormat:@"%1.1f%%",glassProgress]];
        }
        
        else
        {
            glassProgress = glassProgress+dificulty;
            [progress setText: [NSString stringWithFormat:@"%1.1f%%",glassProgress]];
            
            [self ponerFondo:glassProgress];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (glassProgress>=100) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutGlass"];
        
        glassProgress=0;
        [progress setText: [NSString stringWithFormat:@"%1.0f%%",glassProgress]];
        
        [GameSaveState sharedGameData].matchbox--;
        [GameSaveState sharedGameData].redPowder++;
        [GameSaveState sharedGameData].totalRedPowder++;
        [[GameCenterHelper sharedGC] makeRedAchievements];
        
        background.image = [UIImage imageNamed:@"1_MatchBox"];
        
        [self refreshInterface];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HizoPowder"]!=YES)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HizoPowder"];
        }
        
        if ([GameSaveState sharedGameData].matchbox<1) {
            [self performSegueWithIdentifier:@"exitGlass" sender:self];
        }
    }
}

-(void)ponerFondo:(int)progressPercent
{
    for (int i=0; i<10; i++) {
        if (progressPercent>=10*i&&progressPercent<10*i+10) {
            NSString *cualImagen = [NSString stringWithFormat:@"%i_MatchBox",i+1];
            background.image = [UIImage imageNamed:cualImagen];
        }
    }
}

-(void)refreshInterface
{
    matchBoxes.text = [NSString stringWithFormat:@"Red Taffy: %li",(long)[GameSaveState sharedGameData].matchbox];
    redPowder.text = [NSString stringWithFormat:@"Taffy Dust: %li",(long)[GameSaveState sharedGameData].redPowder];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
