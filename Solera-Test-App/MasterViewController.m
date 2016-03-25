//
//  MasterViewController.m
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "DataFetcher.h"
#import "ShoppingCart.h"
#import "CurrencyTableViewController.h"
#import "Constants.h"
#import "ShoppingCartViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MasterViewController ()

@property (nonatomic, strong) NSDictionary *productsList;
@property (nonatomic, strong) NSArray *productIdArray;
@property (nonatomic, strong) ShoppingCart *cart;
@property (nonatomic, strong) UIActivityIndicatorView *dbLoadIndicator;
@property (nonatomic, strong) NSDictionary *currencyDict;
@property (nonatomic, strong) NSString *currencyString;

//Currency Button
@property (weak, nonatomic) IBOutlet UIButton *currencyButton;


@end

@implementation MasterViewController

#pragma mark - Getters / Setters

//Overriding Getter
- (ShoppingCart *)cart
{
    if (!_cart) _cart = [[ShoppingCart alloc] init];
    
    return _cart;
}

//Overriding setter for self.selectedCurrency
-(void)setSelectedCurrency:(NSString *)selectedCurrency
{
    _selectedCurrency = selectedCurrency;
    
    //Curency Conversion Identifier is in format USDXXX
    //So we will remove the preceeding USD
    
    //Tried to get Currency Symbols from NSLocale, but not all the symbols are available.
    //So using the Currency Code directly
//    NSString *curCode = ([selectedCurrency isEqualToString:@"USDUSD"]) ? @"USD" : [selectedCurrency stringByReplacingOccurrencesOfString:@"USD" withString:@""];
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:curCode];
//    self.currencyString = [NSString stringWithFormat:@"%@", [locale displayNameForKey:NSLocaleCurrencySymbol value:curCode]];
    
    self.currencyString = ([selectedCurrency isEqualToString:@"USDUSD"]) ? @"USD" : [selectedCurrency stringByReplacingOccurrencesOfString:@"USD" withString:@""];
    
    [self.currencyButton setTitle:self.currencyString forState:UIControlStateNormal];
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Get the handle of the DetailsViewController
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //Acttivity Indicator
    self.dbLoadIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    self.dbLoadIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.dbLoadIndicator.hidden = YES;
    self.dbLoadIndicator.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5f];
    self.dbLoadIndicator.hidden = YES;
    [self.navigationController.view addSubview:self.dbLoadIndicator];
    
    //Register Notification for observing the status of the Async Operations
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView)
                                                 name:K_NOTIF_DATA_FETCH_COMPLETE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkError)
                                                 name:K_NOTIF_NETWORK_ERROR
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(syncError)
                                                 name:K_NOTIF_SYNC_ERROR
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;

    [super viewWillAppear:animated];
    
    
    //Start Fetching the Data
    [self startActivityIndicator];
    
    DataFetcher *fetcher = [[DataFetcher alloc] init];
    self.productsList = fetcher.getProductList;
    self.productIdArray = [self.productsList allKeys];
    
    //Fetch the currency Rates
    [fetcher fetchCurrencyRates];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action Methods

//Update the quantity of Products in the Cart
- (void)updateCartQuantity:(NSInteger)qty forProductId:(NSString *)productId
{
    [self.cart updateQuantity:qty forProductId:productId];
}

//Reload the TableView when Data is changed
- (void)reloadTableView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.currencyDict = [defaults objectForKey:K_USR_CURRENCY_RATES];
    self.selectedCurrency = [defaults stringForKey:K_USR_SELECTED_CURRENCY];
    
    self.detailViewController.productItem = nil;
    
    [self.tableView reloadData];
    
    [self stopActivityIndicator];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showCart"]) {
        
        UINavigationController *nVC = segue.destinationViewController;
        ShoppingCartViewController *sVC = nVC.viewControllers.firstObject;
        sVC.cart = self.cart;
        sVC.productsList = self.productsList;
        sVC.currencyRate = [self.currencyDict[self.selectedCurrency] floatValue];
        sVC.currencyString = self.currencyString;
        
        UIPopoverPresentationController *pPC = nVC.popoverPresentationController;
        pPC.sourceRect = [(UIView *)sender bounds];
        pPC.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"showCurrencySelector"]) {
        
        UINavigationController *nVC = segue.destinationViewController;
        CurrencyTableViewController *cTBVC = nVC.viewControllers.firstObject;
        cTBVC.masterVC = self;
        
        UIPopoverPresentationController *pPC = nVC.popoverPresentationController;
        pPC.sourceRect = [(UIView *)sender bounds];
        pPC.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        ProductItem *product = self.productsList[self.productIdArray[indexPath.row]];
        
        NSInteger qtyInCart = [self.cart getQuantityForProductId:product.identfier];
        
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        self.detailViewController = controller;
        
        controller.qtyInCart = qtyInCart;
        controller.masterViewController = self;
        [controller setProductItem:product];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productIdArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    ProductItem *product = (ProductItem *)self.productsList[self.productIdArray[indexPath.row]];
    
    cell.textLabel.text = product.title;
    
    float currencyRate = [self.currencyDict[self.selectedCurrency] floatValue];
    float productPrice = product.price *currencyRate;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f %@", productPrice, self.currencyString];
    
    NSURL *imageURL = [NSURL URLWithString:product.imageURL];
    [cell.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"green-leaf"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark - Popover Delegates

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    //Reload the TableView when Currency Changed
    [self reloadTableView];
}



#pragma mark - Activity Indicator Methods
//Activity Indicator while Async Fetching

- (void)startActivityIndicator
{
    self.view.userInteractionEnabled = NO;
    
    CGSize viewFrame = self.tableView.frame.size;
    
    self.dbLoadIndicator.layer.position = CGPointMake((viewFrame.width /2), (viewFrame.height /2));
    [self.dbLoadIndicator startAnimating];
    self.dbLoadIndicator.hidden = NO;
}

- (void)stopActivityIndicator
{
    self.dbLoadIndicator.hidden = YES;
    [self.dbLoadIndicator stopAnimating];
    
    self.view.userInteractionEnabled = YES;
}


#pragma mark - AlertView
//Shows Alerts during Async Operations

- (void)networkError
{
    [self stopActivityIndicator];
    
    [self showAlert:K_ALERT_NETWORK_ERROR_TEXT withTitle:K_ALERT_NETWORK_ERROR_TITLE];
}

- (void)syncError
{
    [self stopActivityIndicator];
    
    [self showAlert:K_ALERT_SYNC_EROR_TEXT withTitle:K_ALERT_SYNC_ERROR_TITLE];
}


- (void)showAlert:(NSString *)alertText withTitle:(NSString *)alertTitle
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:alertTitle
                                                   message:alertText
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
}

@end
