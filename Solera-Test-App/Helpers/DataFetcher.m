//
//  DataFetcher.m
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//
//  *******
//
//  This Class must normally fetch Product List from a server
//  But as our current product list is Static, we will just return the Hard-Coded Array of Dictionaries
//
//  *******


#import "DataFetcher.h"

@implementation DataFetcher

//In real-life scenario this method will implement async data fetching
- (NSArray *)fetchProducts
{
    NSArray *productsArray = @[
                               @{
                                   @"title" : @"Peas",
                                   @"image" : @"",
                                   @"stock" : @7,
                                   @"price" : @0.95,
                                },
                               @{
                                   @"title" : @"Eggs",
                                   @"image" : @"",
                                   @"stock" : @8,
                                   @"price" : @2.10,
                                },
                               @{
                                   @"title" : @"Milk",
                                   @"image" : @"",
                                   @"stock" : @5,
                                   @"price" : @1.30,
                                },
                               @{
                                   @"title" : @"Beans",
                                   @"image" : @"",
                                   @"stock" : @8,
                                   @"price" : @0.73,
                                }
                               ];
    
    
    return productsArray;
}

- (NSArray *)getProductList
{
    return [self fetchProducts];
}


@end
