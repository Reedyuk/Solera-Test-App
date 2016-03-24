//
//  DetailViewController.m
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *productIV;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *qtyCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *increaseQtyBtn;
@property (weak, nonatomic) IBOutlet UIButton *decreaseQtyBtn;
@property (weak, nonatomic) IBOutlet UIButton *addToCartBtn;
@property (weak, nonatomic) IBOutlet UITextView *productDescriptionTV;


@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
//        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
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

@end
