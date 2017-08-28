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
    /*
    imagen.center = CGPointMake(200+scroller.contentOffset.x*-5, 400+scroller.contentOffset.y);
    imagen1.center = CGPointMake(200+scroller.contentOffset.x*-4, 300+scroller.contentOffset.y);
    imagen2.center = CGPointMake(200+scroller.contentOffset.x*-3, 200+scroller.contentOffset.y);
    imagen3.center = CGPointMake(200+scroller.contentOffset.x, 100+scroller.contentOffset.y);
     */
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
