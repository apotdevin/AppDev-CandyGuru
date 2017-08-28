//
//  DangerClientViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 7/11/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "DangerClientViewController.h"
#import "ClientsAtHome.h"
#import "SoundHelper.h"

@interface DangerClientViewController ()

@end

@implementation DangerClientViewController

@synthesize pressed;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    animationLabel = [[UILabel alloc]init];
    animationLabel.font = [UIFont fontWithName:@"AllerDisplay" size:30];
    animationLabel.frame = CGRectMake(0, 0, 150, 100);
    animationLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0 alpha:1];
    animationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    animationLabel.numberOfLines = 2;
    [self.view addSubview:animationLabel];
    
    cualProblema = [ClientsAtHome sharedClientData].whichDanger;
    
    howMuch = 0;
    
    if (cualProblema==0) {
        howMuch = ([GameSaveState sharedGameData].level*1800)*(1-0.07*[GameSaveState sharedGameData].currentLawyer);
        problemImage.image=[UIImage imageNamed:@"SurpriseInsurance"];
    }
    else if (cualProblema==1) {
        howMuch = ([GameSaveState sharedGameData].level*1800)*(1-0.07*[GameSaveState sharedGameData].currentLawyer);
        problemImage.image=[UIImage imageNamed:@"SurpriseCart"];
    }
    else if (cualProblema==2) {
        howMuch = ([GameSaveState sharedGameData].level*1700)*(1-0.07*[GameSaveState sharedGameData].currentLawyer);
        problemImage.image=[UIImage imageNamed:@"SurpriseAds"];
    }
    else if (cualProblema==3) {
        howMuch = ([GameSaveState sharedGameData].level*1900)*(1-0.07*[GameSaveState sharedGameData].currentLawyer);
        problemImage.image=[UIImage imageNamed:@"SurpriseFlood"];
    }
    else if (cualProblema==4)
    {
        howMuch = ([GameSaveState sharedGameData].level*2000)*(1-0.07*[GameSaveState sharedGameData].currentLawyer);
        problemImage.image=[UIImage imageNamed:@"SurpriseThief"];
    }
    else if (cualProblema==5)
    {
        howMuch = ([GameSaveState sharedGameData].level*1900)*(1-0.07*[GameSaveState sharedGameData].currentLawyer);
        problemImage.image=[UIImage imageNamed:@"SurpriseRat"];
    }
    else if (cualProblema==6)
    {
        howMuch = ([GameSaveState sharedGameData].crystal*80)*(1-0.07*[GameSaveState sharedGameData].currentLawyer);
        problemImage.image=[UIImage imageNamed:@"SurpriseStorage"];
    }
    else if (cualProblema==7)
    {
        howMuch = ([GameSaveState sharedGameData].level*2100)*(1-0.07*[GameSaveState sharedGameData].currentLawyer);
        problemImage.image=[UIImage imageNamed:@"SurpriseAlien"];
    }
    else if (cualProblema==8)
    {
        howMuch = (([GameSaveState sharedGameData].currentDecantor+[GameSaveState sharedGameData].currentDistilator)*2400)*(1-0.07*[GameSaveState sharedGameData].currentLawyer);
        problemImage.image=[UIImage imageNamed:@"SurpriseBroken"];
    }
    else
    {
        howMuch = ([GameSaveState sharedGameData].currentFreezers*2200)*(1-0.07*[GameSaveState sharedGameData].currentLawyer);
        problemImage.image=[UIImage imageNamed:@"SurpriseTray"];
    }
    
    howMuch = howMuch*(pressed+1);
    
    NSArray *problemas = [NSArray arrayWithObjects:
                          @"One of your insurances got canceled! \n\n\n\n\n\n\n\n\n\n\n\nBuy it again or you will lose it.",
                          @"One of your Candy Carts broke! \n\n\n\n\n\n\n\n\n\n\n\nFix it or you will lose it.",
                          @"You lost an advertising contract! \n\n\n\n\n\n\n\n\n\n\n\nBuy it again or you will lose it.",
                          @"Your house flooded! \n\n\n\n\n\n\n\n\n\n\n\nFix it or you will lose some candy admiration.",
                          @"Someone stole your money! \n\n\n\n\n\n\n\n\n\n\n\nHire a spy or you will lose it.",
                          @"You found rats eating your money! \n\n\n\n\n\n\n\n\n\n\n\nHire an exterminator or you will lose it.",
                          @"One of your Candy storages has been robbed! \n\n\n\n\n\n\n\n\n\n\n\nHire a spy or you will lose your Candy.",
                          @"Your money is being abducted by aliens! \n\n\n\n\n\n\n\n\n\n\n\nBuy a Raygun or you will lose it.",
                          @"Your Soft Candy storage broke! \n\n\n\n\n\n\n\n\n\n\n\nBuy a new one or you will lose your Soft Candy.",
                          @"Your Freezer Trays are about to break! \n\n\n\n\n\n\n\n\n\n\n\nFix them or you will lose them.",
                          nil];
    
    if ([GameSaveState sharedGameData].screenSize==1) {
        problemas = [NSArray arrayWithObjects:
                     @"One of your insurances got canceled! \n\n\n\n\n\n\n\n\n\nBuy it again or you will lose it.",
                     @"One of your Candy Carts broke! \n\n\n\n\n\n\n\n\n\nFix it or you will lose it.",
                     @"You lost an advertising contract! \n\n\n\n\n\n\n\n\n\nBuy it again or you will lose it.",
                     @"Your house flooded! \n\n\n\n\n\n\n\n\n\nFix it or you will lose some candy admiration.",
                     @"Someone stole your money! \n\n\n\n\n\n\n\n\n\nHire a spy or you will lose it.",
                     @"You found rats eating your money! \n\n\n\n\n\n\n\n\n\nHire an exterminator or you will lose it.",
                     @"One of your Candy storages has been robbed! \n\n\n\n\n\n\n\n\n\nHire a spy or you will lose your Candy.",
                     @"Your money is being abducted by aliens! \n\n\n\n\n\n\n\n\n\nBuy a Raygun or you will lose it.",
                     @"Your Soft Candy reservoir broke! \n\n\n\n\n\n\n\n\n\nBuy a new one or you will lose your Soft Candy.",
                     @"Your Freezer Trays are about to break! \n\n\n\n\n\n\n\n\n\nFix them or you will lose them.",
                     nil];
    }
    
    problem.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    problem.text = problemas[cualProblema];
    
    moneyLabel.font = [UIFont fontWithName:@"AllerDisplay" size:18];
    moneyLabel.text = [NSString stringWithFormat:@"Money: %li",(long)[GameSaveState sharedGameData].money];
    
    vender.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:18];
    [vender setTitle:[NSString stringWithFormat:@"Pay up: %i",(int)howMuch] forState:UIControlStateNormal];
    //[vender setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    
    ticketLabel.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:18];
    
    if ([GameSaveState sharedGameData].tickets>0) {
        [ticketLabel setTitle:[NSString stringWithFormat:@"Gold Bars: %li",(long)[GameSaveState sharedGameData].tickets] forState:UIControlStateNormal];
        ticketLabel.enabled=NO;
    }
    else
    {
        [ticketLabel setTitle:@"Buy GoldBars!" forState:UIControlStateNormal];
        ticketLabel.enabled=YES;
    }
    
    back.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:18];
    //[back setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    
    useTicketButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:18];
    //[useTicketButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)venderPressed:(id)sender
{
    if ([GameSaveState sharedGameData].money>=howMuch)
    {
        vender.enabled=NO;
        back.enabled=NO;
        useTicketButton.enabled=NO;
        
        [[SoundHelper sharedSoundInstance] playSound:5];
        
        [self animateChange:(int)howMuch];
        [[GameSaveState sharedGameData] changeMoney:-howMuch];
        
        vender.enabled = NO;
        back.enabled = NO;
        [self performSelector:@selector(changeView) withObject:nil afterDelay:1.5];
    }
    else
    {
        [[SoundHelper sharedSoundInstance] playSound:9];
        moneyLabel.font = [UIFont fontWithName:@"AllerDisplay" size:24];
        moneyLabel.textColor = [UIColor redColor];
        [self performSelector:@selector(reverseMoney) withObject:nil afterDelay:0.5];
    }
}

