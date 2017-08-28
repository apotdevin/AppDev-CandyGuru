//
//  DangerClientViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 7/11/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DangerClientViewController : UIViewController
{
    IBOutlet UILabel *problem;
    IBOutlet UIButton *vender;
    IBOutlet UIButton *back;
    IBOutlet UILabel *moneyLabel;
    IBOutlet UIButton *useTicketButton;
    IBOutlet UIImageView *problemImage;
    IBOutlet UIButton *ticketLabel;
    
    UILabel *animationLabel;
    
    NSInteger cualProblema;
    
    NSInteger howMuch;
}

@property (nonatomic)NSInteger pressed;

- (IBAction)venderPressed:(id)sender;
- (IBAction)backPressed:(id)sender;
- (IBAction)ticketButtonPressed:(id)sender;
- (IBAction)ticketLabelPressed:(id)sender;

@end
