//
//  HomeViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 5/31/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"

//tiempo minimo entre llegada de clientes
static const NSInteger CUSTOMER_TIME = 0.1;

//Probabilidad de que pueda llegar un policia (1/#)
//static const NSInteger PROBA_POLICIA = 3;

//Total time for freezers (segundos)
static const NSInteger TIEMPO_FREEZER = 60;

//Total time for boost (minutes)
static const NSInteger TIEMPO_BOOST = 10;

@interface HomeViewController : UIViewController <UIAlertViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate>
{
    IBOutlet UIScrollView *scroller;
    IBOutlet UIImageView *couch;
    IBOutlet UIImageView *mesa;
    IBOutlet UIImageView *computador;
    IBOutlet UIImageView *crystalImage;
    IBOutlet UIImageView *background;
    IBOutlet UIButton *boostButton;
    IBOutlet UILabel *amountOfTickets;
    IBOutlet UIButton *availableCustomer;
    IBOutlet UIButton *trophyButton;
    
    IBOutlet UIImageView *topPanelColor;
    
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
    
    IBOutlet UIButton *left;
    IBOutlet UIButton *labIcon;
    IBOutlet UIButton *shopIcon;
    IBOutlet UIButton *pauseIcon;
    IBOutlet UIButton *contractsIcon;
    IBOutlet UIButton *rightIcon;
    IBOutlet UIButton *labButton;
    IBOutlet UIButton *shopButton;
    IBOutlet UIButton *contractsButton;
    IBOutlet UIButton *mapButton;
    IBOutlet UIButton *buyMoreGoldButton;
    
    UIButton *randomPresentButton;
    int cualRandomPresent;
    
    UIImageView *tutorialButton;
    
    NSMutableArray *freezerButtonArray;
    NSMutableArray *freezerTimeLabelArray;
    NSMutableArray *freezerImagesArray;
    
    UILabel *totalTimeLabel;
    UILabel *animationCrystal;
    UILabel *animationXp;
    
    NSInteger soundOnOrOff;
    NSInteger completeFreezers;
    
    IBOutlet UIButton *dangerClientButton;
    NSInteger dangerChangerValue;
    
    NSArray *levelXp;
    NSTimer *customerTimer;
    NSTimer *cookingTimer;
    NSTimer *totalTimePlayedTimer;
    NSTimer *dangerTimer;
    NSTimer *saveTimer;
    
    NSMutableArray *clientes;
    
    int screenFreezerHeight;
    int screenClientHeight;
    CGFloat imageZoom;
    CGFloat freezerZoom;
    CGFloat clientZoom;
    int screenClient;
    float textZoom;
    
    NSMutableArray *requestPermissions;
}

@property (retain,nonatomic) IBOutlet CERoundProgressView *progressView;

- (IBAction)buttonLeft:(UIButton *)sender;
- (IBAction)buttonRight:(UIButton *)sender;

- (IBAction)contractsButton:(id)sender;
- (IBAction)shopButton:(id)sender;
- (IBAction)labButton:(id)sender;

- (IBAction)pauseButton:(id)sender;
- (IBAction)contractsViewButton:(id)sender;
- (IBAction)labViewButton:(id)sender;
- (IBAction)shopViewButton:(id)sender;
- (IBAction)boostButtonPressed:(UIButton *)sender;
- (IBAction)buyMoreGoldButtonPressed:(id)sender;
- (IBAction)trophyButtonPressed:(id)sender;
- (IBAction)availableCustomerPressed:(id)sender;



@end
