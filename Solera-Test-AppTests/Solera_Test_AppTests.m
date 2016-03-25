//
//  Solera_Test_AppTests.m
//  Solera-Test-AppTests
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ShoppingCart.h"
#import "ProductItem.h"
#import "DataFetcher.h"

@interface Solera_Test_AppTests : XCTestCase

@property (nonatomic) ShoppingCart *cart;
@property (nonatomic) ProductItem *product;
@property (nonatomic) NSDictionary *productsList;

@end

@implementation Solera_Test_AppTests

- (void)setUp
{
    [super setUp];
    
    self.cart = [[ShoppingCart alloc] init];
    [self.cart updateQuantity:2 forProductId:@"1"];
    [self.cart updateQuantity:3 forProductId:@"1"];
    [self.cart updateQuantity:2 forProductId:@"2"];
    [self.cart updateQuantity:5 forProductId:@"3"];
    
    DataFetcher *fetcher = [[DataFetcher alloc] init];
    self.productsList = [fetcher getProductList];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDataFetcher
{
    ProductItem *product = self.productsList[@"1"];
    NSString *productTitle = product.title;
    NSString *expectedTitle = @"Peas";
    
    XCTAssertEqualObjects(expectedTitle, productTitle, @"Product Title did not match expected title");
}

- (void)testShoppingCart
{
    NSInteger productsInCart = [[self.cart getProductIds] count];
    NSInteger expectedProductsInCart = 3;
    
    XCTAssertEqual(expectedProductsInCart, productsInCart, @"Products in cart did not match with expected products in cart");
    
}

- (void)testGetItemQuantityFromShoppingCart
{
    NSInteger quantity = [self.cart getQuantityForProductId:@"3"];
    NSInteger expectedQuantity = 5;
    
    XCTAssertEqual(expectedQuantity, quantity, @"Quantity did not match expected quantity");
    
}

- (void)testGetItemQuantityFromShoppingCart2
{
    NSInteger quantity = [self.cart getQuantityForProductId:@"1"];
    NSInteger expectedQuantity = 3;
    
    XCTAssertEqual(expectedQuantity, quantity, @"Quantity did not match expected quantity");
    
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