- (void)reverseMoney
{
    moneyLabel.font = [UIFont fontWithName:@"AllerDisplay" size:22];
    moneyLabel.textColor = [UIColor whiteColor];
}

- (IBAction)backPressed:(id)sender
{
    vender.enabled=NO;
    back.enabled=NO;
    useTicketButton.enabled=NO;
    
    vender.enabled = NO;
    back.enabled = NO;
    
    if (cualProblema==0)
    {
        [GameSaveState sharedGameData].currentLawyer--;
    }
    else if (cualProblema==1)
    {
        [GameSaveState sharedGameData].currentSeller--;
    }
    else if (cualProblema==2)
    {
        [GameSaveState sharedGameData].currentBully--;
    }
    else if (cualProblema==3)
    {
        [GameSaveState sharedGameData].currentSpy--;
        [GameSaveState sharedGameData].changeDanger=1;
    }
    else if (cualProblema==4)
    {
        [GameSaveState sharedGameData].money*=0.1;
    }
    else if (cualProblema==5)
    {
        [GameSaveState sharedGameData].money*=0.1;
    }
    else if (cualProblema==6)
    {
        [GameSaveState sharedGameData].crystal*=0.1;
    }
    else if (cualProblema==7)
    {
        [GameSaveState sharedGameData].money*=0.1;
    }
    else if (cualProblema==8)
    {
        [GameSaveState sharedGameData].liquidCrystal*=0.1;
    }
    else
    {
        [GameSaveState sharedGameData].currentFreezers=1;
    }
    
    [[SoundHelper sharedSoundInstance] playSound:9];
    [self performSelector:@selector(changeView) withObject:nil afterDelay:1.5];
}

