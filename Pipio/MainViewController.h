//
//  MainViewController.h
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

- (id)initWithCampaign:(NSString*)campaignString;

@end

