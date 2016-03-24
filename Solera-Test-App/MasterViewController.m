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


@interface MasterViewController ()

@property (nonatomic, strong) NSArray *productsList;
@property (nonatomic, strong) ShoppingCart *cart;
@property (nonatomic, strong) UIActivityIndicatorView *dbLoadIndicator;


@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    //Get the handle of the DetailsViewController
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //Acttivity Indicator
    self.dbLoadIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    self.dbLoadIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.dbLoadIndicator.hidden = YES;
    self.dbLoadIndicator.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5f];
    self.dbLoadIndicator.hidden = YES;
    [self.navigationController.view addSubview:self.dbLoadIndicator];
    
    //Register Notification for catching the status of the Async Processes
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
    
    [self startActivityIndicator];
    
    DataFetcher *fetcher = [[DataFetcher alloc] init];
    self.productsList = fetcher.getProductList;
    [fetcher fetchCurrencyRates];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (void)insertNewObject:(id)sender {
//    if (!self.objects) {
//        self.objects = [[NSMutableArray alloc] init];
//    }
//    [self.objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

- (void)addProductToCart:(ProductItem *)product
{
    [self.cart addProduct:product];
}

- (void)reloadTableView
{
    [self.tableView reloadData];
    
    [self stopActivityIndicator];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showCurrencySelector"]) {
        
        UINavigationController *cNVC = segue.destinationViewController;
        
//        CurrencyTableViewController *cTBVC = cNVC.viewControllers.firstObject;
        
        UIPopoverPresentationController *pPC = cNVC.popoverPresentationController;
        pPC.sourceRect = [(UIView *)sender bounds];
        pPC.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        ProductItem *product = self.productsList[indexPath.row];
        
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
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
    return self.productsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    ProductItem *product = (ProductItem *)self.productsList[indexPath.row];
    
    cell.textLabel.text = product.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %@", product.price];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

#pragma mark - Activity Indicator Methods
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
