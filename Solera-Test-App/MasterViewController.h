//
//  MasterViewController.h
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductItem.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController
<
UIPopoverPresentationControllerDelegate,
UIAlertViewDelegate
>

//Get the handle from DetailViewController so that we can update the Currency Button Label
@property (strong, nonatomic) DetailViewController *detailViewController;

@property (nonatomic, strong) NSString *selectedCurrency;

//Update the Quantity of Products in the cart
- (void)updateCartQuantity:(NSInteger)qty forProductId:(NSString *)productId;

@end

