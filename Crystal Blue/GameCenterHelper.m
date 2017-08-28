//
//  GameCenterHelper.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 8/23/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "GameCenterHelper.h"

@implementation GameCenterHelper

+ (instancetype)sharedGC {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        
    }
    return self;
}

- (void)authenticateLocalUserOnViewController:(UIViewController*)viewController
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    NSLog(@"Authenticating local user...");
    
    if (localPlayer.authenticated == NO) {
        
        [localPlayer setAuthenticateHandler:^(UIViewController* authViewController, NSError *error) {
            
            if (authViewController != nil) {
                [viewController presentViewController:authViewController animated:YES completion:nil];
            }
            else if (error != nil) {
                NSLog(@"error presenting: %@",error.description);
            }
        }];
    }
    
    else {
        NSLog(@"Already authenticated!");
    }
    
}

- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !_userAuthenticated) {
        
        NSLog(@"Authentication changed: player authenticated.");
        
        _userAuthenticated = TRUE;
        // Load the leaderboard info
        // Load the achievements
        
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && _userAuthenticated) {
        
        NSLog(@"Authentication changed: player not authenticated.");
        _userAuthenticated = FALSE;
    }
}

- (void) reportAchievementIdentifier:(NSString *)identifier percentComplete:(float)percent
{
    GKAchievement *achievement = [[GKAchievement alloc]initWithIdentifier:identifier];
    if (achievement && achievement.percentComplete!=100.0) {
        achievement.percentComplete = percent;
        achievement.showsCompletionBanner = YES;
        
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error)
         {
             if (error!=nil) {
                 NSLog(@"Error while reporting achievement: %@",error.description);
             }
         }];
    }
}

- (void)resetAchievements
{
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil) {
             // handle the error.
             NSLog(@"Error while reseting achievements: %@", error.description);
         }
     }];
}

- (void)reportScore
{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"crystalblue.1"];
    score.value = [GameSaveState sharedGameData].totalXpGained;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error){
        if (error !=nil) {
            NSLog(@"Error reporting score: %@",[error localizedDescription]);
        }
    }];
}

- (void)authenticateLocalPlayer:(UIViewController*)viewController
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *auViewController, NSError *error){
        if (auViewController != nil) {
            [viewController presentViewController:auViewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _userAuthenticated = YES;
            }
            else{
                _userAuthenticated = NO;
            }
        }
    };
}

