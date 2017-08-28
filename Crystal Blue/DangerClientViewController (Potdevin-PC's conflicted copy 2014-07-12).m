//
//  DangerClientViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 7/11/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "DangerClientViewController.h"

@interface DangerClientViewController ()

@end

@implementation DangerClientViewController

@synthesize pressed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pruebaa.text = [NSString stringWithFormat:@"%i",pressed];
    cualProblema = [[NSUserDefaults standardUserDefaults]integerForKey:@"whichDanger"];
    
    currentLawyer = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentLawyer"];
    currentMoney = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentMoney"];
    currentLevel = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentLevel"];
    currentCrystal = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentCrystal"];
    currentCrystalTrays = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentFreezers"];
    currentLiquidCrystal = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentLiquidCrystal"];
    
    int howMuch = 0;
    
    if (cualProblema==0||cualProblema==1||cualProblema==2||cualProblema==3) {
        howMuch = (currentLevel*10000)*(1-0.09*currentLawyer);
    }
    else if (cualProblema==4)
    {
        howMuch = (currentLevel*15000)*(1-0.09*currentLawyer);
    }
    else if (cualProblema==5)
    {
        howMuch = (currentLevel*7000)*(1-0.09*currentLawyer);
    }
    else if (cualProblema==6)
    {
        howMuch = (currentCrystal*200)*(1-0.09*currentLawyer);
    }
    else if (cualProblema==7)
    {
        howMuch = (currentLevel*11000)*(1-0.09*currentLawyer);
    }
    else if (cualProblema==8)
    {
        howMuch = (currentLiquidCrystal*140)*(1-0.09*currentLawyer);
    }
    else
    {
        howMuch = (currentCrystalTrays*9000)*(1-0.09*currentLawyer);
    }
    
    howMuch = howMuch*(pressed+1);
    
    NSArray *problemas = [NSArray arrayWithObjects:
                          @"One of your Lawyers has been taken hostage! \n\nPay up or he will be killed.",
                          @"One of your Sellers was seized! \n\nPay up or he will be killed.",
                          @"One of your Bullys was kidnapped! \n\nPay up or he will be killed.",
                          @"One of your Spies was captured! \n\nPay up or he will be killed.",
                          @"You are being investigated by the FACB! \n\nBribe the corrupt investigator or you will lose your money.",
                          @"The cops discovered your laboratory! \n\nBribe the dirty cop or you will lose your money.",
                          @"One of your Crystal stashes has been found! \n\nPay up or you will lose your Crystal.",
                          @"The bank froze your illegal account! \n\nBribe the dishonest bank or you will lose your money.",
                          @"Your Liquid Crystal reservoir broke! \n\nBuy a new one or you will lose your Liquid Crystal.",
                          @"Your Crystal Trays were seized! \n\nPay up or you will lose them.",
                          nil];
    
    problem.font = [UIFont fontWithName:@"28 Days Later" size:16];
    problem.text = problemas[cualProblema];
    
    vender.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    [vender setTitle:[NSString stringWithFormat:@"Cost: %i",howMuch] forState:UIControlStateNormal];
    
    back.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)venderPressed:(id)sender
{
    
    
    
    NSDate *dangerStartDate= nil;
    int dangerClientOnOrOff=0;
    [[NSUserDefaults standardUserDefaults]setInteger:dangerClientOnOrOff forKey:@"dangerClientOnOrOff"];
    [[NSUserDefaults standardUserDefaults]setObject:dangerStartDate forKey:@"dangerStartDate"];
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)backPressed:(id)sender
{
    if (cualProblema==0)
    {
        int current = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentLawyer"]-1;
        [[NSUserDefaults standardUserDefaults]setInteger:current forKey:@"currentLawyer"];
    }
    else if (cualProblema==1)
    {
        int current = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentSeller"]-1;
        [[NSUserDefaults standardUserDefaults]setInteger:current forKey:@"currentSeller"];
    }
    else if (cualProblema==2)
    {
        int current = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentBully"]-1;
        [[NSUserDefaults standardUserDefaults]setInteger:current forKey:@"currentBully"];
    }
    else if (cualProblema==3)
    {
        int current = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentSpy"]-1;
        [[NSUserDefaults standardUserDefaults]setInteger:current forKey:@"currentSpy"];
    }
    else if (cualProblema==4)
    {
        currentMoney = currentMoney*0.1;
        [[NSUserDefaults standardUserDefaults]setInteger:currentMoney forKey:@"currentMoney"];
    }
    else if (cualProblema==5)
    {
        currentMoney = currentMoney*0.1;
        [[NSUserDefaults standardUserDefaults]setInteger:currentMoney forKey:@"currentMoney"];
    }
    else if (cualProblema==6)
    {
        currentCrystal = currentCrystal*0.1;
        [[NSUserDefaults standardUserDefaults]setInteger:currentCrystal forKey:@"currentCrystal"];
    }
    else if (cualProblema==7)
    {
        currentMoney = currentMoney*0.1;
        [[NSUserDefaults standardUserDefaults]setInteger:currentMoney forKey:@"currentMoney"];
    }
    else if (cualProblema==8)
    {
        currentLiquidCrystal = currentLiquidCrystal*0.1;
        [[NSUserDefaults standardUserDefaults]setInteger:currentLiquidCrystal forKey:@"currentLiquidCrystal"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"currentFreezers"];
    }
    
    NSDate *dangerStartDate= nil;
    int dangerClientOnOrOff=0;
    [[NSUserDefaults standardUserDefaults]setInteger:dangerClientOnOrOff forKey:@"dangerClientOnOrOff"];
    [[NSUserDefaults standardUserDefaults]setObject:dangerStartDate forKey:@"dangerStartDate"];
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
