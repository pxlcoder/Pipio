//
//  EngagementsTableCell.m
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import "EngagementsTableCell.h"
#import "Masonry.h"

@interface EngagementsTableCell ()
{
    UIImageView *sentimentCircle;
    UILabel *nameLabel;
    UILabel *campaignLabel;
}
@end

@implementation EngagementsTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:nameLabel];
        
        campaignLabel = [[UILabel alloc] init];
        campaignLabel.textColor = [UIColor blackColor];
        campaignLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:campaignLabel];
        
        sentimentCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Circle"]];
        sentimentCircle.contentMode = UIViewContentModeScaleAspectFit;
        sentimentCircle.image = [sentimentCircle.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //[sentimentCircle setTintColor:[UIColor yellowColor]];
        [self addSubview:sentimentCircle];

    }
    return self;
}

- (void)fillDetails:(Tweet *)tweet{
    nameLabel.text = [@"@" stringByAppendingString:tweet.screenName];
    campaignLabel.text = tweet.campaign;
    
    switch (tweet.sentiment) {
        case TweetSentimentPositive:
            [sentimentCircle setTintColor:[UIColor greenColor]];
            break;
        case TweetSentimentNegative:
            [sentimentCircle setTintColor:[UIColor redColor]];
            break;
        default:
            [sentimentCircle setTintColor:[UIColor yellowColor]];
            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-20);
        make.left.equalTo(self.mas_left).offset(20);
        make.width.equalTo(self.mas_width).multipliedBy(0.8);
    }];
    
    [campaignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(20);
        make.left.equalTo(self.mas_left).offset(20);
        make.width.equalTo(self.mas_width).multipliedBy(0.8);
    }];
    
    [sentimentCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(campaignLabel.mas_right);
        make.width.equalTo(self.mas_height).multipliedBy(0.15);
    }];
    
}

@end
