//
//  TweetDetailView.m
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import "TweetDetailView.h"
#import "Masonry.h"
#import "Constants.h"
#import "DataStore.h"

@interface TweetDetailView ()
{
    UIImageView *personIcon;
    UIImageView *followersIcon;
    UIImageView *retweetIcon;
    
    UILabel *nameLabel;
    UILabel *followersLabel;
    UILabel *retweetLabel;
    
    UILabel *plusLabel;
    
    UIImageView *closeImage;
    UIImageView *addImage;
    
    Tweet *currentTweet;
    
    NSString *currentCampaign;
}
@end

@implementation TweetDetailView

- (id)initWithCampaign:(NSString*)campaign{
    self = [super init];
    
    if (self){
        
        currentCampaign = campaign;
        
        self.backgroundColor = UIColorFromRGB(0xF2CC0C);
        
        personIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Person"]];
        personIcon.image = [personIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [personIcon setTintColor:[UIColor whiteColor]];
        [self addSubview:personIcon];
        
        followersIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Person"]];
        followersIcon.image = [followersIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [followersIcon setTintColor:[UIColor whiteColor]];
        [self addSubview:followersIcon];
        
        retweetIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Retweet"]];
        retweetIcon.image = [retweetIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [retweetIcon setTintColor:[UIColor whiteColor]];
        [self addSubview:retweetIcon];
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        //nameLabel.text = @"Test";
        nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:nameLabel];
        
        followersLabel = [[UILabel alloc] init];
        followersLabel.textAlignment = NSTextAlignmentCenter;
        //followersLabel.text = @"657809";
        followersLabel.textColor = [UIColor whiteColor];
        [self addSubview:followersLabel];
        
        retweetLabel = [[UILabel alloc] init];
        retweetLabel.textAlignment = NSTextAlignmentCenter;
        //retweetLabel.text = @"1000";
        retweetLabel.textColor = [UIColor whiteColor];
        [self addSubview:retweetLabel];
        
        plusLabel = [[UILabel alloc] init];
        plusLabel.textAlignment = NSTextAlignmentLeft;
        plusLabel.text = @"+";
        plusLabel.textColor = [UIColor whiteColor];
        [self addSubview:plusLabel];
        
        closeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Close"]];
        closeImage.contentMode = UIViewContentModeScaleAspectFit;
        closeImage.image = [closeImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [closeImage setTintColor:[UIColor whiteColor]];
        closeImage.userInteractionEnabled = YES;
        [closeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)]];
        [self addSubview:closeImage];
        
        addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Add"]];
        addImage.image = [addImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [addImage setTintColor:[UIColor whiteColor]];
        addImage.userInteractionEnabled = YES;
        addImage.contentMode = UIViewContentModeScaleAspectFit;
        [addImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addToStore)]];
        [self addSubview:addImage];
        
    }
    
    return self;
}

- (void)fillDetails:(Tweet*)tweet{
    nameLabel.text = [@"@" stringByAppendingString:tweet.screenName];
    followersLabel.text = [tweet.followerCount stringValue];
    retweetLabel.text = [tweet.retweetCount stringValue];
    
    switch (tweet.sentiment) {
        case TweetSentimentPositive:
            [personIcon setTintColor:[UIColor greenColor]];
            break;
        case TweetSentimentNegative:
            [personIcon setTintColor:[UIColor redColor]];
            break;
        default:
            [personIcon setTintColor:[UIColor whiteColor]];
            break;
    }
    
    currentTweet = tweet;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [followersIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    [plusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(followersIcon.mas_right).offset(-5);
        make.top.equalTo(followersIcon.mas_top).offset(-15);
    }];
    
    [personIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-40);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    [retweetIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(40);
        make.left.equalTo(self.mas_left).offset(13);
    }];
    
    [followersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(followersIcon.mas_right).offset(10);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-40);
        make.left.equalTo(personIcon.mas_right).offset(10);
    }];
    
    [retweetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(40);
        make.left.equalTo(retweetIcon.mas_right).offset(7);
    }];
    
    [closeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(5);
        make.height.equalTo(self.mas_height).multipliedBy(0.24);
    }];
    
    [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(-35);
        make.right.equalTo(closeImage.mas_right).offset(-35);
        make.height.equalTo(self.mas_height);
    }];
}

- (void)closeView{
    self.hidden = YES;
}

- (void)addToStore{
    if (currentTweet){
        currentTweet.campaign = currentCampaign;
        [[DataStore sharedStore] addEngagement:currentTweet];
        self.hidden = YES;
    }
}

@end
