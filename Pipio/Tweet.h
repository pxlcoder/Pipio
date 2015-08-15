//
//  Tweet.h
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Tweet : NSObject

// Initializer

- (id)initWithData:(NSDictionary*)data;

// Get sentiment

- (void)getSentiment;

@property (nonatomic, copy) NSString *createdDate;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *screenName;

@property (nonatomic, strong) NSNumber *followerCount;
@property (nonatomic, strong) NSNumber *retweetCount;

@property (nonatomic,assign) TweetSentiment sentiment;

@property (nonatomic,copy) NSString *campaign;

@end
