//
//  LaboratoryViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/4/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#include <AudioToolbox/AudioToolbox.h>

static const int TIEMPO_COOK = 10;

@interface LaboratoryViewController : UIViewController
{
    int cualImagenDeFondo;
    int xpLab;
    int labToxicity;
    
    //Ambos Labs-------------------------------
    IBOutlet UIButton *regresarButton;
    IBOutlet UIImageView *imagenDeFondo;
    UIImageView *extractorImage;
    UILabel *extractorLabel;
    UILabel *crystalLabel;
    UIImageView *fridgeWindow;
    
    UILabel *animationLabel;
    UILabel *animationXp;
    int cuantoMasCrystal;
    int tiempoCocinar;
    int maxLiquidCrystal;
    
    NSTimer *gameTimer;
    int currentToxicity;
    NSDate *pastDate;
    
    //Primer Lab-------------------------------
    UILabel *pillsLabel;
    UILabel *matchboxLabel;
    
    UIImageView *heater;
    UIImageView *base;
    
    UIButton *glassButton;
    UIButton *bowlButton;
    UIButton *potButton;
    UIImageView *decantorImage;
    
    UILabel *glassLabel;
    UILabel *bowlLabel;
    UILabel *potLabel;
    UILabel *decantorLabel;
    
    int potTimer;
    NSDate *potDate;
    int started;
    
    //Segundo Lab-------------------------------
    UILabel *aluminumLabel;
    
    UIButton *beakerButton;
    UIButton *mixerButton;
    UIImageView *distilatorImage;
    
    //UILabel *beakerLabel;
    //UILabel *mixerLabel;
    //UILabel *distilatorLabel;
    
    int currentLevel;
    
    int currentCrystal;
    int currentPills;
    int currentMatchbox;
    int currentAluminum;
    
    int whitePowder;
    int redPowder;
    int liquidCrystal;
    
    //Elementos Actuales Del Laboratorio---------
    int currentLabBackground1;
    int currentLabSetting1;
    
    int currentGlass1;
    int currentBowl1;
    int currentPot1;
    int currentDecantor1;
    
    int currentExtractor1;
    
    int currentBeaker1;
    int currentMixer1;
    int currentDistilator1;
}

- (IBAction)regresarButton:(id)sender;


@end
