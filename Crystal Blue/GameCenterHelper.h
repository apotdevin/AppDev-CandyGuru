//
//  GameCenterHelper.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 8/23/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "ClientsAtHome.h"
#import "FacebookSDK/FacebookSDK.h"

@interface GameCenterHelper : NSObject <GKGameCenterControllerDelegate>

@property (assign, nonatomic) BOOL userAuthenticated;

+(instancetype)sharedGC;
-(void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent;
-(void)resetAchievements;
- (void)authenticateLocalUserOnViewController:(UIViewController*)viewController;
-(void)reportScore;
-(void)showLeaderboardOnViewController:(UIViewController*)viewController;

-(void)checkLevelAchievements;
-(void)earnMoneyAchievements;
-(void)makeLiquidAchievements;
-(void)makeRedAchievements;
-(void)makeWhiteAchievements;
-(void)makeGreyAchievements;
-(void)makeCrystalAchievements;
-(void)sellCustomerAchievements;
-(void)sellCrystalAchievements;
-(void)ignoreCustomerAchievements;
-(void)playTimeAchievements;
-(void)reachDominationAchievements;
-(void)reachPurityAchievements;
-(void)buyThingsAchievements;

-(void)checkAllAchievements;

//-(void)postFacebookScore;

@end
