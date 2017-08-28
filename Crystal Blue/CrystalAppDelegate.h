
//
//  CrystalAppDelegate.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 5/30/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrystalAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSInteger totalTime;
    NSTimer *timePlayed;
}

@property (strong, nonatomic) UIWindow *window;

@end
