//
//  IAPHelper.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 8/29/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;
typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

-(void)buyProduct:(SKProduct*)product;
-(BOOL)productPurchased:(NSString*)productIdentifier;
-(void)restoreCompletedTransactions;

@end
