//
//  HomeViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 5/31/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"
#include <AudioToolbox/AudioToolbox.h>

//tiempo minimo entre llegada de clientes
static const int CUSTOMER_TIME = 2;

//Probabilidad de que pueda llegar el cliente (1/#)
static const int PROBA_CLIENTE = 10;

//Probabilidad de que pueda llegar un policia (1/#)
static const int PROBA_POLICIA = 100;

//Total time for freezers (segundos)
static const int TIEMPO_FREEZER = 10;

@interface HomeViewController : UIViewController <UIAlertViewDelegate, UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scroller;
    IBOutlet UIImageView *couch;
    IBOutlet UIImageView *mesa;
    IBOutlet UIImageView *computador;
    
    IBOutlet UILabel *shop;
    IBOutlet UILabel *contracts;
    IBOutlet UILabel *lab;
    
    IBOutlet UILabel *levelLabel;
    IBOutlet UILabel *xpLabel;
    IBOutlet UILabel *xpNeededLabel;
    IBOutlet UILabel *moneyLabel;
    IBOutlet UILabel *crystalLabel;
    IBOutlet UILabel *liquidCrystalLabel;
    IBOutlet UILabel *purityLabel;
    
    UILabel *totalTimeLabel;
    
    UILabel *animationCrystal;
    UILabel *animationXp;
    
    //User Game
    int level;
    int xp;
    float purity;
    int money;
    int crystal;
    int pills;
    int matchbox;
    int aluminum;
    int whitePowder;
    int redPowder;
    int liquidCrystal;
    int currentFreezers;
    
    int currentSeller;
    int currentBully;
    int currentLawyer;
    int currentSpy;
    
    int totalCustomersAttended;
    int totalCrystalMade;
    int totalCrystal;
    int totalLiquidCrystal;
    int totalCustomersNotAttended;
    int totalRedPowder;
    int totalWhitePowder;
    int totalGreyPowder;
    int totalPills;
    int totalMatchboxes;
    int totalAluminum;
    
    int soundOnOrOff;
    /*
    int labXp;
    int clientePlata;
    int clienteCrystal;
    
    int customerMoney;
    int customerCrystal;
    */
    //Elementos Actuales Del Laboratorio
    //---------------------------------------------------
    int currentLabBackground;
    int currentLabSetting;
    
    int currentGlass;
    int currentBowl;
    int currentPot;
    int currentDecantor;
    
    int currentExtractor;
    
    int currentBeaker;
    int currentMixer;
    int currentDistilator;
    //---------------------------------------------------
    //Advances Actuales
    //---------------------------------------------------
    int currentCrystalColor;
    //---------------------------------------------------
    
    
    bool region1;
    bool region2;
    bool region3;
    bool region4;
    
    NSArray *levelXp;
    NSTimer *customerTimer;
    NSTimer *cookingTimer;
    NSTimer *totalTimePlayedTimer;
    
    NSMutableArray *dangerLocation;
    int cuantosGuardados;
    
    NSMutableArray *clientes;
    NSMutableArray *infoClientes;
    NSMutableArray *infoZone;
    NSMutableArray *altura;
    NSMutableArray *tiemposClientes;
    
    NSMutableArray *freezerPrendidosArray;
    NSMutableArray *freezerTimerArray;
    NSMutableArray *freezerButtonArray;
    NSMutableArray *freezerTimeLabelArray;
    NSMutableArray *freezerDateArray;
    NSMutableArray *freezerImagesArray;
    
    //---------------------------------------------------
    //Sonidos
    //---------------------------------------------------
    
    
    
}

@property (retain,nonatomic) IBOutlet CERoundProgressView *progressView;

- (void)increaseXp:(int)howMuch;
- (void)checkLevel;

- (IBAction)button:(UIButton *)sender;
- (IBAction)buttonLeft:(UIButton *)sender;
- (IBAction)buttonRight:(UIButton *)sender;

- (IBAction)contractsButton:(id)sender;
- (IBAction)shopButton:(id)sender;
- (IBAction)labButton:(id)sender;

- (IBAction)pauseButton:(id)sender;
- (IBAction)contractsViewButton:(id)sender;
- (IBAction)labViewButton:(id)sender;
- (IBAction)shopViewButton:(id)sender;






@end
