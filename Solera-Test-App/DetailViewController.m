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

- (void)setQtyInCart:(NSInteger)newQtyInCart
{
    //Quantity in Cart cannot be negative
    //So MAX will give us 0 if quantity is negative
    _qtyInCart = MAX(0, newQtyInCart);
    
    //Update the Text Label immediately
    self.qtyCountLbl.text = [@(self.qtyInCart) stringValue];
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
        
        float currencyRate = [currencyDict[selectedCurrency] floatValue];
        float priceValue = self.productItem.price *currencyRate;
        NSString *currencyString = ([selectedCurrency isEqualToString:@"USDUSD"]) ? @"USD" : [selectedCurrency stringByReplacingOccurrencesOfString:@"USD" withString:@""];
        
        self.priceLbl.text = [NSString stringWithFormat:@"%.02f %@", priceValue, currencyString];
        [self.productIV sd_setImageWithURL:[NSURL URLWithString:@""]];
        self.productTitleLbl.text = self.productItem.title;
        self.productDescLbl.text = self.productItem.desc;
        self.qtyCountLbl.text = [@(self.qtyInCart) stringValue]; // Get from Cart
        
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
    self.qtyInCart++;
    
}

- (IBAction)decrementProductQtyInCart:(UIButton *)sender
{
    self.qtyInCart--;
    
}


- (IBAction)addProductToCart:(UIButton *)sender
{
    [self.masterViewController updateCartQuantity:self.qtyInCart forProductId:self.productItem.identfier];
    
}


@end
