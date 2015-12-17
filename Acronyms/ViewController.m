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

NSArray *assetData;

@interface ViewController ()

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
- (IBAction)searchDown:(id)sender{
    NSLog( @"search Down %@", self.inputField.text );
    NSDictionary *parameters = @{@"sf": self.inputField.text};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = nil;    //so AFN doesn't expect json response type
    [manager GET:@"http://www.nactem.ac.uk/software/acromine/dictionary.py"
      parameters: parameters
      success: ^(AFHTTPRequestOperation *operation, id responseObject) {
          //NSMutableArray *result = [NSJSONSerialization
          //                          JSONObjectWithData: responseObject
          //                          options:NSJSONReadingMutableContainers error:nil];
          assetData = responseObject;
          
          NSLog(@"JSON: %@", responseObject);
          if ([responseObject count] > 0) {
              NSDictionary *inner = [responseObject objectAtIndex: 0];
              NSLog(@"sf: %@", [inner objectForKey: @"sf"]);
              NSLog(@"lfs: %lu", [[inner objectForKey: @"lfs"] count]);
              //NSLog(@"lfs: %@", [[inner objectForKey: @"lfs"] objectAtIndex: 1 ]);
          }
          [myTableView reloadData];
      }
      failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
      }
    ];
    
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
        /*
        cell.layer.cornerRadius = 10;
        UIView *tf = [[UIView alloc] init];
        tf.backgroundColor = [UIColor lightGrayColor];
        tf.frame = CGRectMake(275, 14, 15, 15);
        tf.layer.cornerRadius = 5.0f;
        [cell.contentView addSubview: tf];
        */
    }
    
    NSLog( @"cellForRowAtIndexPath %li", indexPath.row );
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

/*
 JSON: (
 {

 lfs =         (
 {
 freq = 267;
 lf = "heavy meromyosin";
 since = 1971;
 vars =                 (
 {
 freq = 244;
 lf = "heavy meromyosin";
 since = 1971;
 },
 {
 freq = 12;
 lf = "Heavy meromyosin";
 since = 1975;
 },
 {
 freq = 5;
 lf = "H-meromyosin";
 since = 1975;
 },
 {
 freq = 4;
 lf = "heavy-meromyosin";
 since = 1977;
 },
 {
 freq = 1;
 lf = "heavy  meromyosin";
 since = 1976;
 },
 {
 freq = 1;
 lf = "H-Meromyosin";
 since = 1976;
 }
 );
 },
 {
 freq = 245;
 lf = "hidden Markov model";
 since = 1990;
 vars =                 (
 {
 freq = 148;
 lf = "hidden Markov model";
 since = 1992;
 },
 {
 freq = 29;
 lf = "Hidden Markov Model";
 since = 1993;
 },
 {
 freq = 26;
 lf = "hidden Markov models";
 since = 1995;
 },
 {
 freq = 13;
 lf = "Hidden Markov Models";
 since = 2001;
 },
 {
 freq = 9;
 lf = "Hidden Markov model";
 since = 1994;
 },
 {
 freq = 6;
 lf = "Hidden Markov models";
 since = 1995;
 },
 {
 freq = 2;
 lf = "Hidden Markov Modeling";
 since = 2007;
 },
 {
 freq = 2;
 lf = "hidden Markov Model";
 since = 2008;
 },
 {
 freq = 2;
 lf = "Hidden Markov modeling";
 since = 2000;
 },
 {
 freq = 2;
 lf = "hidden Markov modeling";
 since = 1990;
 },
 */

@end
