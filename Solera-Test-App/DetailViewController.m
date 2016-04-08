//
//  DetailViewController.m
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constants.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *productIV;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *qtyCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *productDescLbl;

@property (weak, nonatomic) IBOutlet UIButton *incrementBtn;
@property (weak, nonatomic) IBOutlet UIButton *decrementBtn;
@property (weak, nonatomic) IBOutlet UIButton *addToCartBtn;

@property (nonatomic) NSInteger localQtyInCart;


@end

@implementation DetailViewController

#pragma mark - Setters

- (void)setProductItem:(id)newProductItem
{
    //Lazy Instantiation
    if (_productItem != newProductItem) {
        _productItem = newProductItem;
        
    }
    
    // Update the view.
    [self updateView];
}

- (void)setLocalQtyInCart:(NSInteger)newQtyInCart
{
    //Quantity in Cart cannot be negative
    //So MAX will give us 0 if quantity is negative
    _localQtyInCart = MAX(0, newQtyInCart);
    
    //Update the Text Label immediately
    self.qtyCountLbl.text = [@(self.localQtyInCart) stringValue];
    
    [self updateAddToCartBtn];
}

//Update the View on Cell Selection on the MasterViewController
- (void)updateView
{
    if (self.productItem) {
        
        self.productIV.hidden = NO;
        self.productTitleLbl.hidden = NO;
        self.priceLbl.hidden = NO;
        self.qtyCountLbl.hidden = NO;
        
        self.incrementBtn.enabled = YES;
        self.incrementBtn.alpha = 1.0;
        self.decrementBtn.enabled = YES;
        self.decrementBtn.alpha = 1.0;
        self.addToCartBtn.enabled = YES;
        self.addToCartBtn.alpha = 1.0;
        
        NSDictionary *currencyDict = [[NSUserDefaults standardUserDefaults] objectForKey:K_USR_CURRENCY_RATES];
        NSString *selectedCurrency = [[NSUserDefaults standardUserDefaults] objectForKey:K_USR_SELECTED_CURRENCY];
        
        NSURL *imageURL = [NSURL URLWithString:self.productItem.imageURL];
        [self.productIV sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"green-leaf"]];
        
        float currencyRate = [currencyDict[selectedCurrency] floatValue];
        float priceValue = self.productItem.price *currencyRate;
        NSString *currencyString = ([selectedCurrency isEqualToString:@"USDUSD"]) ? @"USD" : [selectedCurrency stringByReplacingOccurrencesOfString:@"USD" withString:@""];
        
        self.priceLbl.text = [NSString stringWithFormat:@"%.02f %@", priceValue, currencyString];
        self.productTitleLbl.text = self.productItem.title;
        self.productDescLbl.text = self.productItem.desc;
        self.qtyCountLbl.text = [@(self.qtyInCart) stringValue];
        
        //If Cart already contains this Product
        //change the button title to "Update Cart"
        if (self.qtyInCart > 0) {
            [self.addToCartBtn setTitle:@"Update Cart" forState:UIControlStateNormal];
        }
        
        //Set the local Qty to Qty in Cart
        self.localQtyInCart = self.qtyInCart;
        
    } else {
        
        //If productItem is nil, Hide the details and disable the buttons
        self.productIV.hidden = YES;
        self.productTitleLbl.hidden = YES;
        self.priceLbl.hidden = YES;
        self.qtyCountLbl.hidden = YES;
        self.productDescLbl.hidden = YES;
        
        self.incrementBtn.enabled = NO;
        self.incrementBtn.alpha = 0.5;
        self.decrementBtn.enabled = NO;
        self.decrementBtn.alpha = 0.5;
        self.addToCartBtn.enabled = NO;
        self.addToCartBtn.alpha = 0.5;
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
        height = self.productIV.frame.size.height + self.productTitleLbl.frame.size.height +30;
    }
    else if (indexPath.section == 1) {
        [self.productDescLbl sizeToFit];
        
        height = self.productDescLbl.frame.size.height +40;
        
        
    }
    
    return height;
}


- (IBAction)incrementProductQtyInCart:(UIButton *)sender
{
    self.localQtyInCart++;
    
}

- (IBAction)decrementProductQtyInCart:(UIButton *)sender
{
    self.localQtyInCart--;
    
}


- (IBAction)addProductToCart:(UIButton *)sender
{
    self.qtyInCart = self.localQtyInCart;
    [self.masterViewController updateCartQuantity:self.qtyInCart forProductId:self.productItem.identfier];
    
    NSString *btnText = self.addToCartBtn.currentTitle;
    NSString *textToUpdate = btnText;
    
    if ([btnText isEqualToString:T_BTN_REMOVE_FROM_CART]) {
        textToUpdate = @"Successfully Removed";
    }
    if ([btnText isEqualToString:T_BTN_ADD_TO_CART] && (self.qtyInCart > 0)) {
        textToUpdate = @"Successfully Added";
    }
    if ([btnText isEqualToString:T_BTN_UPDATE_CART] && (self.qtyInCart > 0)) {
        textToUpdate = @"Successfully Updated";
    }
    
    [self.addToCartBtn setTitle:textToUpdate forState:UIControlStateNormal];
}

//Update Add To Cart button
- (void)updateAddToCartBtn
{
    NSString *btnText = self.addToCartBtn.currentTitle;
    NSString *textToUpdate = btnText;
    
    if (self.qtyInCart <= 0) {
        textToUpdate = T_BTN_ADD_TO_CART;
    }
    else if (self.qtyInCart > 0 && self.localQtyInCart <= 0) {
        textToUpdate = T_BTN_REMOVE_FROM_CART;
    }
    else if (self.qtyInCart > 0) {
        textToUpdate = T_BTN_UPDATE_CART;
    }
    else if (self.qtyInCart > 0 && self.qtyInCart != self.localQtyInCart) {
        textToUpdate = T_BTN_UPDATE_CART;
    }
    
    [self.addToCartBtn setTitle:textToUpdate forState:UIControlStateNormal];
}


@end
