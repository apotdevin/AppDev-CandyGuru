//
//  BowlViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/5/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BowlViewController : UIViewController
{
    IBOutlet UIImageView *dondePresionar;
    IBOutlet UILabel *porcentaje;
    IBOutlet UILabel *pills;
    IBOutlet UILabel *powder;
    IBOutlet UIImageView *fondo;
    IBOutlet UIButton *backButton;
    IBOutlet UIImageView *window;
    
    NSInteger progressPorcent;
    
    int randomX;
    int randomY;
    
    NSTimer *juego;
    
    UILabel *tutLabel;
}
- (IBAction)backPressed:(UIButton *)sender;

@end
