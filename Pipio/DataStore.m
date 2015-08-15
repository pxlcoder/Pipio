//
//  DataStore.m
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import "DataStore.h"
#import "Tweet.h"

@interface DataStore ()
{
    NSMutableDictionary *data;
    NSMutableDictionary *analysis;
    
    NSMutableArray *engagements;
}
@end

@implementation DataStore

+ (id)sharedStore {
    static DataStore *sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataStore = [[self alloc] init];
    });
    return sharedDataStore;
}

- (id)init {
    self = [super init];
    
    if (self) {
        data = [[NSMutableDictionary alloc] init];
        analysis = [[NSMutableDictionary alloc] init];
        engagements = [NSMutableArray array];
    }
    
    return self;
}

- (void)addCampaign:(NSString *)string withData:(NSArray *)tweets{
    [data setObject:tweets forKey:string];
    [self runAnalysis:string];
}

- (void)removeCampaign:(NSString*)string{
    [data removeObjectForKey:string];
}

- (NSArray*)getCampaign:(NSString*)string{
    return [data objectForKey:string];
}

- (NSArray*)getAnalysis:(NSString*)string{
    return [analysis objectForKey:string];
}

- (void)runAnalysis:(NSString*)campaign{
    NSArray *campaignData = [self getCampaign:campaign];
    
    int positive = 0;
    int negative = 0;
    int neutral = 0;
    
    for (int i = 0; i < [campaignData count]; i++){
        Tweet *tweet = [campaignData objectAtIndex:i];
        
        switch (tweet.sentiment) {
            case TweetSentimentPositive:
                positive += 1;
                break;
            case TweetSentimentNegative:
                negative += 1;
                break;
            case TweetSentimentNeutral:
                neutral += 1;
                break;
            default:
                neutral += 1;
                break;
        }
    }
    
    [analysis setObject:@[@(positive), @(neutral), @(negative)] forKey:campaign];
}

- (void)addEngagement:(Tweet*)tweet{
    [engagements addObject:tweet];
}

- (void)removeEngagement:(NSUInteger)index{
    [engagements removeObjectAtIndex:index];
}

- (NSMutableArray*)getEngagements{
    return engagements;
}

- (void)deleteEngagementsForCampaign:(NSString*)campaign{
    engagements = [NSMutableArray arrayWithArray:[engagements filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"campaign != %@", campaign]]];
}

@end
