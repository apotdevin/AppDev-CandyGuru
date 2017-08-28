//
//  IAPHelper.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 8/29/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "IAPHelper.h"
#import "VerificationController.h"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface IAPHelper () <SKProductsRequestDelegate,SKPaymentTransactionObserver>

@end

@implementation IAPHelper
{
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            
            if ([productIdentifier isEqualToString:@"anthonypotdevin.crystalblue.removebanners"]) {
                BOOL valid = NO;
                BOOL productPurchased = [[NSUserDefaults standardUserDefaults] secureBoolForKey:productIdentifier valid:&valid];
                if (!valid)
                {
                    [[NSUserDefaults standardUserDefaults] setSecureBool:NO forKey:productIdentifier];
                    NSLog(@"INVALID removeAds!");
                }
                if (productPurchased) {
                    [_purchasedProductIdentifiers addObject:productIdentifier];
                    NSLog(@"Previously purchased: %@", productIdentifier);
                } else {
                    NSLog(@"Not purchased: %@", productIdentifier);
                }
            }
        }
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self validateReceiptForTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self validateReceiptForTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier
{
    if ([productIdentifier isEqualToString:@"anthonypotdevin.crystalblue.1000cash"]) {
        [[GameSaveState sharedGameData] changeMoney:3000];
    }
    else if ([productIdentifier isEqualToString:@"anthonypotdevin.crystalblue.10000cash"]) {
        [[GameSaveState sharedGameData] changeMoney:10000];
    }
    else if ([productIdentifier isEqualToString:@"anthonypotdevin.crystalblue.100000cash"]) {
        [[GameSaveState sharedGameData] changeMoney:100000];
    }
    else if ([productIdentifier isEqualToString:@"anthonypotdevin.crystalblue.1000000cash"]) {
        [[GameSaveState sharedGameData] changeMoney:1000000];
    }
    else if ([productIdentifier isEqualToString:@"anthonypotdevin.crystalblue.5tickets"]) {
        [GameSaveState sharedGameData].tickets+=5;
    }
    else if ([productIdentifier isEqualToString:@"anthonypotdevin.crystalblue.20tickets"]) {
        [GameSaveState sharedGameData].tickets+=20;
    }
    else if ([productIdentifier isEqualToString:@"anthonypotdevin.crystalblue.40tickets"]) {
        [GameSaveState sharedGameData].tickets+=40;
    }
    else
    {
        [_purchasedProductIdentifiers addObject:productIdentifier];
        [[NSUserDefaults standardUserDefaults] setSecureBool:YES forKey:productIdentifier];
    }
    
    [[GameSaveState sharedGameData] saveGame];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)validateReceiptForTransaction:(SKPaymentTransaction *)transaction {
    VerificationController * verifier = [VerificationController sharedInstance];
    [verifier verifyPurchase:transaction completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Successfully verified receipt!");
            [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
        } else {
            NSLog(@"Failed to validate receipt.");
            [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        }
    }];
}

@end