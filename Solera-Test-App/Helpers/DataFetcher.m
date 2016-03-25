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

//String constsnts for retriving data from the fetched Products List
NSString *const P_ID        = @"id";
NSString *const P_TITLE     = @"title";
NSString *const P_IMAGE_URL = @"image";
NSString *const P_STOCK     = @"stock";
NSString *const P_PRICE     = @"price";
NSString *const P_DESC      = @"desc";


@implementation DataFetcher

//Async fetch for the Currency Rates
//This method is triggered at every App Launch
- (void)fetchCurrencyRates
{
    if (![self internetAvailable:K_URL_REACHABILITY])
    {
        //If Internet is not available post notification and cancle the fetch
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
                 //Store the Data in UserDefaults
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:responseObject[@"quotes"] forKey:K_USR_CURRENCY_RATES];
                 
                 //Check if the user had set the currency in the Previous Session
                 //If not set it to USDUSD
                 NSString *selectedCurrency = ([defaults objectForKey:K_USR_SELECTED_CURRENCY]) ? [defaults objectForKey:K_USR_SELECTED_CURRENCY] : @"USDUSD";
                 [defaults setObject:selectedCurrency forKey:K_USR_SELECTED_CURRENCY];
                 
                 [defaults synchronize];
                 
                 //Post the Notification for Currency Fetch Completion
                 [self dataFetchComplete];
             }
             failure:^(NSURLSessionTask *task, NSError *error){
                 
                 NDLog(@"Error : %@", error);
                 
                 //If the server returned any error, Post notification about it and cancel the fetch
                 [self alertSyncError];
             }];
    }
    
    
}

//In real-life scenario this method will implement async data fetching
- (NSArray *)fetchProducts
{
    //While creating the below Array of Dictionaries, we could had used the String Constants
    //But to simulate real-life scenario we are hard-coding the Keys
    //If the data would be fetched from the Server, it would be in similar state.
    NSArray *productsArray = @[
                               @{
                                   @"id"    : @"1",
                                   @"title" : @"Peas",
                                   @"image" : @"https://dl.dropboxusercontent.com/s/ucjq4wtbh5hoasz/peas.jpg",
                                   @"stock" : @7,
                                   @"price" : @0.95,
                                   @"desc"  : @"Fresh frozen Green Peas"
                                },
                               @{
                                   @"id"    : @"2",
                                   @"title" : @"Eggs",
                                   @"image" : @"https://dl.dropboxusercontent.com/s/jh6z3052nxbt3zy/eggs.jpg",
                                   @"stock" : @8,
                                   @"price" : @2.10,
                                   @"desc"  : @"Fresh Eggs from farm fed Chicken"
                                },
                               @{
                                   @"id"    : @"3",
                                   @"title" : @"Milk",
                                   @"image" : @"https://dl.dropboxusercontent.com/s/upuzbrx9twf9h2a/milk.jpg",
                                   @"stock" : @5,
                                   @"price" : @1.30,
                                   @"desc"  : @"Fresh Milk from Grass Fed Cows"
                                },
                               @{
                                   @"id"    : @"4",
                                   @"title" : @"Beans",
                                   @"image" : @"https://dl.dropboxusercontent.com/s/r9qum7zwv1ccq40/beans.jpg",
                                   @"stock" : @8,
                                   @"price" : @0.73,
                                   @"desc"  : @"100% Organic White Beans"
                                }
                               ];
    
//    Beans - https://dl.dropboxusercontent.com/s/r9qum7zwv1ccq40/beans.jpg?raw=1
//    Eggs - https://dl.dropboxusercontent.com/s/jh6z3052nxbt3zy/eggs.jpg?raw=1
//    Milk - https://dl.dropboxusercontent.com/s/upuzbrx9twf9h2a/milk.jpg?raw=1
//    Peas - https://dl.dropboxusercontent.com/s/ucjq4wtbh5hoasz/peas.jpg?raw=1
    
    return productsArray;
}

//This is the main trigger method which will call the above fetcher
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
