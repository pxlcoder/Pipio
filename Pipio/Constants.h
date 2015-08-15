//
//  Constants.h
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#ifndef Pipio_Constants_h
#define Pipio_Constants_h

#define CONSUMER_KEY @"X"
#define CONSUMER_SECRET @"X"

#define MASHAPE_KEY @"X"

#define API_ENDPOINT @"http://sentiment.vivekn.com/api/text/"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef NS_ENUM(NSInteger, TweetSentiment) {
    TweetSentimentIndeterminate = 0,
    TweetSentimentPositive,
    TweetSentimentNeutral,
    TweetSentimentNegative
};


#endif
