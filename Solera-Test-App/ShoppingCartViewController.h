//
//  ShoppingCartViewController.h
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/25/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCart.h"

@interface ShoppingCartViewController : UITableViewController

@property (nonatomic, strong) ShoppingCart *cart;
@property (nonatomic, strong) NSDictionary *productsList;
@property (nonatomic) float currencyRate;
@property (nonatomic, strong) NSString *currencyString;

@end
