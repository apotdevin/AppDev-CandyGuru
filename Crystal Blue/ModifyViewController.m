//
//  ModifyViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 3/4/15.
//  Copyright (c) 2015 Anthony Potdevin. All rights reserved.
//

#import "ModifyViewController.h"
#import "ParseHelper.h"
#import <Parse/Parse.h>

@interface ModifyViewController ()

@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _infoLabel.text = @"Your Game Data has Been Modified.";
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)backButtonPressed:(id)sender
{
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:[PFUser currentUser].objectId block:^(PFObject *user, NSError *error) {
        if (!error) {
            [[ParseHelper sharedParseData] loadOldGame:(PFUser*)user];
            user[@"Modify"]=@0;
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 if (succeeded) {
                     [self performSegueWithIdentifier:@"exitModify" sender:self];
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not load"
                                                                     message:@"Please try again later"
                                                                    delegate:self
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:@"Ok",nil];
                     [alert show];
                 }
             }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not load"
                                                            message:@"Please try again later."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok",nil];
            [alert show];
        }
    }];
    
    /*
    PFUser *user = [PFUser currentUser];
    [user fetchInBackgroundWithBlock:^(PFObject *user, NSError *error)
     {
         if (!error) {
             [[ParseHelper sharedParseData] loadOldGame:(PFUser*)user];
             user[@"Modify"]=@0;
             [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
              {
                  if (succeeded) {
                      [self performSegueWithIdentifier:@"exitModify" sender:self];
                  }
                  else
                  {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not load"
                                                                      message:@"Please try again later"
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:@"Ok",nil];
                      [alert show];
                  }
              }];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not load"
                                                             message:@"Please try again later."
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"Ok",nil];
             [alert show];
         }
     }];*/
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self performSegueWithIdentifier:@"exitModify" sender:self];
}

@end
