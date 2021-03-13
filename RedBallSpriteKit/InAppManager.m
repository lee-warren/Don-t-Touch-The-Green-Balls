//
//  InAppManager.m
//  Don't Touch The Green Balls
//
//  Created by Lee Warren on 25/08/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import "InAppManager.h"

@interface InAppManager () {
    
    NSMutableArray* purchasableProducts; //an array of possible products to purchasing
    NSUserDefaults* defaults; // store a bool variable marking the products that have been unlocked
    
    bool product1WasPurchased;
    
    InAppObserver* theObserver;
    
}

@end

@implementation InAppManager

static NSString* productID1 = @"RemoveAds";
// would follow same pattern for multiple in app purchases eg.(static NSString* productID2 = @"MoreLives";)


static InAppManager* sharedManager = nil;

+(InAppManager*) sharedManager {
    
    if (sharedManager == nil) {
        
        sharedManager = [[InAppManager alloc]init];
    }

    return sharedManager;
    
}

-(id) init {
    
    if (self = [super init]) {
        
        //do initilisation
        
        sharedManager = self;
        defaults = [NSUserDefaults standardUserDefaults];
        product1WasPurchased = [defaults boolForKey:productID1];
        
        purchasableProducts = [[NSMutableArray alloc] init];
        [self requestProductData]; //as soon as we initilise the class, we want to get product info from the store
        
        theObserver = [[InAppObserver alloc]init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:theObserver];
    }
    
    return self;
    
}

-(void) requestProductData {
    
    SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:productID1, nil]]; //add more products in the NSSet if you need them
    
    request.delegate = self;
    [request start];
    
}


-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    //add more here later
    
    NSArray* skProducts = response.products;
    //NSLog(@"This is a vague responce but you should get one... %@", skProducts);
    
    if ([skProducts count] != 0 && [purchasableProducts count] == 0) {
       
        for (int i = 0; i < [skProducts count]; i++ ) {
            
            [purchasableProducts addObject:[skProducts objectAtIndex:i]];
            SKProduct* product = [purchasableProducts objectAtIndex:i];
            
            NSLog(@"Feature:%@, Cost:%f, ID: %@", [product localizedTitle], [[product price]doubleValue], [product productIdentifier] );
        }
        
    }
    NSLog(@"We found %i In-App Purchases in iTunes Connect", (int)[purchasableProducts count]);
}

-(void) failedTransaction:(SKPaymentTransaction*) transaction {
    
    NSString* failMessage = [NSString stringWithFormat:@"Reason: %@ You could try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion] ];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unable to complete purchase" message:failMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
}

-(void) provideContent:(NSString*)productIdentifier {
    
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter]; // used below to post notifications
    NSString* theMessageForAlert;
    
    if ([productIdentifier isEqualToString:productID1]) {
        
        //product 1 was purchased
        theMessageForAlert = @"Your app now has no ads. Yay!";
        product1WasPurchased = YES;
        [defaults setBool:YES forKey:productID1];
        [notification postNotificationName:@"feature1Purchased" object:nil];
        NSLog(@"Item 1 was purchased");
        
    }//add other products here as else statement

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Thank you" message:theMessageForAlert delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];

}


-(void) buyFeature1 {
    
    [self buyFeature:productID1];
}

-(void) buyFeature:(NSString*) featureID {
    
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"Can make payments");
        SKProduct* selectedProduct;
        
        for (int i = 0; i < [purchasableProducts count]; i++) {
            selectedProduct = [purchasableProducts objectAtIndex:i];
            
            if ([[selectedProduct productIdentifier] isEqualToString: featureID ]) {
                
                //if we found a SKProduct in the purchasableProducts array with the same ID as the one we want to buy, we proceed by putting it in the payment queue.
                
                SKPayment* payment = [SKPayment paymentWithProduct:selectedProduct];
                [[SKPaymentQueue defaultQueue] addPayment:payment];
                break;
            }
        }
        
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Ohh No!" message:@"You can't purchase from the app store" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(bool) isFeature1PurchasedAlready {
    
    return product1WasPurchased;
}

-(void) restoreCompletedTransactions {
    
    [[SKPaymentQueue defaultQueue]  restoreCompletedTransactions];
    
}


@end
