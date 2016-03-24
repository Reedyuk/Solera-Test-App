//
//  Cart.m
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import "ShoppingCart.h"

@interface ShoppingCart()

@property (nonatomic, strong) NSMutableArray *products;

@end

@implementation ShoppingCart


- (NSMutableArray *)products
{
    if (!_products) _products = [[NSMutableArray alloc] init];
    return _products;
}

- (void)addProduct: (ProductItem *)product
{
    [self.products addObject:product];
}

- (ProductItem *)getProductAtIndex:(NSInteger)index
{
    return self.products[index];
}

@end