- (void)showLeaderboardOnViewController:(UIViewController *)viewController
{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc]init];
    if (gcViewController != nil) {
        gcViewController.gameCenterDelegate = self;
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = @"crystalblue.1";
        
        [viewController presentViewController:gcViewController animated:YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkLevelAchievements
{
    NSInteger currentLevel = [GameSaveState sharedGameData].level;
    for (int i=2; i<=21; i++) {
        NSString *cualLevelAchievement = [NSString stringWithFormat:@"reachLevel%i",i];
        if (currentLevel>=i) {
            [self reportAchievementIdentifier:cualLevelAchievement percentComplete:100.0];
        }
    }
}

-(void)earnMoneyAchievements
{
    for (int i = 1; i<6; i++) {
        int cuanto = 100*(10^i);
        if ([GameSaveState sharedGameData].totalMoneyMade>=cuanto) {
            NSString *achievementName = [NSString stringWithFormat:@"earn%imoney",cuanto];
            [self reportAchievementIdentifier:achievementName percentComplete:100.0];
        }
    }
}

-(void)makeLiquidAchievements
{
    NSInteger currentLiquid = [GameSaveState sharedGameData].totalLiquidCrystal;
    
    if (currentLiquid>=10000) {
        [self reportAchievementIdentifier:@"make1Liquid" percentComplete:100.0];
    }
    if (currentLiquid>=50) {
        [self reportAchievementIdentifier:@"make50Liquid" percentComplete:100.0];
    }
    if (currentLiquid>=100) {
        [self reportAchievementIdentifier:@"make100Liquid" percentComplete:100.0];
    }
    if (currentLiquid>=1000) {
        [self reportAchievementIdentifier:@"make1000Liquid" percentComplete:100.0];
    }
}

-(void)makeRedAchievements
{
    NSInteger currentRed = [GameSaveState sharedGameData].totalRedPowder;
    
    if (currentRed>=10000) {
        [self reportAchievementIdentifier:@"make1Red" percentComplete:100.0];
    }
    if (currentRed>=50) {
        [self reportAchievementIdentifier:@"make50Red" percentComplete:100.0];
    }
    if (currentRed>=100) {
        [self reportAchievementIdentifier:@"make100Red" percentComplete:100.0];
    }
    if (currentRed>=1000) {
        [self reportAchievementIdentifier:@"make1000Red" percentComplete:100.0];
    }
}

-(void)makeWhiteAchievements
{
    NSInteger currentWhite = [GameSaveState sharedGameData].totalWhitePowder;
    
    if (currentWhite>=10000) {
        [self reportAchievementIdentifier:@"make1White" percentComplete:100.0];
    }
    if (currentWhite>=50) {
        [self reportAchievementIdentifier:@"make50White" percentComplete:100.0];
    }
    if (currentWhite>=100) {
        [self reportAchievementIdentifier:@"make100White" percentComplete:100.0];
    }
    if (currentWhite>=1000) {
        [self reportAchievementIdentifier:@"make1000White" percentComplete:100.0];
    }
}

-(void)makeGreyAchievements
{
    NSInteger currentGrey = [GameSaveState sharedGameData].totalGreyPowder;
    
    if (currentGrey>=10000) {
        [self reportAchievementIdentifier:@"make1Grey" percentComplete:100.0];
    }
    if (currentGrey>=50) {
        [self reportAchievementIdentifier:@"make50Grey" percentComplete:100.0];
    }
    if (currentGrey>=100) {
        [self reportAchievementIdentifier:@"make100Grey" percentComplete:100.0];
    }
    if (currentGrey>=1000) {
        [self reportAchievementIdentifier:@"make1000Grey" percentComplete:100.0];
    }
}

-(void)makeCrystalAchievements
{
    NSInteger currentCrystal = [GameSaveState sharedGameData].totalCrystalMade;
    
    if (currentCrystal>=100000) {
        [self reportAchievementIdentifier:@"make1Crystal" percentComplete:100.0];
    }
    if (currentCrystal>=50) {
        [self reportAchievementIdentifier:@"make50Crystal" percentComplete:100.0];
    }
    if (currentCrystal>=100) {
        [self reportAchievementIdentifier:@"make100Crystal" percentComplete:100.0];
    }
    if (currentCrystal>=1000) {
        [self reportAchievementIdentifier:@"make1000Crystal" percentComplete:100.0];
    }
    if (currentCrystal>=5000) {
        [self reportAchievementIdentifier:@"make5000Crystal" percentComplete:100.0];
    }
    if (currentCrystal>=10000) {
        [self reportAchievementIdentifier:@"make10000Crystal" percentComplete:100.0];
    }
}

-(void)sellCustomerAchievements
{
    NSInteger currentCustomersSold = [GameSaveState sharedGameData].totalCustomersAttended;
    
    if (currentCustomersSold>=1) {
        [self reportAchievementIdentifier:@"sell1Customer" percentComplete:100.0];
    }
    if (currentCustomersSold>=10) {
        [self reportAchievementIdentifier:@"sell10Customer" percentComplete:100.0];
    }
    if (currentCustomersSold>=100) {
        [self reportAchievementIdentifier:@"sell100Customer" percentComplete:100.0];
    }
    if (currentCustomersSold>=1000) {
        [self reportAchievementIdentifier:@"sell1000Customer" percentComplete:100.0];
    }
    if (currentCustomersSold>=5000) {
        [self reportAchievementIdentifier:@"sell5000Customer" percentComplete:100.0];
    }
    if (currentCustomersSold>=10000) {
        [self reportAchievementIdentifier:@"sell10000Customer" percentComplete:100.0];
    }
}

-(void)sellCrystalAchievements
{
    NSInteger currentCrystalSold = [GameSaveState sharedGameData].totalCrystalSold;
    
    if (currentCrystalSold>=20) {
        [self reportAchievementIdentifier:@"sell1Crystal" percentComplete:100.0];
    }
    if (currentCrystalSold>=100) {
        [self reportAchievementIdentifier:@"sell100Crystal" percentComplete:100.0];
    }
    if (currentCrystalSold>=500) {
        [self reportAchievementIdentifier:@"sell500Crystal" percentComplete:100.0];
    }
    if (currentCrystalSold>=1000) {
        [self reportAchievementIdentifier:@"sell1000Crystal" percentComplete:100.0];
    }
    if (currentCrystalSold>=5000) {
        [self reportAchievementIdentifier:@"sell5000Crystal" percentComplete:100.0];
    }
    if (currentCrystalSold>=10000) {
        [self reportAchievementIdentifier:@"sell10000Crystal" percentComplete:100.0];
    }
    if (currentCrystalSold>=100000) {
        [self reportAchievementIdentifier:@"sell100000Crystal" percentComplete:100.0];
    }
    if (currentCrystalSold>=1000000) {
        [self reportAchievementIdentifier:@"sell1000000Crystal" percentComplete:100.0];
    }
}

-(void)ignoreCustomerAchievements
{
    NSInteger currentCustomersSold = [GameSaveState sharedGameData].totalCustomersIgnored;
    
    if (currentCustomersSold>=10) {
        [self reportAchievementIdentifier:@"ignore10Customer" percentComplete:100.0];
    }
    if (currentCustomersSold>=50) {
        [self reportAchievementIdentifier:@"ignore50Customer" percentComplete:100.0];
    }
    if (currentCustomersSold>=100) {
        [self reportAchievementIdentifier:@"ignore100Customer" percentComplete:100.0];
    }
    if (currentCustomersSold>=1000) {
        [self reportAchievementIdentifier:@"ignore1000Customer" percentComplete:100.0];
    }
}

-(void)playTimeAchievements
{
    NSInteger totalTimePlayed = [GameSaveState sharedGameData].totalTime;
    
    if (totalTimePlayed>=600) {
        [self reportAchievementIdentifier:@"play10min" percentComplete:100.0];
    }
    if (totalTimePlayed>=3600) {
        [self reportAchievementIdentifier:@"play1hour" percentComplete:100.0];
    }
    if (totalTimePlayed>=14400) {
        [self reportAchievementIdentifier:@"play4Hours" percentComplete:100.0];
    }
    if (totalTimePlayed>=28800) {
        [self reportAchievementIdentifier:@"play8Hours" percentComplete:100.0];
    }
    if (totalTimePlayed>=43200) {
        [self reportAchievementIdentifier:@"play12Hours" percentComplete:100.0];
    }
    if (totalTimePlayed>=86400) {
        [self reportAchievementIdentifier:@"play24Hours" percentComplete:100.0];
    }
    if (totalTimePlayed>=259200) {
        [self reportAchievementIdentifier:@"play3Days" percentComplete:100.0];
    }
    if (totalTimePlayed>=604800) {
        [self reportAchievementIdentifier:@"play1Week" percentComplete:100.0];
    }
}

-(void)reachDominationAchievements
{
    NSArray *sellsForDominance = [NSArray arrayWithObjects:
                                  @1800,
                                  @1950,
                                  @2150,
                                  @2000,
                                  @2200,
                                  @2050,
                                  @1970,
                                  @1630,
                                  @2180,
                                  @2090,
                                  nil];
    
    int totalSellsForDominance=0;
    for (int i=0; i<sellsForDominance.count; i++) {
        totalSellsForDominance = totalSellsForDominance+[sellsForDominance[i]intValue];
    }
    
    int totalVisits=0;
    for (int i=0; i<10; i++) {
        totalVisits = totalVisits + [[ClientsAtHome sharedClientData].timesSentToEachPlace[i]intValue];
    }
    
    float dominance = (float)(totalVisits*100)/totalSellsForDominance;
    
    if (dominance>=10) {
        [self reportAchievementIdentifier:@"reach10Domination" percentComplete:100.0];
    }
    if (dominance>=30) {
        [self reportAchievementIdentifier:@"reach30Domination" percentComplete:100.0];
    }
    if (dominance>=70) {
        [self reportAchievementIdentifier:@"reach70Domination" percentComplete:100.0];
    }
    if (dominance>=100) {
        [self reportAchievementIdentifier:@"reach100Domination" percentComplete:100.0];
    }
}

-(void)reachPurityAchievements
{
    float currentPurity = (float)[GameSaveState sharedGameData].purity/100;
    
    for (int i=2; i<10; i++) {
        if (currentPurity>=10*i) {
            NSString *cualAchievement = [NSString stringWithFormat:@"reach%iPurity",10*i];
            [self reportAchievementIdentifier:cualAchievement percentComplete:100.0];
        }
    }
    
    if (currentPurity>=99.9) {
        [self reportAchievementIdentifier:@"reachMaxPurity" percentComplete:100.0];
    }
}

-(void)buyThingsAchievements
{
    if ([GameSaveState sharedGameData].currentLabSetting==2) {
        [self reportAchievementIdentifier:@"buyAdvancedLab" percentComplete:100.0];
    }
}

/*-(void)postFacebookScore
{
    int nScore = (int)[GameSaveState sharedGameData].totalXpGained;
    
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSString stringWithFormat:@"%d", nScore], @"score",
                                     nil];
    
    NSLog(@"Posting score of %d", nScore);
    
    [FBRequestConnection startWithGraphPath:@"/me/scores" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        NSLog(@"Score posted");
    }];
}*/

-(void)checkAllAchievements
{
    [self checkLevelAchievements];
    [self earnMoneyAchievements];
    [self makeLiquidAchievements];
    [self makeRedAchievements];
    [self makeWhiteAchievements];
    [self makeGreyAchievements];
    [self makeCrystalAchievements];
    [self sellCustomerAchievements];
    [self sellCrystalAchievements];
    [self ignoreCustomerAchievements];
    [self playTimeAchievements];
    [self reachDominationAchievements];
    [self reachPurityAchievements];
    [self buyThingsAchievements];
}

@end
