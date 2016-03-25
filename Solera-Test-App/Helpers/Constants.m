//
//  Constants.m
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import "Constants.h"

@implementation Constants

//Rechability Test URLs
NSString *const K_URL_REACHABILITY = @"http://apple.com";

//JSON Feed for Currency Rates
NSString *const K_URL_CURRENCY = @"http://www.apilayer.net/api/live?access_key=eee1d0ae94e45196be9c68b1e455001e";

//NSUserdefaults Dictionary for Currency Rates
NSString *const K_USR_CURRENCY_RATES = @"CurrencyRatesDictionary";
NSString *const K_USR_SELECTED_CURRENCY = @"SelectedCurrency";

NSString *const K_NOTIF_DATA_FETCH_COMPLETE = @"DataFetchComplete";
NSString *const K_NOTIF_NETWORK_ERROR = @"NetworkError";
NSString *const K_NOTIF_SYNC_ERROR = @"SyncError";

//Alerts
NSString *const K_ALERT_NETWORK_ERROR_TEXT = @"Active Internet connection was not found!\nPlease try again later.";
NSString *const K_ALERT_NETWORK_ERROR_TITLE = @"Network Error";
NSString *const K_ALERT_SYNC_EROR_TEXT = @"Some error occured while syncing the data!\nPlease try again later";
NSString *const K_ALERT_SYNC_ERROR_TITLE = @"Sync Error";

@end
