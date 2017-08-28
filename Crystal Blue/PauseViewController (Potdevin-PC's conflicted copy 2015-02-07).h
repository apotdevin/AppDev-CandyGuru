//
//  PauseViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/3/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PauseViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    IBOutlet UIImageView *screenBackground;
    IBOutlet UIImageView *background;
    IBOutlet UIButton *muteButton;
    IBOutlet UIButton *creditsButton;
    IBOutlet UIButton *tutorialButton;
    IBOutlet UIButton *resetGameButton;
    IBOutlet UIButton *backHomeButton;
    IBOutlet UIButton *contactButton;
    IBOutlet UIButton *gameCenterButton;
    IBOutlet UIButton *restorePurchasesButton;
    IBOutlet UIButton *rateButton;
    IBOutlet UIButton *resetYesButton;
    IBOutlet UIButton *resetNoButton;
    IBOutlet UILabel *questionLabel;
    
    UIButton *creditsImageButton;
    NSInteger soundOnOrOff;
}

- (IBAction)muteButtonPressed:(id)sender;
- (IBAction)creditsButtonPressed:(id)sender;
- (IBAction)resetGameButtonPressed:(id)sender;
- (IBAction)resetYesButtonPressed:(id)sender;
- (IBAction)resetNoButtonPressed:(id)sender;
- (IBAction)contactButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)restorePurchasesButtonPressed:(id)sender;
- (IBAction)rateButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

@end
