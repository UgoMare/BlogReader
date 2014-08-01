//
//  WebViewController.h
//  BlogReader
//
//  Created by Ugo on 01/08/2014.
//  Copyright (c) 2014 Ugo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UINavigationItem *webTitle;
@property (nonatomic, strong) NSURL *blogPostUrl;
@property (nonatomic, strong) NSString *pageTitle;

@end
