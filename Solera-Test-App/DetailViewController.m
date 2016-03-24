//
//  DetailViewController.m
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *productIV;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *qtyCountLbl;
@property (weak, nonatomic) IBOutlet UITextView *productDescriptionTV;

@property (nonatomic) NSUInteger qtyInCart; //Quantity cannot be Negative


@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setProductItem:(id)newProductItem {
    if (_productItem != newProductItem) {
        _productItem = newProductItem;
            
        // Update the view.
        [self updateView];
    }
}

- (void)setQtyInCart:(NSUInteger)qtyInCart
{
    _qtyInCart = qtyInCart;
    
    self.qtyCountLbl.text = [@(qtyInCart) stringValue];
}

- (void)updateView
{
    if (self.productItem) {
        
        [self.productIV sd_setImageWithURL:[NSURL URLWithString:@""]];
        self.productTitleLbl.text = self.productItem.title;
        self.productDescriptionTV.text = self.productItem.description;
        self.qtyCountLbl.text = @"0"; // Get from Cart
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    if (indexPath.section == 0) {
        height = self.productIV.frame.size.height +30;
    }
    else if (indexPath.section == 1) {
        [self.productDescriptionTV sizeToFit];
        [self.productDescriptionTV.textContainer setSize:self.productDescriptionTV.frame.size];
        
        height = self.productDescriptionTV.frame.size.height +40;
        
        
    }
    
    return height;
}


- (IBAction)incrementProductQtyInCart:(UIButton *)sender
{
    self.qtyInCart++;
    
}

- (IBAction)decrementProductQtyInCart:(UIButton *)sender
{
    self.qtyInCart--;
    
}


- (IBAction)addProductToCart:(UIButton *)sender
{
    
    
}


@end
