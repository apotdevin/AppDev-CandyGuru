//
//  LaboratoryViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/4/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>

static const int TIEMPO_COOK = 10;

@interface LaboratoryViewController : UIViewController
{
    //Ambos Labs-------------------------------
    IBOutlet UIImageView *imagenDeFondo;
    IBOutlet UIButton *availableCustomerImage;
    UIImageView *extractorImage;
    UIImageView *animationImageView;
    UILabel *extractorLabel;
    UIImageView *fridgeWindow;
    
    UILabel *animationLabel;
    UILabel *animationXp;
    UILabel *cuantoMasLabel;
    NSInteger cuantoMasCrystal;
    NSInteger tiempoCocinar;
    NSInteger maxLiquidCrystal;
    
    NSTimer *gameTimer;
    NSInteger currentToxicity;
    
    UIImageView *tutorialButton;
    
    UIButton *backButton;
    UIButton *shopButton;
    
    //Primer Lab-------------------------------
    UILabel *pillsLabel;
    UILabel *matchboxLabel;
    
    UIImageView *heater;
    
    UIButton *glassButton;
    UIButton *bowlButton;
    UIButton *potButton;
    UIImageView *decantorImage;
    
    UILabel *glassLabel;
    UILabel *bowlLabel;
    UILabel *potLabel;
    UILabel *decantorLabel;
    
    //Segundo Lab-------------------------------
    UILabel *aluminumLabel;
    
    UIButton *beakerButton;
    UIButton *mixerButton;
    UIImageView *distilatorImage;
}
- (IBAction)availableCustomerPressed:(id)sender;

















@end
