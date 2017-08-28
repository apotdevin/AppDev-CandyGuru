//
//  ClientViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/6/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "ClientViewController.h"
#import "ClientsAtHome.h"
#import "SoundHelper.h"

@interface ClientViewController ()

@end

@implementation ClientViewController

@synthesize cual;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *nombres = [NSArray arrayWithObjects:
               @"Joaquin (Sealem)",
               @"Rocco (Kingapolis)",
               @"Titus (New Town)",
               @"Rhian (San Bernard)",
               @"Gabrielle (Senferd)",
               @"Chow (Well Field)",
               @"Luka (Cashington)",
               @"Lila (Albachurch)",
               @"Antoine (Baldas)",
               @"Perseus (Maroni)",
               nil];
    
    NSArray *sentences = [NSArray arrayWithObjects:
                          @"Sometimes I will give you some gold!",
                          @"Still have that awesome candy from last time?",
                          @"Just in the mood for some sweets!",
                          @"Heard you have some of the best candy in town!",
                          @"Hi sir, just passing by for some sugar!",
                          @"I want some candy!",
                          @"Good day, heard you have a new recipe.",
                          @"Looking for something sweet for today!",
                          @"Hi! Need some candies!",
                          @"Hey! Need some awesome candy! Have any?",
                          nil];
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookUser"]isEqualToString:@"NONE"]&&[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookUser"]!=nil)
    {
        NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"facebookUser"];
        
        NSString *sentence1 = [NSString stringWithFormat:@"Hey %@! Sometimes I will give you some gold!",userName];
        NSString *sentence2 = [NSString stringWithFormat:@"%@ still have that awesome candy from last time?",userName];
        NSString *sentence3 = [NSString stringWithFormat:@"Hi %@! I was just in the mood for some sweets!",userName];
        NSString *sentence4 = [NSString stringWithFormat:@"%@ heard you have some of the best candy in town",userName];
        NSString *sentence5 = [NSString stringWithFormat:@"Hi %@, just passing by for some sugar!",userName];
        NSString *sentence6 = [NSString stringWithFormat:@"%@ I want some Candy!",userName];
        NSString *sentence7 = [NSString stringWithFormat:@"Good day %@, heard you have a new recipe.",userName];
        NSString *sentence8 = [NSString stringWithFormat:@"%@ I'm looking for something sweet for today!",userName];
        NSString *sentence9 = [NSString stringWithFormat:@"Hi %@! Need some candies!",userName];
        NSString *sentence10 = [NSString stringWithFormat:@"Hey %@! Need some awesome candy! Have any?",userName];
        
        sentences = [NSArray arrayWithObjects:
                     sentence1,
                     sentence2,
                     sentence3,
                     sentence4,
                     sentence5,
                     sentence6,
                     sentence7,
                     sentence8,
                     sentence9,
                     sentence10,
                     nil];
    }
    
    [cualcliente setText:nombres[cual]];
    cualcliente.font = [UIFont fontWithName:@"AllerDisplay" size:25];
    
    ClientSentence.text = sentences[cual];
    ClientSentence.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    ClientSentence.textColor = [UIColor blackColor];
    
    if ([GameSaveState sharedGameData].crystal==1) {
        currentCrystal.text = @"You have 1 Candy";
    }
    else
    {
        currentCrystal.text = [NSString stringWithFormat:@"You have %li Candys",(long)[GameSaveState sharedGameData].crystal];
    }
    currentCrystal.font = [UIFont fontWithName:@"AllerDisplay" size:22];
    currentCrystal.textColor = [UIColor whiteColor];
    
    [self cuantoComprarSegunCliente];
    [self porCuantoComprarSegunCliente];
    
    [cuantoVaAComprar setText:[NSString stringWithFormat:@"Wants %d Candys",(int)cuanto]];
    cuantoVaAComprar.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    
    [porCuantoLoVaAComprar setText:[NSString stringWithFormat:@"Will pay you %i",(int)precio*(int)cuanto]];
    porCuantoLoVaAComprar.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    
    dontSellButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    sellButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    //[dontSellButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    //[sellButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    
    clientFace.image = [UIImage imageNamed:[NSString stringWithFormat:@"Client%i",(int)cual]];
    
    animationLabel.font = [UIFont fontWithName:@"AllerDisplay" size:40];
    animationLabel.textColor = [UIColor colorWithRed:0.6 green:0.8 blue:0.4 alpha:0.9];
    animationLabel.shadowColor = [UIColor blackColor];
    animationLabel.shadowOffset = CGSizeMake(1, 1);
    animationLabel2.font = [UIFont fontWithName:@"AllerDisplay" size:40];
    animationLabel2.textColor = [UIColor colorWithRed:0.4 green:.7 blue:0.7 alpha:0.9];
    animationLabel2.shadowColor = [UIColor blackColor];
    animationLabel2.shadowOffset = CGSizeMake(1, 1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cuantoComprarSegunCliente
{
    if (cual==0) {
        cuanto = 11;//11
    }
    else if (cual==1) {
        cuanto = 15;//15
    }
    else if (cual==2) {
        cuanto = 15;//15
    }
    else if (cual==3) {
        cuanto = 17;//17
    }
    else if (cual==4) {
        cuanto = 22;//22
    }
    else if (cual==5) {
        cuanto = 19;//19
    }
    else if (cual==6) {
        cuanto = 25;//25
    }
    else if (cual==7) {
        cuanto = 20;//20
    }
    else if (cual==8) {
        cuanto = 16;//16
    }
    else {
        cuanto = 28;//28
    }
    
    int level = (int)[GameSaveState sharedGameData].level;
    
    cuanto = /*cuanto*/arc4random_uniform(10)+arc4random_uniform((int)cual)+(level);
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstViewComprarCliente"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewComprarCliente"];
        
        cuanto = 5;
    }
}

