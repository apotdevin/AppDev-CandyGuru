//
//  GameSaveState.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 7/20/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSaveState : NSObject

@property (assign, nonatomic) NSInteger xp;
@property (assign, nonatomic) NSInteger level;
@property (assign, nonatomic) NSInteger purity;
@property (assign, nonatomic) NSInteger money;
@property (assign, nonatomic) NSInteger crystal;
@property (assign, nonatomic) NSInteger pills;
@property (assign, nonatomic) NSInteger matchbox;
@property (assign, nonatomic) NSInteger aluminum;
@property (assign, nonatomic) NSInteger whitePowder;
@property (assign, nonatomic) NSInteger redPowder;
@property (assign, nonatomic) NSInteger greyPowder;
@property (assign, nonatomic) NSInteger liquidCrystal;
@property (assign, nonatomic) NSInteger currentFreezers;
@property (assign, nonatomic) NSInteger tickets;

@property (assign, nonatomic) NSInteger currentSeller;
@property (assign, nonatomic) NSInteger currentBully;
@property (assign, nonatomic) NSInteger currentLawyer;
@property (assign, nonatomic) NSInteger currentSpy;

@property (assign, nonatomic) NSInteger totalCustomersAttended;
@property (assign, nonatomic) NSInteger totalCustomersIgnored;
@property (assign, nonatomic) NSInteger totalCustomersNotAttended;
@property (assign, nonatomic) NSInteger totalCrystalSold;
@property (assign, nonatomic) NSInteger totalCrystalMade;
@property (assign, nonatomic) NSInteger totalLiquidCrystal;
@property (assign, nonatomic) NSInteger totalRedPowder;
@property (assign, nonatomic) NSInteger totalWhitePowder;
@property (assign, nonatomic) NSInteger totalGreyPowder;
@property (assign, nonatomic) NSInteger totalPills;
@property (assign, nonatomic) NSInteger totalMatchboxes;
@property (assign, nonatomic) NSInteger totalAluminum;
@property (assign, nonatomic) NSInteger totalTime;
@property (assign, nonatomic) NSInteger totalXpGained;
@property (assign, nonatomic) NSInteger totalMoneyMade;

@property (assign, nonatomic) NSInteger currentLabBackground;
@property (assign, nonatomic) NSInteger currentLabSetting;
@property (assign, nonatomic) NSInteger currentGlass;
@property (assign, nonatomic) NSInteger currentBowl;
@property (assign, nonatomic) NSInteger currentPot;
@property (assign, nonatomic) NSInteger currentDecantor;
@property (assign, nonatomic) NSInteger currentExtractor;
@property (assign, nonatomic) NSInteger currentBeaker;
@property (assign, nonatomic) NSInteger currentMixer;
@property (assign, nonatomic) NSInteger currentDistilator;
@property (assign, nonatomic) NSInteger currentCrystalColor;

@property (assign, nonatomic) NSInteger potActive;
@property (assign, nonatomic) float potDate;
@property (assign, nonatomic) float pastDate;

@property (assign, nonatomic) NSInteger removeBanners;

@property (assign, nonatomic) NSInteger screenSize;
@property (assign, nonatomic) NSInteger currentShopList;
@property (assign, nonatomic) NSInteger changeDanger;
@property (assign, nonatomic) NSInteger showCustomerHome;
@property (assign, nonatomic) NSInteger whichCustomerToShow;
@property (assign, nonatomic) NSInteger loadedProducts;
@property (assign, nonatomic) NSInteger scrollToTheLeftLab;

+(instancetype)sharedGameData;

-(void)newGame;
-(void)loadGame;
-(void)saveGame;

-(void)changeXp:(NSInteger)howMuch;
-(void)changeMoney:(NSInteger)howMuch;
-(void)changeTotalMoney:(NSInteger)howMuch;
-(void)changePurity:(NSInteger)howMuch;
@end
