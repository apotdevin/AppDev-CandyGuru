//
//  ReloadViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 3/4/15.
//  Copyright (c) 2015 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseHelper.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ReloadViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UIButton *replaceButton;
@property (weak, nonatomic) IBOutlet UILabel *info2Label;


- (IBAction)loadButtonPressed:(id)sender;
- (IBAction)maintainButtonPressed:(id)sender;

@end
