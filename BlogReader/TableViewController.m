//
//  TableViewController.m
//  BlogReader
//
//  Created by Ugo on 28/07/2014.
//  Copyright (c) 2014 Ugo. All rights reserved.
//

#import "TableViewController.h"
#import "BlogPost.h"
#import "WebViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    self.moreDisplayed = YES;
    self.page = 0;
    self.blogPosts = [NSMutableArray array];
    [self LoadPosts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%i", [self.blogPosts count]);
    return [self.blogPosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    BlogPost *blogPost = [self.blogPosts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = blogPost.title;
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@ - %@", blogPost.author, [blogPost formattedDate]];
    cell.imageView.image = blogPost.thumbnail;

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex) && self.moreDisplayed) {
        [self LoadPosts];
        [self.tableView reloadData];
    }
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showBlogPost"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BlogPost *blogPost = [self.blogPosts objectAtIndex:indexPath.row];

        [segue.destinationViewController setBlogPostUrl: blogPost.url];
        [segue.destinationViewController setPageTitle: blogPost.title];
    }
}

#pragma mark - Helper

-(void) LoadPosts{
    
    NSLog(@"Load Posts %i", self.page);
    
    NSString *url = [NSString stringWithFormat:@"http://localhost/blog_reader_ios/get_data.php?posts=%i", self.page];

    NSURL *blogURL = [NSURL URLWithString:url];
    NSData *jsonData = [NSData dataWithContentsOfURL: blogURL];
    NSError *error = nil;
    
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSString *author = nil;
    
    NSArray *blogPostArray = [dataDictionary objectForKey:@"posts"];
    self.moreDisplayed = ([blogPostArray count]) ? YES : NO;
    for (NSDictionary *bpDictionary in blogPostArray) {
        BlogPost *blogPost = [BlogPost blogPostWithTitle:[bpDictionary objectForKey:@"title"]];
        author = [bpDictionary objectForKey:@"author"];
        if(![author  isEqual: @""])
            blogPost.author = author;
        
        NSString *stringURL = [bpDictionary objectForKey:@"thumbnail"];
        if ([stringURL isKindOfClass:[NSString class]]) {
            NSData *imageData = [NSData dataWithContentsOfURL:[blogPost thumbnailURL:stringURL]];
            blogPost.thumbnail = [UIImage imageWithData:imageData];
        }
        else {
            blogPost.thumbnail = [UIImage imageNamed:@"no-image.png"];
        }
        blogPost.date = [bpDictionary objectForKey:@"date"];
        blogPost.url = [NSURL URLWithString: [bpDictionary objectForKey:@"url"]];
        [self.blogPosts addObject:blogPost];
    }
    self.page += 1;
}


- (IBAction)refresh:(id)sender {

    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    self.moreDisplayed = YES;
    self.page = 0;
    [self.blogPosts removeAllObjects];

    [self LoadPosts];

    [self.tableView reloadData];
    
}
@end
