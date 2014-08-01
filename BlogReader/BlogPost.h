//
//  BlogPost.h
//  BlogReader
//
//  Created by Ugo on 28/07/2014.
//  Copyright (c) 2014 Ugo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogPost : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSURL *url;

//Designated Initializer
- (id) initWithTitle:(NSString *)title;
+ (id) blogPostWithTitle:(NSString *)title;
-(NSURL *)thumbnailURL:(NSString *)stringURL;
-(NSString *) formattedDate;
@end
