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


- (NSMutableDictionary *)products
{
    //Lazy instantiation
    if (!_products) _products = [[NSMutableDictionary alloc] init];
    
    return _products;
}

- (void)updateQuantity:(NSInteger)qty forProductId: (NSString *)productId
{
    [self.products setObject:@(qty) forKey:productId];
}

- (NSInteger)getQuantityForProductId:(NSString *)productId
{
    return [self.products[productId] integerValue];
}

- (NSArray *)getProductIds
{
    return [self.products allKeys];
}

@end
