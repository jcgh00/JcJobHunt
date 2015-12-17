//
//  ViewController.h
//  Acronyms
//
//  Created by Johnston Choy on 12/7/15.
//  Copyright (c) 2015 Johnston Choy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate>
{
    IBOutlet UITableView *myTableView;
}

@property (nonatomic, retain) IBOutlet UITextField *inputField;

- (IBAction)searchTap:(id)sender;

@end

