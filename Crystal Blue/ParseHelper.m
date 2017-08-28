//
//  ParseHelper.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 3/4/15.
//  Copyright (c) 2015 Anthony Potdevin. All rights reserved.
//

#import "ParseHelper.h"
#import <Parse/Parse.h>
#import "GameSaveState.h"

@implementation ParseHelper

+ (instancetype)sharedParseData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)loadOldGame:(PFUser*)user
{
    NSLog(@"USER FETCHED");
    [GameSaveState sharedGameData].xp=[[user objectForKey:@"Xp"] integerValue];
    [GameSaveState sharedGameData].level=[[user objectForKey:@"Level"] integerValue];
    [GameSaveState sharedGameData].purity=[[user objectForKey:@"Sweet"] integerValue];
    [GameSaveState sharedGameData].money=[[user objectForKey:@"Money"] integerValue];
    [GameSaveState sharedGameData].crystal=[[user objectForKey:@"Candy"] integerValue];
    [GameSaveState sharedGameData].pills=[[user objectForKey:@"Sugar"] integerValue];
    [GameSaveState sharedGameData].matchbox=[[user objectForKey:@"Taffy"] integerValue];
    [GameSaveState sharedGameData].aluminum=[[user objectForKey:@"Licorice"] integerValue];
    [GameSaveState sharedGameData].whitePowder=[[user objectForKey:@"White"] integerValue];
    [GameSaveState sharedGameData].redPowder=[[user objectForKey:@"Red"] integerValue];
    [GameSaveState sharedGameData].greyPowder=[[user objectForKey:@"Bites"] integerValue];
    [GameSaveState sharedGameData].liquidCrystal=[[user objectForKey:@"Soft"] integerValue];
    [GameSaveState sharedGameData].currentFreezers=[[user objectForKey:@"Freezers"] integerValue];
    [GameSaveState sharedGameData].tickets=[[user objectForKey:@"Bars"] integerValue];
    
    [GameSaveState sharedGameData].currentSeller=[[user objectForKey:@"Cart"] integerValue];
    [GameSaveState sharedGameData].currentBully=[[user objectForKey:@"Ads"] integerValue];
    [GameSaveState sharedGameData].currentLawyer=[[user objectForKey:@"Insurance"] integerValue];
    [GameSaveState sharedGameData].currentSpy=[[user objectForKey:@"Event"] integerValue];
    
    [GameSaveState sharedGameData].totalCustomersAttended=[[user objectForKey:@"tCusAttended"] integerValue];
    [GameSaveState sharedGameData].totalCustomersIgnored=[[user objectForKey:@"tCusIgnored"] integerValue];
    [GameSaveState sharedGameData].totalCustomersNotAttended=[[user objectForKey:@"tCusNotAttended"] integerValue];
    [GameSaveState sharedGameData].totalCrystalSold=[[user objectForKey:@"tCandySold"] integerValue];
    [GameSaveState sharedGameData].totalCrystalMade=[[user objectForKey:@"tCandyMade"] integerValue];
    [GameSaveState sharedGameData].totalLiquidCrystal=[[user objectForKey:@"tSoftCandy"] integerValue];
    [GameSaveState sharedGameData].totalRedPowder=[[user objectForKey:@"tRedPowder"] integerValue];
    [GameSaveState sharedGameData].totalWhitePowder=[[user objectForKey:@"tWhitePowder"] integerValue];
    [GameSaveState sharedGameData].totalGreyPowder=[[user objectForKey:@"tLicoriceBites"] integerValue];
    [GameSaveState sharedGameData].totalPills=[[user objectForKey:@"tSugar"] integerValue];
    [GameSaveState sharedGameData].totalMatchboxes=[[user objectForKey:@"tTaffy"] integerValue];
    [GameSaveState sharedGameData].totalAluminum=[[user objectForKey:@"tLicorice"] integerValue];
    [GameSaveState sharedGameData].totalXpGained=[[user objectForKey:@"tXp"] integerValue];
    [GameSaveState sharedGameData].totalMoneyMade=[[user objectForKey:@"tMoney"] integerValue];
    [GameSaveState sharedGameData].totalTime=[[user objectForKey:@"tTime"] integerValue];
    
    [GameSaveState sharedGameData].currentLabBackground=[[user objectForKey:@"curBackground"] integerValue];
    [GameSaveState sharedGameData].currentLabSetting=[[user objectForKey:@"curSetting"] integerValue];
    [GameSaveState sharedGameData].currentGlass=[[user objectForKey:@"curGlass"] integerValue];
    [GameSaveState sharedGameData].currentBowl=[[user objectForKey:@"curBowl"] integerValue];
    [GameSaveState sharedGameData].currentPot=[[user objectForKey:@"curPot"] integerValue];
    [GameSaveState sharedGameData].currentDecantor=[[user objectForKey:@"curDecantor"] integerValue];
    [GameSaveState sharedGameData].currentExtractor=[[user objectForKey:@"curExtractor"] integerValue];
    [GameSaveState sharedGameData].currentBeaker=[[user objectForKey:@"curBeaker"] integerValue];
    [GameSaveState sharedGameData].currentMixer=[[user objectForKey:@"curMixer"] integerValue];
    [GameSaveState sharedGameData].currentDistilator=[[user objectForKey:@"curDistilator"] integerValue];
    [GameSaveState sharedGameData].currentCrystalColor=[[user objectForKey:@"curColor"] integerValue];
}

