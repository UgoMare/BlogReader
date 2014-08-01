//
//  BlogPost.m
//  BlogReader
//
//  Created by Ugo on 28/07/2014.
//  Copyright (c) 2014 Ugo. All rights reserved.
//

#import "BlogPost.h"

@implementation BlogPost

- (id) initWithTitle:(NSString *)title{
    self = [super init];
    
    if (self){
        self.title = title;
        self.author = @"Unknow";
        self.thumbnail = nil;
    }
    return self;
}

+ (id) blogPostWithTitle:(NSString *)title{
    return [[self alloc] initWithTitle:title];
}

-(NSURL *)thumbnailURL:(NSString *)stringURL{
    return [NSURL URLWithString:stringURL];
}

-(NSString *) formattedDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *tempDate = [dateFormatter dateFromString:self.date];
    
    [dateFormatter setDateFormat:@"EE MMM, dd"];
    return [dateFormatter stringFromDate:tempDate];
}

@end
