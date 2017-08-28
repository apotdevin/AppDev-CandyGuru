//
//  ReloadViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 3/4/15.
//  Copyright (c) 2015 Anthony Potdevin. All rights reserved.
//

#import "ReloadViewController.h"

@interface ReloadViewController ()

@end

@implementation ReloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *user = [PFUser currentUser];
    
    NSInteger xp=[[user objectForKey:@"tXp"] integerValue];
    NSInteger level=[[user objectForKey:@"Level"] integerValue];
    float purity=[[user objectForKey:@"Sweet"] integerValue]/100;
    NSInteger money=[[user objectForKey:@"Money"] integerValue];
    NSInteger crystal=[[user objectForKey:@"Candy"] integerValue];
    NSInteger currentFreezers=[[user objectForKey:@"Freezers"] integerValue];
    NSInteger tickets=[[user objectForKey:@"Bars"] integerValue];
    
    NSInteger xp2=[GameSaveState sharedGameData].totalXpGained;
    NSInteger level2=[GameSaveState sharedGameData].level;
    float purity2=[GameSaveState sharedGameData].purity/100;
    NSInteger money2=[GameSaveState sharedGameData].money;
    NSInteger crystal2=[GameSaveState sharedGameData].crystal;
    NSInteger currentFreezers2=[GameSaveState sharedGameData].currentFreezers;
    NSInteger tickets2=[GameSaveState sharedGameData].tickets;
    
    _nameLabel.text = [NSString stringWithFormat:@"Saved Game For:\n%@",user[@"Name"]];
    _infoLabel.text = [NSString stringWithFormat:@"CURRENT:\n\nTOTAL XP: %ld\nLEVEL: %ld\nSWEETNESS: %1.1f%%\nMONEY: %ld\nCANDY: %ld\nFREEZERS: %ld\nGOLD BARS: %ld",(long)xp2,(long)level2,(float)purity2,(long)money2,(long)crystal2,(long)currentFreezers2,(long)tickets2];
    _info2Label.text = [NSString stringWithFormat:@"SAVED:\n\nTOTAL XP: %ld\nLEVEL: %ld\nSWEETNESS: %1.1f%%\nMONEY: %ld\nCANDY: %ld\nFREEZERS: %ld\nGOLD BARS: %ld",(long)xp,(long)level,(float)purity,(long)money,(long)crystal,(long)currentFreezers,(long)tickets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loadButtonPressed:(id)sender
{
    _loadButton.enabled = NO;
    _replaceButton.enabled = NO;
    
    PFUser *user = [PFUser currentUser];
    [user fetchInBackgroundWithBlock:^(PFObject *user, NSError *error)
     {
         if (!error) {
             [[ParseHelper sharedParseData] loadOldGame:(PFUser*)user];
             [self performSegueWithIdentifier:@"exitLoadScreen" sender:self];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not load"
                                                             message:@"Please try again later."
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"Ok",nil];
             [alert show];
             _loadButton.enabled = YES;
             _replaceButton.enabled = YES;
         }
     }];
    
}

- (IBAction)maintainButtonPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                    message:@"All saved information will be replaced with current one!"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Replace",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.firstOtherButtonIndex==buttonIndex&&[alertView.title isEqualToString:@"Warning!"])
    {
        [[ParseHelper sharedParseData] saveOldGame];
        [self performSegueWithIdentifier:@"exitLoadScreen" sender:self];
    }
    else if ([alertView.title isEqualToString:@"Could not load"])
    {
        [self performSegueWithIdentifier:@"exitLoadScreen" sender:self];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
