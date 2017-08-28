//
//  BeakerViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 7/14/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "BeakerViewController.h"
#import "BannerHelper.h"

@interface BeakerViewController ()

@end

@implementation BeakerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstBeakerView"]!=YES)
    {
        backgroundImage.image = [UIImage imageNamed:@"1RedLicoriceH"];
    }
    
    BOOL productPurchased=NO;
    if ([GameSaveState sharedGameData].removeBanners==641) {
        productPurchased=YES;
    }
    if (!productPurchased) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        [self.view addSubview:[BannerHelper sharedAd].bannerView];
        [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, 25);
        labWindow.center = CGPointMake(94, 64+30);
        backButton.center = CGPointMake(94, 35+30);
        aluminumLabel.center = CGPointMake(100, 63+30);
        greyPowderLabel.center = CGPointMake(100, 77+15+30);
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"terminoTutorial"]!=YES) {
        [BannerHelper sharedAd].bannerView.alpha = 0;
    }
    
    //Custom ProgressBar initialization
    UIColor *tintColor = [UIColor colorWithRed:0.804 green:0.835 blue:0.869 alpha:1];
    [[CERoundProgressView appearance] setTintColor:tintColor];
    
    aluminumLabel.font = [UIFont fontWithName:@"AllerDisplay" size:14];
    greyPowderLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    [self resetInterfaceValues];
    
    backButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    //[backButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    
    NSInteger currentBeaker = [GameSaveState sharedGameData].currentBeaker;
    
    progress = 0;
    
    if (currentBeaker==1)
    {
        cuantoIncremento=1;
    }
    else if (currentBeaker==2)
    {
        cuantoIncremento=1.5;
    }
    else if (currentBeaker==3)
    {
        cuantoIncremento=2;
    }
    else
    {
        cuantoIncremento=2.5;
    }
    
    amountOfProgress.font = [UIFont fontWithName:@"AllerDisplay" size:70];
    //amountOfProgress.textColor = [UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1];
    amountOfProgress.text = @"0%";
}

- (void)resetInterfaceValues
{
    aluminumLabel.text = [NSString stringWithFormat:@"Licorice Sticks: %i",(int)[GameSaveState sharedGameData].aluminum];
    greyPowderLabel.text = [NSString stringWithFormat:@"Red Bites: %i",(int)[GameSaveState sharedGameData].greyPowder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    int availableZone = 0;
    int spacing = 0;
    
    if ([GameSaveState sharedGameData].screenSize==1)
    {
        availableZone = 78;
    }
    else if ([GameSaveState sharedGameData].screenSize==2)
    {
        availableZone = -70;
        spacing = 30;
    }
    else if ([GameSaveState sharedGameData].screenSize==3)
    {
        availableZone = -120;
        spacing = 40;
    }
    
    UITouch *myTouch = [[touches allObjects] objectAtIndex: 0];
    CGPoint currentPos = [myTouch locationInView: nil];
    if (currentPos.y<=530-availableZone+spacing&&currentPos.y>=470-availableZone)
    {
        empezoBien=1;
    }
    else
    {
        empezoBien=0;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    int availableZone = 0;
    int spacing = 0;
    
    if ([GameSaveState sharedGameData].screenSize==1)
    {
        availableZone = 78;
    }
    else if ([GameSaveState sharedGameData].screenSize==2)
    {
        availableZone = -70;
        spacing = 30;
    }
    else if ([GameSaveState sharedGameData].screenSize==3)
    {
        availableZone = -120;
        spacing = 40;
    }
    
    UITouch *myTouch = [[touches allObjects] objectAtIndex: 0];
    CGPoint currentPos = [myTouch locationInView: nil];
    
    if (currentPos.y<=530-availableZone+spacing&&currentPos.y>=470-availableZone&&empezoBien==1)
    {
        progress = progress + cuantoIncremento;
        if (progress<100) {
            amountOfProgress.text = [NSString stringWithFormat:@"%1.0f%%",progress];
        }
        else
        {
            amountOfProgress.text = @"100%";
        }
        [self changeBackground];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    empezoBien=0;
    if (progress>=100) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstBeakerView"];
        
        progress=0;
        amountOfProgress.text = @"0%";
        [GameSaveState sharedGameData].aluminum--;
        [GameSaveState sharedGameData].greyPowder++;
        [GameSaveState sharedGameData].totalGreyPowder++;
        [[GameCenterHelper sharedGC] makeGreyAchievements];
        
        backgroundImage.image = [UIImage imageNamed:@"1RedLicorice"];
        [self resetInterfaceValues];
    }
    if ([GameSaveState sharedGameData].aluminum==0)
    {
        [self performSegueWithIdentifier:@"exitBeaker" sender:self];
    }
}

-(void)changeBackground
{
    if (progress<10)
    {
        backgroundImage.image = [UIImage imageNamed:@"1RedLicorice"];
    }
    else if (progress>=10&&progress<20)
    {
        backgroundImage.image = [UIImage imageNamed:@"2RedLicorice"];
    }
    else if (progress>=20&&progress<30)
    {
        backgroundImage.image = [UIImage imageNamed:@"3RedLicorice"];
    }
    else if (progress>=30&&progress<40)
    {
        backgroundImage.image = [UIImage imageNamed:@"4RedLicorice"];
    }
    else if (progress>=40&&progress<50)
    {
        backgroundImage.image = [UIImage imageNamed:@"5RedLicorice"];
    }
    else if (progress>=50&&progress<60)
    {
        backgroundImage.image = [UIImage imageNamed:@"6RedLicorice"];
    }
    else if (progress>=60&&progress<70)
    {
        backgroundImage.image = [UIImage imageNamed:@"7RedLicorice"];
    }
    else if (progress>=70&&progress<80)
    {
        backgroundImage.image = [UIImage imageNamed:@"8RedLicorice"];
    }
    else if (progress>=80&&progress<90)
    {
        backgroundImage.image = [UIImage imageNamed:@"9RedLicorice"];
    }
    else if (progress>=90&&progress<100)
    {
        backgroundImage.image = [UIImage imageNamed:@"10RedLicorice"];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
