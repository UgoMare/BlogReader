//
//  TableViewController.h
//  BlogReader
//
//  Created by Ugo on 28/07/2014.
//  Copyright (c) 2014 Ugo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *blogPosts;
@property (nonatomic, assign) BOOL moreDisplayed;
@property (nonatomic, assign) int page;
- (IBAction)refresh:(id)sender;

@end
