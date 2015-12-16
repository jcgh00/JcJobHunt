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
          NSDictionary *inner = [responseObject objectAtIndex: 0];
          NSLog(@"sf: %@", [inner objectForKey: @"sf"]);
          NSLog(@"lfs: %lu", [[inner objectForKey: @"lfs"] count]);
          //NSLog(@"lfs: %@", [[inner objectForKey: @"lfs"] objectAtIndex: 1 ]);
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
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"LFCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.layer.cornerRadius = 10;
        UIView *tf = [[UIView alloc] init];
        tf.backgroundColor = [UIColor lightGrayColor];
        tf.frame = CGRectMake(275, 14, 15, 15);
        tf.layer.cornerRadius = 5.0f;
        [cell.contentView addSubview: tf];
    }
    
    NSDictionary *inner = [assetData objectAtIndex: 0];
    NSDictionary *lfo = [[inner objectForKey: @"lfs"] objectAtIndex: indexPath.section];
    
    NSLog( @"cellForRowAtIndexPath %li, %li", (long)indexPath.section, (long)indexPath.row );
    cell.textLabel.text = [lfo objectForKey: @"lf"];
    
    cell.detailTextLabel.text = @"...";

    cell.textLabel.font = [UIFont boldSystemFontOfSize: 14];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


@end
