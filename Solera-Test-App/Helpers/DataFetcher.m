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
#import "ProductItem.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "Constants.h"

NSString *const P_ID        = @"id";
NSString *const P_TITLE     = @"title";
NSString *const P_IMAGE_URL = @"image";
NSString *const P_STOCK     = @"stock";
NSString *const P_PRICE     = @"price";
NSString *const P_DESC      = @"desc";


@implementation DataFetcher

- (void)fetchCurrencyRates
{
    if (![self internetAvailable:K_URL_REACHABILITY])
    {
        [self alertNetworkError];
    }
    else
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:K_URL_CURRENCY
          parameters:nil
            progress:nil
             success:^(NSURLSessionTask *task, id responseObject){
             
//                 NDLog(@"JSON : %@", responseObject);
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:responseObject[@"quotes"] forKey:K_USR_CURRENCY_RATES];
                 [defaults setObject:@"USDUSD" forKey:K_USR_SELECTED_CURRENCY];
                 [defaults synchronize];
                 
                 [self dataFetchComplete];
             }
             failure:^(NSURLSessionTask *task, NSError *error){
                 
                 NDLog(@"Error : %@", error);
                 
                 [self alertSyncError];
             }];
    }
    
    
}

//In real-life scenario this method will implement async data fetching
- (NSArray *)fetchProducts
{
    NSArray *productsArray = @[
                               @{
                                   @"id"    : @"1",
                                   @"title" : @"Peas",
                                   @"image" : @"",
                                   @"stock" : @7,
                                   @"price" : @0.95,
                                   @"desc"  : @"Fresh frozen Green Peas"
                                },
                               @{
                                   @"id"    : @"2",
                                   @"title" : @"Eggs",
                                   @"image" : @"",
                                   @"stock" : @8,
                                   @"price" : @2.10,
                                   @"desc"  : @"Fresh Eggs from farm fed Chicken"
                                },
                               @{
                                   @"id"    : @"3",
                                   @"title" : @"Milk",
                                   @"image" : @"",
                                   @"stock" : @5,
                                   @"price" : @1.30,
                                   @"desc"  : @"Fresh Milk from Grass Fed Cows"
                                },
                               @{
                                   @"id"    : @"4",
                                   @"title" : @"Beans",
                                   @"image" : @"",
                                   @"stock" : @8,
                                   @"price" : @0.73,
                                   @"desc"  : @"100% Organic White Beans"
                                }
                               ];
    
    
    return productsArray;
}

- (NSDictionary *)getProductList
{
    NSMutableDictionary *productsList = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    NSArray *products = [self fetchProducts];
    
    for (NSDictionary *product in products)
    {
        ProductItem *productItem    = [[ProductItem alloc] init];
        productItem.identfier       = product[P_ID];
        productItem.title           = product[P_TITLE];
        productItem.imageURL        = product[P_IMAGE_URL];
        productItem.availableQty    = [product[P_STOCK] integerValue];
        productItem.price           = [product[P_PRICE] floatValue];
        productItem.desc            = product[P_DESC];
        
        [productsList setObject:productItem forKey:productItem.identfier];
        
    }
    
    return productsList;
}

//Methods to Post notifications for the Status of the Async Processes
- (void)dataFetchComplete
{
    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIF_DATA_FETCH_COMPLETE object:nil];
}

- (void)alertNetworkError
{
    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIF_NETWORK_ERROR object:nil];
    
}

- (void)alertSyncError
{
    [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIF_SYNC_ERROR object:nil];
    
}

#pragma mark - Reachability Checker

-(BOOL)internetAvailable:(NSString *)domainName
{
    Reachability *r = [Reachability reachabilityWithHostName:domainName];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable)
    {
        return NO;
    }
    return YES;
}


@end
