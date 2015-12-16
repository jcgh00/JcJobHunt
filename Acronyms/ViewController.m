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
          NSLog(@"JSON: %@", responseObject);
          NSDictionary *inner = [responseObject objectAtIndex: 0];
          NSLog(@"sf: %@", [inner objectForKey: @"sf"]);
          NSLog(@"lfs: %lu", [[inner objectForKey: @"lfs"] count]);
          NSLog(@"lfs: %@", [[inner objectForKey: @"lfs"] objectAtIndex: 1]);
      }
      failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
      }
    ];
    
}
@end