-(void)saveOldGame
{
    PFUser *user = [PFUser currentUser];
    
    user[@"Xp"]=@([GameSaveState sharedGameData].xp);
    user[@"Level"]=@([GameSaveState sharedGameData].level);
    user[@"Sweet"]=@([GameSaveState sharedGameData].purity);
    user[@"Money"]=@([GameSaveState sharedGameData].money);
    user[@"Candy"]=@([GameSaveState sharedGameData].crystal);
    user[@"Sugar"]=@([GameSaveState sharedGameData].pills);
    user[@"Taffy"]=@([GameSaveState sharedGameData].matchbox);
    user[@"Licorice"]=@([GameSaveState sharedGameData].aluminum);
    user[@"White"]=@([GameSaveState sharedGameData].whitePowder);
    user[@"Red"]=@([GameSaveState sharedGameData].redPowder);
    user[@"Bites"]=@([GameSaveState sharedGameData].greyPowder);
    user[@"Soft"]=@([GameSaveState sharedGameData].liquidCrystal);
    user[@"Freezers"]=@([GameSaveState sharedGameData].currentFreezers);
    user[@"Bars"]=@([GameSaveState sharedGameData].tickets);
    
    user[@"Cart"]=@([GameSaveState sharedGameData].currentSeller);
    user[@"Ads"]=@([GameSaveState sharedGameData].currentBully);
    user[@"Insurance"]=@([GameSaveState sharedGameData].currentLawyer);
    user[@"Event"]=@([GameSaveState sharedGameData].currentSpy);
    
    user[@"tCusAttended"]=@([GameSaveState sharedGameData].totalCustomersAttended);
    user[@"tCusIgnored"]=@([GameSaveState sharedGameData].totalCustomersIgnored);
    user[@"tCusNotAttended"]=@([GameSaveState sharedGameData].totalCustomersNotAttended);
    user[@"tCandySold"]=@([GameSaveState sharedGameData].totalCrystalSold);
    user[@"tCandyMade"]=@([GameSaveState sharedGameData].totalCrystalMade);
    user[@"tSoftCandy"]=@([GameSaveState sharedGameData].totalLiquidCrystal);
    user[@"tRedPowder"]=@([GameSaveState sharedGameData].totalRedPowder);
    user[@"tWhitePowder"]=@([GameSaveState sharedGameData].totalWhitePowder);
    user[@"tLicoriceBites"]=@([GameSaveState sharedGameData].totalGreyPowder);
    user[@"tSugar"]=@([GameSaveState sharedGameData].totalPills);
    user[@"tTaffy"]=@([GameSaveState sharedGameData].totalMatchboxes);
    user[@"tLicorice"]=@([GameSaveState sharedGameData].totalAluminum);
    user[@"tXp"]=@([GameSaveState sharedGameData].totalXpGained);
    user[@"tMoney"]=@([GameSaveState sharedGameData].totalMoneyMade);
    user[@"tTime"]=@([GameSaveState sharedGameData].totalTime);
    
    user[@"curBackground"]=@([GameSaveState sharedGameData].currentLabBackground);
    user[@"curSetting"]=@([GameSaveState sharedGameData].currentLabSetting);
    user[@"curGlass"]=@([GameSaveState sharedGameData].currentGlass);
    user[@"curBowl"]=@([GameSaveState sharedGameData].currentBowl);
    user[@"curPot"]=@([GameSaveState sharedGameData].currentPot);
    user[@"curDecantor"]=@([GameSaveState sharedGameData].currentDecantor);
    user[@"curExtractor"]=@([GameSaveState sharedGameData].currentExtractor);
    user[@"curBeaker"]=@([GameSaveState sharedGameData].currentBeaker);
    user[@"curMixer"]=@([GameSaveState sharedGameData].currentMixer);
    user[@"curDistilator"]=@([GameSaveState sharedGameData].currentDistilator);
    user[@"curColor"]=@([GameSaveState sharedGameData].currentCrystalColor);
    
    [user saveEventually];
    NSLog(@"PARSE SAVE");
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastSaveDate"];
}

@end
