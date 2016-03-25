//
//  Constants.h
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//NDLog Macro
#ifndef NDLog
    #ifdef DEBUG
        #define NDLog(_format_, ...) NSLog(_format_, ## __VA_ARGS__)
    #else
        #define NDLog(_format_, ...)
    #endif
#endif


//Rechability Test URLs
extern NSString *const K_URL_REACHABILITY;

//JSON Feed for Currency Rates
extern NSString *const K_URL_CURRENCY;

//NSUserdefaults Dictionary for Currency Rates
extern NSString *const K_USR_CURRENCY_RATES;
extern NSString *const K_USR_SELECTED_CURRENCY;

//Notifications
extern NSString *const K_NOTIF_DATA_FETCH_COMPLETE;
extern NSString *const K_NOTIF_NETWORK_ERROR;
extern NSString *const K_NOTIF_SYNC_ERROR;

//Alerts
extern NSString *const K_ALERT_NETWORK_ERROR_TEXT;
extern NSString *const K_ALERT_NETWORK_ERROR_TITLE;
extern NSString *const K_ALERT_SYNC_EROR_TEXT;
extern NSString *const K_ALERT_SYNC_ERROR_TITLE;

@end
