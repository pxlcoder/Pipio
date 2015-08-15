//
//  HeaderView.m
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import "HeaderView.h"
#import "Masonry.h"
#import "CircleView.h"
#import "Constants.h"

@interface HeaderView ()
{
    UIImageView *circle;
    UILabel *usernameLabel;
}
@end

@implementation HeaderView

- (id)initWithUsername:(NSString*)username{
    self = [super init];
    
    if (self){
        self.backgroundColor = [UIColor whiteColor];
        
        circle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Circle"]];
        circle.contentMode = UIViewContentModeScaleAspectFit;
        circle.image = [circle.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [circle setTintColor:UIColorFromRGB(0x023059)];
        [self addSubview:circle];
        
        usernameLabel = [[UILabel alloc] init];
        usernameLabel.text = username;
        usernameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:usernameLabel];
    }
    
    return self;
}

- (void)layoutSubviews{
    [circle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(40);
        make.bottom.equalTo(self.mas_bottom).offset(-40);
        
        make.width.equalTo(self.mas_width).multipliedBy(0.2);
    }];
    
    [usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

@end
