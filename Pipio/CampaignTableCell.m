//
//  CampaignTableCell.m
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import "CampaignTableCell.h"
#import "Constants.h"
#import "Masonry.h"

@interface CampaignTableCell ()
{
    UILabel *campaignLabel;
    UILabel *positiveLabel;
    UILabel *neutralLabel;
    UILabel *negativeLabel;
    
    UIImageView *positiveImage;
    UIImageView *neutralImage;
    UIImageView *negativeImage;
}
@end

@implementation CampaignTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        campaignLabel = [[UILabel alloc] init];
        campaignLabel.textColor = [UIColor blackColor];
        campaignLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:campaignLabel];
        
        positiveLabel = [[UILabel alloc] init];
        positiveLabel.textColor = [UIColor blackColor];
        positiveLabel.textAlignment = NSTextAlignmentLeft;
        positiveLabel.text = @"0";
        [self addSubview:positiveLabel];
        
        neutralLabel = [[UILabel alloc] init];
        neutralLabel.textColor = [UIColor blackColor];
        neutralLabel.textAlignment = NSTextAlignmentLeft;
        neutralLabel.text = @"0";
        [self addSubview:neutralLabel];
        
        negativeLabel = [[UILabel alloc] init];
        negativeLabel.textColor = [UIColor blackColor];
        negativeLabel.textAlignment = NSTextAlignmentLeft;
        negativeLabel.text = @"0";
        [self addSubview:negativeLabel];
        
        positiveImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Circle"]];
        positiveImage.contentMode = UIViewContentModeScaleAspectFit;
        positiveImage.image = [positiveImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [positiveImage setTintColor:[UIColor greenColor]];
        [self addSubview:positiveImage];
        
        neutralImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Circle"]];
        neutralImage.contentMode = UIViewContentModeScaleAspectFit;
        neutralImage.image = [neutralImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [neutralImage setTintColor:[UIColor yellowColor]];
        [self addSubview:neutralImage];
        
        negativeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Circle"]];
        negativeImage.contentMode = UIViewContentModeScaleAspectFit;
        negativeImage.image = [negativeImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [negativeImage setTintColor:[UIColor redColor]];
        [self addSubview:negativeImage];
    }
    return self;
}

- (void)setCampaignText:(NSString*)text{
    campaignLabel.text = text;
}

- (void)setNumbers:(NSArray*)numbers{
    positiveLabel.text = [[numbers objectAtIndex:0] stringValue];
    neutralLabel.text = [[numbers objectAtIndex:1] stringValue];
    negativeLabel.text = [[numbers objectAtIndex:2] stringValue];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [campaignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(20);
        make.width.equalTo(self.mas_width).multipliedBy(0.8);
    }];
    
    [neutralImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(campaignLabel.mas_right);
        make.width.equalTo(self.mas_height).multipliedBy(0.15);
    }];
    
    [positiveImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-25);
        make.left.equalTo(campaignLabel.mas_right);
        make.width.equalTo(self.mas_height).multipliedBy(0.15);
    }];

    [negativeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(25);
        make.left.equalTo(campaignLabel.mas_right);
        make.width.equalTo(self.mas_height).multipliedBy(0.15);
    }];
    
    [neutralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(neutralImage.mas_centerY);
        make.left.equalTo(neutralImage.mas_right).offset(5);
    }];
    
    [positiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(positiveImage.mas_centerY);
        make.left.equalTo(positiveImage.mas_right).offset(5);
    }];
    
    [negativeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(negativeImage.mas_centerY);
        make.left.equalTo(negativeImage.mas_right).offset(5);
    }];
}

@end
