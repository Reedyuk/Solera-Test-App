//
//  CurrencyTableViewController.m
//  Solera-Test-App
//
//  Created by Sumit Anantwar on 3/24/16.
//  Copyright © 2016 Sumit Anantwar. All rights reserved.
//

#import "CurrencyTableViewController.h"
#import "Constants.h"

@interface CurrencyTableViewController ()

@property (nonatomic, strong) NSArray *currencyArray;


@end

@implementation CurrencyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Get the Currency Array from UserDefaults
    self.currencyArray = [[[NSUserDefaults standardUserDefaults] objectForKey:K_USR_CURRENCY_RATES] allKeys];;
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
    NSInteger rowCount = [self.currencyArray count];
    return rowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrencyCell" forIndexPath:indexPath];
    
    NSString *currencyId = self.currencyArray[indexPath.row];
    
    //Remove the preceeding USD for all Currencies
    currencyId = ([currencyId isEqualToString:@"USDUSD"]) ? @"USD" : [currencyId stringByReplacingOccurrencesOfString:@"USD" withString:@""];
    cell.textLabel.text = currencyId;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedCurrency = self.currencyArray[indexPath.row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCurrency forKey:K_USR_SELECTED_CURRENCY];
    [defaults synchronize];
    
    self.masterVC.selectedCurrency = selectedCurrency;
}



@end
