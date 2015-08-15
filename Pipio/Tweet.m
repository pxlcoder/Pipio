//
//  Tweet.m
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import "Tweet.h"
#import "UNIRest.h"

@implementation Tweet

- (id)initWithData:(NSDictionary *)data{
    self = [super init];
    
    if (self){
        self.createdDate = [data objectForKey:@"created_at"];
        
        self.text = [data objectForKey:@"text"];
        self.name = [[data objectForKey:@"user"] objectForKey:@"name"];
        self.screenName = [[data objectForKey:@"user"] objectForKey:@"screen_name"];
        
        self.followerCount = [[data objectForKey:@"user"] objectForKey:@"followers_count"];
        self.retweetCount = [data objectForKey:@"retweet_count"];
    }
    
    return self;
}

- (void)getSentiment{
    
    NSDictionary* parameters = @{@"txt": self.text};
    
    UNIHTTPJsonResponse *response = [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:API_ENDPOINT];
        [request setParameters:parameters];
    }] asJson];
    
    int sentimentScore = [[[response.body.object objectForKey:@"result"] objectForKey:@"confidence"] intValue];
    NSString *sentiment =  [[response.body.object objectForKey:@"result"] objectForKey:@"sentiment"];
    
    if (sentimentScore < 71){
        self.sentiment = TweetSentimentNeutral;
        return;
    }
    
    if ([sentiment isEqualToString:@"Positive"]){
        self.sentiment = TweetSentimentPositive;
    }else if ([sentiment isEqualToString:@"Neutral"]){
        self.sentiment = TweetSentimentNeutral;
    }else if ([sentiment isEqualToString:@"Negative"]){
        self.sentiment = TweetSentimentNegative;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SentimentFound" object:nil];
}

@end
