//
//  ShoppingCartViewController.m
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/25/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ProductItem.h"

@interface ShoppingCartViewController ()

@property (nonatomic, strong) NSArray *productsInCart;

@end

@implementation ShoppingCartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Get the Ids of all the Products in the Cart
    self.productsInCart = [self.cart getProductIds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productsInCart count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartCell" forIndexPath:indexPath];
    
    ProductItem *product = self.productsList[self.productsInCart[indexPath.row]];
    
    cell.textLabel.text = product.title;
    
    NSInteger totaQty = [self.cart getQuantityForProductId:product.identfier];
    float totalPrice = product.price *totaQty *self.currencyRate;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Qty : %d   Price : %.02f %@", (int)totaQty, totalPrice, self.currencyString];
    
    return cell;
}


@end
