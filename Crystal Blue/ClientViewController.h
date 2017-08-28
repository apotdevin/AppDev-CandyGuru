//
//  ClientViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/6/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientViewController : UIViewController
{
    
    IBOutlet UILabel *cualcliente;
    IBOutlet UILabel *cuantoVaAComprar;
    IBOutlet UILabel *porCuantoLoVaAComprar;
    IBOutlet UIButton *dontSellButton;
    IBOutlet UIButton *sellButton;
    IBOutlet UILabel *currentCrystal;
    IBOutlet UIImageView *clientFace;
    IBOutlet UIImageView *background;
    IBOutlet UILabel *animationLabel;
    IBOutlet UILabel *animationLabel2;
    IBOutlet UIImageView *window;
    IBOutlet UILabel *ClientSentence;
    IBOutlet UIImageView *SpeechBubble;
    
    NSInteger cuanto;
    NSInteger precio;
    NSInteger goldPresent;
}

@property (nonatomic)NSInteger cual;

- (IBAction)sellButton:(id)sender;
- (IBAction)dontSellButton:(id)sender;

@end
