//
//  InAppObserver.m
//  Don't Touch The Green Balls
//
//  Created by Lee Warren on 25/08/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import "InAppObserver.h"
#import "InAppManager.h" //can not be in the header file - for some reason

@implementation InAppObserver


-(void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    for(SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
    
}


-(void) failedTransaction: (SKPaymentTransaction*) transaction {
    NSLog(@"Transaction failed");
    
     //if the error was anything other than the user cancelling it
    if (transaction.error.code != SKErrorPaymentCancelled) {
        
        [[InAppManager sharedManager] failedTransaction:transaction];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}


-(void) completeTransaction: (SKPaymentTransaction*) transaction {
    NSLog(@"Transaction completed");
    
    //when we pass the transaction back to the sharedManager it has the product ID
   [[InAppManager sharedManager] provideContent:transaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

-(void) restoreTransaction: (SKPaymentTransaction*) transaction {
    NSLog(@"Transaction restored");
    
    [[InAppManager sharedManager] provideContent:transaction.originalTransaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}


@end
