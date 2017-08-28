//
//  CrystalViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 5/30/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#define k_Save @"Save"
#import "CrystalViewController.h"
#import "HomeViewController.h"

@interface CrystalViewController ()

@end

@implementation CrystalViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool saved = [defaults boolForKey:k_Save];
    
    if (!saved)
    {
        Label.text = @"app not saved";
    }
    else
    {
        Label.text = @"app is saved";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SaveButton:(id)sender {
    
    NSUserDefaults *savedapp = [NSUserDefaults standardUserDefaults];
    [savedapp setBool:TRUE forKey:k_Save];
    [savedapp synchronize];
    
}

- (IBAction)Next:(id)sender {
    
    HomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    [self presentViewController:homeViewController animated:YES completion:NULL];
    
}

- (void)Change{
    
    HomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    [self presentViewController:homeViewController animated:YES completion:NULL];
    
}
@end
