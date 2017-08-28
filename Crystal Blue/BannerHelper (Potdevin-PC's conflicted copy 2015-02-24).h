//
//  BannerHelper.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 7/22/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface BannerHelper : NSObject <ADBannerViewDelegate>

@property (strong, nonatomic) ADBannerView *bannerView;

+(instancetype)sharedAd;

@end
