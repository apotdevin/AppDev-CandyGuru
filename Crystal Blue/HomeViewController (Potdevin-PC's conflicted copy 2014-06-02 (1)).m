//
//  HomeViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 5/31/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize progressView;

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
    /*
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstView"]!=YES) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstView"];
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"pageTutorial"];
        [[[[UIApplication sharedApplication] delegate] window] setRootViewController:add];
    }
     */
    /*
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    */
    
    lab.Font=[UIFont fontWithName:@"28 Days Later" size:42];
    [contracts setFont:[UIFont fontWithName:@"28 Days Later" size:42]];
    [shop setFont:[UIFont fontWithName:@"28 Days Later" size:42]];
    
    scroller.delegate=self;
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(1600, 568)];
    
    UIColor *tintColor = [UIColor colorWithRed:0.404 green:0.835 blue:0.969 alpha:0.4];
    [[CERoundProgressView appearance] setTintColor:tintColor];
    
    self.progressView.trackColor = [UIColor clearColor];
    self.progressView.startAngle = (M_PI)/2.0;
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"currentPercent"]!=nil) {
        [percent setText: [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPercent"]];
        [progressView setProgress: [[NSUserDefaults standardUserDefaults]floatForKey:@"currentProgress"]];
    }
    else
    {
        [percent setText:[NSString stringWithFormat:@"0"]];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    couch.center = CGPointMake(1210+scroller.contentOffset.x*-0.1, 426);
    mesa.center = CGPointMake(1550+scroller.contentOffset.x*-0.2, 520);
    sillas.center = CGPointMake(332+scroller.contentOffset.x*-0.05, 411);
    contracts.center = CGPointMake(1550+scroller.contentOffset.x*-0.2, 480);

}

- (IBAction)progressSlider:(UISlider *)sender
{
    self.progressView.progress = sender.value;
    percent.text = [NSString stringWithFormat:@"%1.0f%%",sender.value*100];
    
    [[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:@"currentProgress"];
    [[NSUserDefaults standardUserDefaults] setObject:percent.text forKey:@"currentPercent"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)buttonLeft:(UIButton *)sender
{
    
    [scroller scrollRectToVisible:CGRectMake(0, 0, scroller.frame.size.width, scroller.frame.size.height) animated:YES];
    
}
- (IBAction)buttonRight:(UIButton *)sender
{
    
    [scroller scrollRectToVisible:CGRectMake(1400, 0, scroller.frame.size.width, scroller.frame.size.height) animated:YES];
    
}

- (void)checkLevel
{
    
}

- (void)increaseXp
{
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
