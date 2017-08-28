//
//  BannerHelper.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 7/22/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "BannerHelper.h"


@implementation BannerHelper

+ (instancetype)sharedAd {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if (self) {
        
        if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
            
            _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        }
        else {
            _bannerView = [[ADBannerView alloc] init];
        }
        _bannerView.delegate = self;
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        [_bannerView setFrame:CGRectMake(0, screenBounds.size.height-50, screenBounds.size.width, 50)];
        [_bannerView setAlpha:0];
    }
    return self;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    //if ([[NSUserDefaults standardUserDefaults] boolForKey:@"terminoTutorial"]==YES)
    //{
    [UIView animateWithDuration:0.5
                     animations:^{
                         _bannerView.alpha=1;
                     }];
    //}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Banner Failed: %@",error);
    [UIView animateWithDuration:0.5
                     animations:^{
                         _bannerView.alpha=0;
                     }];
}

@end
