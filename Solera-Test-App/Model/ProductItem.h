//
//  Product.h
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Product : NSObject

@property (nonatomic, strong) NSString *productTitle;
@property (nonatomic, strong) UIImage *productImage;
@property (nonatomic) NSInteger availableQty;


@end