- (void)porCuantoComprarSegunCliente
{
    float purityDecimales = (float)[GameSaveState sharedGameData].purity/100;
    float precioRandom = (arc4random_uniform((int)cual)+ceil(((float)cual/2)))+purityDecimales;
    precio = ceil(precioRandom);
    if (cual==0) {
        int random = arc4random_uniform(5);
        if (random==0) {
            goldPresent=1;
            precio/=4;
        }
    }
}

- (IBAction)sellButton:(id)sender
{
    if ([GameSaveState sharedGameData].crystal>=cuanto)
    {
        [[SoundHelper sharedSoundInstance] playSound:5];
        [self incrementarSitio];
        
        [GameSaveState sharedGameData].crystal-=cuanto;
        [GameSaveState sharedGameData].totalCrystalSold+=cuanto;
        [GameSaveState sharedGameData].totalCustomersAttended++;
        [[GameSaveState sharedGameData] changeXp:2*[GameSaveState sharedGameData].level];
        [GameSaveState sharedGameData].totalXpGained+=2*[GameSaveState sharedGameData].level;
        [[GameCenterHelper sharedGC] sellCustomerAchievements];
        [[GameCenterHelper sharedGC] sellCrystalAchievements];
        
        int mexicanSurprise = arc4random_uniform(2);
        if (goldPresent==1&&mexicanSurprise==0)
        {
            [self animateChange:2];
            [self animateChange:3];
            
            [GameSaveState sharedGameData].tickets++;
        }
        
        else
        {
            [self animateChange:1];
            [self animateChange:2];
            
            [[GameSaveState sharedGameData] changeMoney:cuanto*precio];
            [[GameSaveState sharedGameData] changeTotalMoney:cuanto*precio];
        }
        
        int cualZone = [[[ClientsAtHome sharedClientData].infoClientes objectAtIndex:cual] intValue];
        [[ClientsAtHome sharedClientData].infoClientes replaceObjectAtIndex:cual withObject:@123];
        [[ClientsAtHome sharedClientData].infoZone replaceObjectAtIndex:cualZone withObject:@123];
        
        dontSellButton.enabled = NO;
        sellButton.enabled = NO;
        [self performSelector:@selector(exitView) withObject:nil afterDelay:1.5];
    }
    else
    {
        [[SoundHelper sharedSoundInstance] playSound:9];
        currentCrystal.font = [UIFont fontWithName:@"AllerDisplay" size:24];
        currentCrystal.textColor = [UIColor redColor];
        [self performSelector:@selector(reverseCurrentCrystal) withObject:nil afterDelay:0.5];
    }
}

- (IBAction)dontSellButton:(id)sender
{
    [GameSaveState sharedGameData].totalCustomersNotAttended++;
    
    int cualZone = [[[ClientsAtHome sharedClientData].infoClientes objectAtIndex:cual] intValue];
    [[ClientsAtHome sharedClientData].infoClientes replaceObjectAtIndex:cual withObject:@123];
    [[ClientsAtHome sharedClientData].infoZone replaceObjectAtIndex:cualZone withObject:@123];
    [self performSegueWithIdentifier:@"exitClient" sender:self];
}

-(void)reverseCurrentCrystal
{
    currentCrystal.font = [UIFont fontWithName:@"AllerDisplay" size:22];
    currentCrystal.textColor = [UIColor whiteColor];
}

- (void)exitView
{
    [self performSegueWithIdentifier:@"exitClient" sender:self];
}

- (void)animateChange:(int)whichAnimation
{
    UILabel *whichOne;
    if (whichAnimation==1) {
        whichOne = animationLabel;
        whichOne.text = [NSString stringWithFormat:@"+$%li",(long)cuanto*precio];
    }
    else if (whichAnimation==2)
    {
        whichOne = animationLabel2;
        whichOne.text = [NSString stringWithFormat:@"+%i Xp",(int)[GameSaveState sharedGameData].level*2];
    }
    else
    {
        whichOne = animationLabel;
        whichOne.text = @"+1 Gold Bar!";
    }
    
    CGSize screenbounds = [[UIScreen mainScreen] bounds].size;
    int randomX = screenbounds.width/2-100+arc4random_uniform(200);
    //int randomX = arc4random()%170+100;
    int randomY = arc4random()%50+350;
    whichOne.center = CGPointMake(randomX, randomY);
    
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         whichOne.center = CGPointMake(randomX, randomY-200);
                     }
                     completion:nil ];
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         whichOne.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:2.0
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              whichOne.alpha = 0.0;
                                          }
                                          completion:nil];
                     }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)incrementarSitio
{
    int cuantasVeces = [[ClientsAtHome sharedClientData].timesSentToEachPlace[cual]intValue];
    cuantasVeces++;
    [[ClientsAtHome sharedClientData].timesSentToEachPlace replaceObjectAtIndex:cual withObject:[NSNumber numberWithInt:cuantasVeces]];
}

@end
