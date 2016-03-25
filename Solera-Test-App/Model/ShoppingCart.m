//
//  Cart.m
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import "ShoppingCart.h"

@interface ShoppingCart()

@property (nonatomic, strong) NSMutableDictionary *products;

@end

@implementation ShoppingCart


//Override Getter
- (NSMutableDictionary *)products
{
    //Lazy instantiation
    if (!_products) _products = [[NSMutableDictionary alloc] init];
    
    return _products;
}


//Update the Product Quantity in the Cart
- (void)updateQuantity:(NSInteger)qty forProductId: (NSString *)productId
{
    if (qty <= 0) {
        
        [self.products removeObjectForKey:productId];
    } else{
        
    [self.products setObject:@(qty) forKey:productId];
    }
}

//Get the Quantity of Product from the Cart
- (NSInteger)getQuantityForProductId:(NSString *)productId
{
    return [self.products[productId] integerValue];
}

//Get the Array of Product Ids from the Cart
- (NSArray *)getProductIds
{
    return [self.products allKeys];
}

@end
