//
//  CrystalAppDelegate.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 5/30/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "CrystalAppDelegate.h"
#import "ClientsAtHome.h"
#import "BannerHelper.h"
#import "SoundHelper.h"
#import "FacebookSDK/FacebookSDK.h"
#import <Parse/Parse.h>
#import <ParseCrashReporting/ParseCrashReporting.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ParseHelper.h"

@implementation CrystalAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [application setStatusBarHidden:YES];
    
    //PARSE
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [Parse enableLocalDatastore];
    
    [ParseCrashReporting enable];
    // Initialize Parse.
    [Parse setApplicationId:@"V1rkmJEJPKzhgcs4uvlb5QSwdqSsFu7n8clT6YEG"
                  clientKey:@"8H4CAsnqlYgyH12Am7MetYZL1YW9Bd1Q0CFYLZjF"];
    [PFFacebookUtils initializeFacebook];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    //[application registerUserNotificationSettings:settings];
    //[application registerForRemoteNotifications];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    //FACEBOOK
    [FBLoginView class];
    [FBProfilePictureView class];
    //[FBLikeControl class];
    
    //NSString* uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //[NSUserDefaults setDeviceIdentifier:uniqueIdentifier];
    [NSUserDefaults setSecret:@"superdupersecretcode"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstViewApp"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewApp"];
        [[GameSaveState sharedGameData] newGame];
        [[ClientsAtHome sharedClientData] newGame];
    }
    else
    {
        [[GameSaveState sharedGameData] loadGame];
        [[ClientsAtHome sharedClientData] loadGame];
    }
    
    [[SoundHelper sharedSoundInstance] startSoundSession];
    
    //PARSE IN APP PURCHASES
    [PFPurchase addObserverForProduct:@"anthonypotdevin.crystalblue.1000cash" block:^(SKPaymentTransaction *transaction) {
        [PFPurchase downloadAssetForTransaction:transaction completion:^(NSString *filePath, NSError *error) {
            if (!error) {
                // at this point, the content file is available at filePath.
                NSLog(@"Valido");
                
                [[GameSaveState sharedGameData] changeMoney:3000];
                [[GameSaveState sharedGameData] saveGame];
                
                [self saveUserInfoWhenPurchase:@"3000 cash"];
                [[ParseHelper sharedParseData] saveOldGame];
            }
            else
            {
                NSLog(@"NO Valido");
                [self saveUserInfoWhenPurchase:@"NoPasoPrueba"];
            }
        }];
    }];
    [PFPurchase addObserverForProduct:@"anthonypotdevin.crystalblue.10000cash" block:^(SKPaymentTransaction *transaction) {
        [PFPurchase downloadAssetForTransaction:transaction completion:^(NSString *filePath, NSError *error) {
            if (!error) {
                // at this point, the content file is available at filePath.
                NSLog(@"Valido");
                
                [[GameSaveState sharedGameData] changeMoney:10000];
                [[GameSaveState sharedGameData] saveGame];
                
                [self saveUserInfoWhenPurchase:@"10000 cash"];
                [[ParseHelper sharedParseData] saveOldGame];
            }
            else
            {
                NSLog(@"NO Valido");
                [self saveUserInfoWhenPurchase:@"NoPasoPrueba"];
            }
        }];
    }];
    [PFPurchase addObserverForProduct:@"anthonypotdevin.crystalblue.100000cash" block:^(SKPaymentTransaction *transaction) {
        [PFPurchase downloadAssetForTransaction:transaction completion:^(NSString *filePath, NSError *error) {
            if (!error) {
                // at this point, the content file is available at filePath.
                NSLog(@"Valido");
                
                [[GameSaveState sharedGameData] changeMoney:100000];
                [[GameSaveState sharedGameData] saveGame];
                
                [self saveUserInfoWhenPurchase:@"100000 cash"];
                [[ParseHelper sharedParseData] saveOldGame];
            }
            else
            {
                NSLog(@"NO Valido");
                [self saveUserInfoWhenPurchase:@"NoPasoPrueba"];
            }
        }];
    }];
    [PFPurchase addObserverForProduct:@"anthonypotdevin.crystalblue.1000000cash" block:^(SKPaymentTransaction *transaction) {
        [PFPurchase downloadAssetForTransaction:transaction completion:^(NSString *filePath, NSError *error) {
            if (!error) {
                // at this point, the content file is available at filePath.
                NSLog(@"Valido");
                
                [[GameSaveState sharedGameData] changeMoney:1000000];
                [[GameSaveState sharedGameData] saveGame];
                
                [self saveUserInfoWhenPurchase:@"1000000 cash"];
                [[ParseHelper sharedParseData] saveOldGame];
            }
            else
            {
                NSLog(@"NO Valido");
                [self saveUserInfoWhenPurchase:@"NoPasoPrueba"];
            }
        }];
    }];
    [PFPurchase addObserverForProduct:@"anthonypotdevin.crystalblue.5tickets" block:^(SKPaymentTransaction *transaction) {
        [PFPurchase downloadAssetForTransaction:transaction completion:^(NSString *filePath, NSError *error) {
            if (!error) {
                // at this point, the content file is available at filePath.
                NSLog(@"Valido");
                
                [GameSaveState sharedGameData].tickets+=5;
                [[GameSaveState sharedGameData] saveGame];
                
                [self saveUserInfoWhenPurchase:@"5 tickets"];
                [[ParseHelper sharedParseData] saveOldGame];
            }
            else
            {
                NSLog(@"NO Valido");
                [self saveUserInfoWhenPurchase:@"NoPasoPrueba"];
            }
        }];
    }];
    [PFPurchase addObserverForProduct:@"anthonypotdevin.crystalblue.20tickets" block:^(SKPaymentTransaction *transaction) {
        [PFPurchase downloadAssetForTransaction:transaction completion:^(NSString *filePath, NSError *error) {
            if (!error) {
                // at this point, the content file is available at filePath.
                NSLog(@"Valido");
                
                [GameSaveState sharedGameData].tickets+=20;
                [[GameSaveState sharedGameData] saveGame];
                
                [self saveUserInfoWhenPurchase:@"20 tickets"];
                [[ParseHelper sharedParseData] saveOldGame];
            }
            else
            {
                NSLog(@"NO Valido");
                [self saveUserInfoWhenPurchase:@"NoPasoPrueba"];
            }
        }];
    }];
    [PFPurchase addObserverForProduct:@"anthonypotdevin.crystalblue.40tickets" block:^(SKPaymentTransaction *transaction) {
        [PFPurchase downloadAssetForTransaction:transaction completion:^(NSString *filePath, NSError *error) {
            if (!error) {
                // at this point, the content file is available at filePath.
                NSLog(@"Valido");
                
                [GameSaveState sharedGameData].tickets+=40;
                [[GameSaveState sharedGameData] saveGame];
                
                [self saveUserInfoWhenPurchase:@"40 tickets"];
                [[ParseHelper sharedParseData] saveOldGame];
            }
            else
            {
                NSLog(@"NO Valido");
                [self saveUserInfoWhenPurchase:@"NoPasoPrueba"];
            }
        }];
    }];
    [PFPurchase addObserverForProduct:@"anthonypotdevin.crystalblue.removebanners" block:^(SKPaymentTransaction *transaction) {
        [PFPurchase downloadAssetForTransaction:transaction completion:^(NSString *filePath, NSError *error) {
            if (!error) {
                // at this point, the content file is available at filePath.
                NSLog(@"Valido");
                
                [GameSaveState sharedGameData].removeBanners=641;
                [[GameSaveState sharedGameData] saveGame];
                
                [self saveUserInfoWhenPurchase:@"Banners"];
                [[ParseHelper sharedParseData] saveOldGame];
            }
            else
            {
                NSLog(@"NO Valido");
                [self saveUserInfoWhenPurchase:@"NoPasoPrueba"];
            }
        }];
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [timePlayed invalidate];
    
    [[GameSaveState sharedGameData]saveGame];
    [[ClientsAtHome sharedClientData]saveGame];
    [[GameCenterHelper sharedGC] reportScore];
    //[[GameCenterHelper sharedGC] postFacebookScore];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[SoundHelper sharedSoundInstance] stopBackground];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    
    [[PFUser currentUser]fetchInBackground];
    
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
    [FBAppEvents activateApp];
    timePlayed = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePlayed) userInfo:nil repeats:YES];
    [[SoundHelper sharedSoundInstance] playBackground];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[PFFacebookUtils session] close];
    
    [timePlayed invalidate];
    
    [[ParseHelper sharedParseData]saveOldGame];
    [[GameSaveState sharedGameData]saveGame];
    [[ClientsAtHome sharedClientData]saveGame];
    [[GameCenterHelper sharedGC] reportScore];
    //[[GameCenterHelper sharedGC] postFacebookScore];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[SoundHelper sharedSoundInstance] stopBackground];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)timePlayed
{
    [GameSaveState sharedGameData].totalTime+=(1);
    
    if (![[ClientsAtHome sharedClientData] zonesFull]&&
        [GameSaveState sharedGameData].totalTime>30&&
        [GameSaveState sharedGameData].crystal>0&&
        [[NSUserDefaults standardUserDefaults] boolForKey:@"terminoTutorial"]==YES) {
        int puede = 0;
        
        if ([GameSaveState sharedGameData].showCustomerHome==1)
        {
            puede=1;
        }
        else if (![[ClientsAtHome sharedClientData] notAtHomeFull])
        {
            puede=1;
        }
        if (puede==1) {
            NSInteger i = arc4random_uniform(45-3*(int)[GameSaveState sharedGameData].currentSpy);
            if (i==0)
            {
                int cualCliente = [[ClientsAtHome sharedClientData] availableClient];
                int cualZone = [[ClientsAtHome sharedClientData] availableZone];
                
                [[ClientsAtHome sharedClientData].infoClientes replaceObjectAtIndex:cualCliente withObject:[NSNumber numberWithInt:cualZone]];
                [[ClientsAtHome sharedClientData].infoZone replaceObjectAtIndex:cualZone withObject:@1];
                
                if ([GameSaveState sharedGameData].showCustomerHome==1) {
                    [GameSaveState sharedGameData].whichCustomerToShow=cualCliente;
                }
            }
        }
    }
    
    NSInteger tiempoTotal = [GameSaveState sharedGameData].totalTime;
    
    if (tiempoTotal%(1000-10*[GameSaveState sharedGameData].currentLawyer)==0&&
        [ClientsAtHome sharedClientData].dangerClientOnOrOff==0&&
        [GameSaveState sharedGameData].level>=4&&
        tiempoTotal>0)
    {
        int j = (int)arc4random_uniform(3+(int)[GameSaveState sharedGameData].currentLawyer);
        NSLog(@"Sec Total:%i Min: %i Num Aleatorio: %i",(int)tiempoTotal,(int)tiempoTotal/60,j);
        if (j==0) {
            
            [[SoundHelper sharedSoundInstance] playSound:8];
            [self randomDanger];
            [ClientsAtHome sharedClientData].dangerStartDate= CACurrentMediaTime();
            [ClientsAtHome sharedClientData].dangerClientOnOrOff=1;
        }
    }
    
    if (tiempoTotal%1200==0&&[[NSUserDefaults standardUserDefaults]integerForKey:@"shareAvailable"]==1) {
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"shareAvailable"];
    }
    
    //PFUser *user = [PFUser currentUser];
    if (tiempoTotal%300==0
        &&[PFUser currentUser]
        &&[PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        [[ParseHelper sharedParseData] saveOldGame];
        NSLog(@"SAVED PARSE GAME AFTER 5min");
    }
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)randomDanger
{
    NSMutableArray *possibleDangers = [[NSMutableArray alloc]init];
    [possibleDangers addObject:@0];
    [possibleDangers addObject:@1];
    [possibleDangers addObject:@2];
    [possibleDangers addObject:@3];
    [possibleDangers addObject:@4];
    [possibleDangers addObject:@5];
    [possibleDangers addObject:@6];
    [possibleDangers addObject:@7];
    [possibleDangers addObject:@8];
    [possibleDangers addObject:@9];
    
    if ([GameSaveState sharedGameData].currentLawyer==0) {
        [possibleDangers removeObject:@0];
    }
    if ([GameSaveState sharedGameData].currentSeller==0)
    {
        [possibleDangers removeObject:@1];
    }
    if ([GameSaveState sharedGameData].currentBully==0)
    {
        [possibleDangers removeObject:@2];
    }
    if ([GameSaveState sharedGameData].currentSpy==0)
    {
        [possibleDangers removeObject:@3];
    }
    if ([GameSaveState sharedGameData].crystal==0) {
        [possibleDangers removeObject:@6];
    }
    if ([GameSaveState sharedGameData].liquidCrystal==0) {
        [possibleDangers removeObject:@8];
    }
    if ([GameSaveState sharedGameData].currentFreezers==1)
    {
        [possibleDangers removeObject:@9];
    }
    
    NSInteger which = arc4random_uniform((int)possibleDangers.count);
    int selectedDanger = [[possibleDangers objectAtIndex:which] intValue];
    
    [ClientsAtHome sharedClientData].whichDanger = selectedDanger;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@" Failed to register for remote notifications: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)saveUserInfoWhenPurchase:(NSString*)whichPurchase
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"facebookCompleteName"]!=nil) {
        PFObject *userPurchasedObject = [PFObject objectWithClassName:@"Purchase"];
        userPurchasedObject[@"Name"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"facebookCompleteName"];
        userPurchasedObject[@"Item"] = whichPurchase;
        [userPurchasedObject saveEventually];
    }
    else
    {
        PFObject *userPurchasedObject = [PFObject objectWithClassName:@"AnonPurchase"];
        userPurchasedObject[@"Item"] = whichPurchase;
        [userPurchasedObject saveEventually];
    }
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
{
    [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

@end
