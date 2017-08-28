//
//  FBLeaderboardViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 2/22/15.
//  Copyright (c) 2015 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomFacebookTableViewCell.h"

@interface FBLeaderboardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *table;
    IBOutlet UIButton *backButton;
    
    //IBOutlet FBLikeControl *like;
    
    NSMutableArray *friends;
    NSArray *sortedArray;
}

//- (IBAction)backButton:(id)sender;

@end
