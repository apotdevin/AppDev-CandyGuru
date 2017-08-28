//
//  CrystalblueIAPHelper.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 8/29/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "CrystalblueIAPHelper.h"

@implementation CrystalblueIAPHelper

+ (CrystalblueIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static CrystalblueIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"anthonypotdevin.crystalblue.removebanners",
                                      @"anthonypotdevin.crystalblue.1000cash",
                                      @"anthonypotdevin.crystalblue.10000cash",
                                      @"anthonypotdevin.crystalblue.100000cash",
                                      @"anthonypotdevin.crystalblue.1000000cash",
                                      @"anthonypotdevin.crystalblue.5tickets",
                                      @"anthonypotdevin.crystalblue.20tickets",
                                      @"anthonypotdevin.crystalblue.40tickets",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
