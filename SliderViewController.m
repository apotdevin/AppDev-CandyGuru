//
//  SliderViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/1/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "SliderViewController.h"

@interface SliderViewController ()

@end

@implementation SliderViewController

@synthesize progressView;
@synthesize progressSlider;
@synthesize label;

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
    
    // Do any additional setup after loading the view.
    
    UIColor *tintColor = [UIColor orangeColor];
    [[UISlider appearance] setMinimumTrackTintColor:tintColor];
    [[CERoundProgressView appearance] setTintColor:tintColor];
    
    self.progressView.trackColor = [UIColor colorWithWhite:0.40 alpha:1.0];
    self.progressView.startAngle = (M_PI)/2.0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)progressSlider:(UISlider *)sender
{
    label.text = [NSString stringWithFormat:@"%1.2f",sender.value];
    self.progressView.progress = sender.value;
}

@end
