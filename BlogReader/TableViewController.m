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
    
    NSURL *blogURL = [NSURL URLWithString:@"http://localhost/ret.json"];
    NSData *jsonData = [NSData dataWithContentsOfURL: blogURL];
    NSError *error = nil;
    
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    self.blogPosts = [NSMutableArray array];
    NSString *author = nil;
    
    NSArray *blogPostArray = [dataDictionary objectForKey:@"posts"];
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

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showBlogPost"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BlogPost *blogPost = [self.blogPosts objectAtIndex:indexPath.row];

        [segue.destinationViewController setBlogPostUrl: blogPost.url];
        [segue.destinationViewController setPageTitle: blogPost.title];
    }
}

@end
