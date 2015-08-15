//
//  CircleView.m
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import "CircleView.h"
#import "Constants.h"

@implementation CircleView

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColor(ctx, CGColorGetComponents([UIColorFromRGB(0x023059) CGColor]));
    CGContextFillPath(ctx);
}

@end
