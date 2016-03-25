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

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, strong) NSString *selectedCurrency;

- (void)addProductToCart:(ProductItem *)product;
//-(void)changeSelectedCurrency:(NSString *)currenyId;

@end