- (void)ticketButtonPressed:(id)sender
{
    if ([GameSaveState sharedGameData].tickets>=1) {
        vender.enabled=NO;
        back.enabled=NO;
        useTicketButton.enabled=NO;
        
        [GameSaveState sharedGameData].tickets--;
        [self performSelector:@selector(changeView) withObject:nil afterDelay:1.5];
    }
    else
    {
        [[SoundHelper sharedSoundInstance] playSound:9];
        ticketLabel.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:22];
        [ticketLabel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self performSelector:@selector(reverseTicket) withObject:nil afterDelay:0.5];
    }
}

- (IBAction)ticketLabelPressed:(id)sender
{
    [GameSaveState sharedGameData].currentShopList=3;
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"shopVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)reverseTicket
{
    ticketLabel.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    [ticketLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)changeView
{
    NSDate *dangerStartDate= nil;
    [ClientsAtHome sharedClientData].dangerClientOnOrOff=0;
    [[NSUserDefaults standardUserDefaults]setObject:dangerStartDate forKey:@"dangerStartDate"];
    
    [self performSegueWithIdentifier:@"exitDangerClient" sender:self];
}

- (void)animateChange:(int)cuanto
{
    CGSize screenbounds = [[UIScreen mainScreen] bounds].size;
    int randomX = (screenbounds.width/2-100)+arc4random_uniform(200);
    //int randomX = arc4random_uniform(170)+75;
    int randomY = arc4random_uniform(100)+350;
    
    UILabel *animation;
    
    animation = animationLabel;
    animation.text = [NSString stringWithFormat:@"-%i",cuanto];
    
    animation.textAlignment = NSTextAlignmentCenter;
    animation.font = [UIFont fontWithName:@"AllerDisplay" size:30];
    animation.center = CGPointMake(randomX, randomY);
    
    [UIView animateWithDuration:4.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         animation.center = CGPointMake(randomX, randomY-300);
                     }
                     completion:nil ];
    
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         animation.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:2.0
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              animation.alpha = 0.0;
                                          }
                                          completion:nil];
                     }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]synchronize];
    [super viewWillDisappear:animated];
}

@end
