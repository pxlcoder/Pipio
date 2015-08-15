//
//  DataStore.h
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@interface DataStore : NSObject

+ (id)sharedStore;

- (void)addCampaign:(NSString*)string withData:(NSArray*)tweets;
- (void)removeCampaign:(NSString*)string;
- (NSArray*)getCampaign:(NSString*)string;

- (NSArray*)getAnalysis:(NSString*)string;

- (void)addEngagement:(Tweet*)tweet;
- (void)removeEngagement:(NSUInteger)index;
- (NSMutableArray*)getEngagements;
- (void)deleteEngagementsForCampaign:(NSString*)campaign;

@end