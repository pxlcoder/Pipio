//
//  TweetDetailView.h
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailView : UIView

- (void)fillDetails:(Tweet*)tweet;
- (id)initWithCampaign:(NSString*)campaign;

@end
