//
//  InAppObserver.h
//  Don't Touch The Green Balls
//
//  Created by Lee Warren on 25/08/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


@interface InAppObserver : NSObject <SKPaymentTransactionObserver> {
    
  
    
    
}

-(void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;

@end
