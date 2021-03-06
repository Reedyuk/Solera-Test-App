//
//  DetailViewController.h
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductItem.h"
#import "MasterViewController.h"
#import "ShoppingCart.h"

@interface DetailViewController : UITableViewController

@property (nonatomic, strong) ProductItem *productItem;
@property (nonatomic, strong) MasterViewController *masterViewController;
@property (nonatomic) NSInteger qtyInCart;

@end

