//
//  Cart.h
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductItem.h"

@interface ShoppingCart : NSObject

- (void)addProduct: (ProductItem *)product;

@end
