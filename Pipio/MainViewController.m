//
//  MainViewController.m
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"
#import "STTwitter.h"
#import "Tweet.h"
#import "Masonry.h"
#import "DataStore.h"
#import "TweetDetailView.h"

@interface MainViewController ()
{
    STTwitterAPI *twitter;
    NSMutableArray *tweets;
    
    UITableView *dataTable;
    
    NSString *campaign;
    DataStore *dataStore;
    
    TweetDetailView *tweetDetail;
    
    BOOL selectable;
    
    UILabel *detailLabel;
}
@end

@implementation MainViewController

- (id)initWithCampaign:(NSString*)campaignString{
    self = [super init];
    
    if (self){
        campaign = campaignString;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sentimentFound) name:@"SentimentFound" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.view.backgroundColor = UIColorFromRGB(0x497AA6);
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Pipio";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(backButtonClicked:)];
    self.navigationItem.leftBarButtonItems = @[backButton];
    
    UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashButtonClicked:)];
    self.navigationItem.rightBarButtonItems = @[trashButton];
    
    dataTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [dataTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.estimatedRowHeight = 150;
    dataTable.rowHeight = 150;
    [self.view addSubview:dataTable];
    
    [dataTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    tweets = [NSMutableArray array];
    
    tweetDetail = [[TweetDetailView alloc] initWithCampaign:campaign];
    tweetDetail.hidden = YES;
    [self.view addSubview:tweetDetail];
    
    detailLabel = [[UILabel alloc] init];
    detailLabel.backgroundColor = UIColorFromRGB(0xF2CC0C);
    detailLabel.text = campaign;
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:detailLabel];
    
    twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:CONSUMER_KEY
                                                            consumerSecret:CONSUMER_SECRET];
    
    if (![[DataStore sharedStore] getCampaign:campaign]){
        
        [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
            
            [self loadTweets:nil];
            
        } errorBlock:^(NSError *error) {
            // Credentials not verified
        }];
        
    }else{
        
        tweets = [NSMutableArray arrayWithArray:[[DataStore sharedStore] getCampaign:campaign]];
        [dataTable reloadData];
        
        selectable = YES;
        
    }
}

- (void)loadTweets:(NSString*)maxID{
    [twitter getSearchTweetsWithQuery:[campaign stringByAppendingString:@" -filter:retweets"] geocode:nil lang:@"en" locale:nil resultType:@"mixed" count:@"100" until:nil sinceID:nil maxID:maxID includeEntities:@0 callback:nil successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
        
        for (int i = 0; i < [statuses count]; i++){
            Tweet *tweet = [[Tweet alloc] initWithData:[statuses objectAtIndex:i]];
            [tweet performSelectorInBackground:@selector(getSentiment) withObject:nil];
            [tweets addObject:tweet];
            
            [dataTable reloadData];
            
            NSLog(@"%@", tweet.text);
            NSLog(@"%@", tweet.name);
            NSLog(@"%ld", (long)tweet.sentiment);
            NSLog(@"\n");
            
            if ([tweets count] >= 100){
                return;
            }
        }
        
        if ([tweets count] < 100){
            [self performSelectorInBackground:@selector(loadTweets:) withObject:[[statuses lastObject] objectForKey:@"id_str"]];
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Error");
    }];
}

- (void)viewDidLayoutSubviews{
    [dataTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@40);
    }];
    
    [tweetDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(detailLabel.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@120);
    }];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tweets count] == 100){
        // Initialize data store
        
//        dataStore = [DataStore sharedStore];
//        [dataStore addCampaign:campaign withData:tweets];
    }
    
    return [tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    Tweet *tweet = [tweets objectAtIndex:indexPath.row];
    
    cell.textLabel.text = tweet.text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
    switch (tweet.sentiment) {
        case TweetSentimentPositive:
            cell.backgroundColor = [UIColor greenColor];
            break;
        case TweetSentimentNegative:
            cell.backgroundColor = [UIColor redColor];
            break;
        case TweetSentimentNeutral:
            cell.backgroundColor = [UIColor whiteColor];
        default:
            cell.backgroundColor = [UIColor whiteColor];
            break;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tweetDetail fillDetails:[tweets objectAtIndex:indexPath.row]];
    tweetDetail.hidden = NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectable){
        return indexPath;
    }
    
    return nil;
}

- (void)backButtonClicked:(UIBarButtonItem*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)trashButtonClicked:(UIBarButtonItem*)sender{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete Campaign" message:@"Are you sure you want to delete this campaign?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.delegate = self;
    [alertView show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.cancelButtonIndex != buttonIndex){
        [[DataStore sharedStore] deleteEngagementsForCampaign:campaign];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteCampaign" object:campaign];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)sentimentFound{
    if ([tweets count] == 100){
        dataStore = [DataStore sharedStore];
        [dataStore addCampaign:campaign withData:tweets];
        selectable = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
