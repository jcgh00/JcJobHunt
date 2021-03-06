//
//  ViewController.m
//  Acronyms
//
//  Created by Johnston Choy on 12/7/15.
//  Copyright (c) 2015 Johnston Choy. All rights reserved.
//
//  http://www.nactem.ac.uk/software/acromine/rest.html
//  http://www.nactem.ac.uk/software/acromine/dictionary.py


#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"

NSArray *assetData;

@interface ViewController () <MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IB Events

//user tapped button
- (IBAction)searchTap:(id)sender{
    NSLog( @"search Down %@", self.inputField.text );
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(searchTask) onTarget:self withObject:nil animated:YES];
}

- (void)searchTask {
    NSDictionary *parameters = @{@"sf": self.inputField.text};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = nil;    //so AFN doesn't expect json response type
    [manager GET:@"http://www.nactem.ac.uk/software/acromine/dictionary.py"
      parameters: parameters
      success: ^(AFHTTPRequestOperation *operation, id responseObject) {
          assetData = responseObject;
          
          NSLog(@"JSON: %@", responseObject);
          if ([responseObject count] > 0) {
              NSDictionary *inner = [responseObject objectAtIndex: 0];
              NSLog(@"sf: %@", [inner objectForKey: @"sf"]);
              NSLog(@"lfs: %lu", [[inner objectForKey: @"lfs"] count]);
          }
          [myTableView reloadData];
      }
      failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
      }
    ];
    NSLog( @"Search task complete" );
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog( @"numberOfSectionsInTableView" );
    if (assetData == nil) return 0;
    if ([assetData count] == 0) return 0;
    NSDictionary *inner = [assetData objectAtIndex: 0];
    return [[inner objectForKey: @"lfs"] count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *inner = [assetData objectAtIndex: 0];
    NSDictionary *lfo = [[inner objectForKey: @"lfs"] objectAtIndex: section];
    return [[lfo objectForKey: @"vars"] count]+1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"LFCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.layer.cornerRadius = 10;
    }
    
    //NSLog( @"cellForRowAtIndexPath %li", indexPath.row );
    NSDictionary *inner = [assetData objectAtIndex: 0];
    NSDictionary *lfo = [[inner objectForKey: @"lfs"] objectAtIndex: indexPath.section];
    NSArray *vars = [lfo objectForKey: @"vars"];
    
    if (indexPath.row == 0){
        cell.textLabel.text = [lfo objectForKey: @"lf"];
        cell.viewForBaselineLayout.backgroundColor = [UIColor lightGrayColor];
    } else {
        lfo = [vars objectAtIndex: indexPath.row-1];
        cell.textLabel.text = [lfo objectForKey: @"lf"];
        cell.viewForBaselineLayout.backgroundColor = [UIColor whiteColor];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat: @"freq: %@ since: %@",
                                 [lfo objectForKey: @"freq"],
                                 [lfo objectForKey: @"since"] ];
    

    cell.textLabel.font = [UIFont boldSystemFontOfSize: 14];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


@end
