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
#import <FacebookSDK/FacebookSDK.h>

@implementation CrystalAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [FBLoginView class];
    
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
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [timePlayed invalidate];
    
    [[GameSaveState sharedGameData]saveGame];
    [[ClientsAtHome sharedClientData]saveGame];
    [[GameCenterHelper sharedGC] reportScore];
    [[NSUserDefaults standardUserDefaults]synchronize];
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
    // Logs 'install' and 'app activate' App Events.
    [FBAppEvents activateApp];
    
    timePlayed = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePlayed) userInfo:nil repeats:YES];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [timePlayed invalidate];
    
    [[GameSaveState sharedGameData]saveGame];
    [[ClientsAtHome sharedClientData]saveGame];
    [[GameCenterHelper sharedGC] reportScore];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)timePlayed
{
    [GameSaveState sharedGameData].totalTime+=(1);
    
    if (![[ClientsAtHome sharedClientData] zonesFull]&&
        [GameSaveState sharedGameData].totalTime>60&&
        [GameSaveState sharedGameData].crystal>0) {
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
            NSInteger i = arc4random_uniform(20-(int)[GameSaveState sharedGameData].currentSpy);//20
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
    
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

@end
