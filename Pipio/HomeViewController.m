//
//  HomeViewController.m
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import "HomeViewController.h"
#import "Constants.h"
#import "Masonry.h"
#import "HeaderView.h"
#import "MainViewController.h"
#import "CampaignTableCell.h"
#import "DataStore.h"
#import "EngagementsTableCell.h"

@interface HomeViewController ()
{
    NSString *username;
    HeaderView *headerView;
    
    UITableView *campaignTableView;
    UITextField *campaignTextField;
    
    UITableView *engagementsTableView;
    
    NSMutableArray *campaigns;
    
    DataStore *dataStore;
    
    UIBarButtonItem *swapButton;
    
    BOOL campaignMode;
    UILabel *mode;
}
@end

@implementation HomeViewController

- (id)initWithUsername:(NSString*)userName{
    self = [super init];
    
    if (self){
        username = userName;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCampaign:) name:@"DeleteCampaign" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    campaignMode = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Pipio";
    
    self.view.backgroundColor = UIColorFromRGB(0xAED3F2);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    campaigns = [NSMutableArray array];
    
    campaignTableView = [[UITableView alloc] init];
    [campaignTableView registerClass:[CampaignTableCell class] forCellReuseIdentifier:@"Cell"];
    campaignTableView.delegate = self;
    campaignTableView.dataSource = self;
    campaignTableView.tag = 1;
    campaignTableView.estimatedRowHeight = 100;
    campaignTableView.rowHeight = 100;
    [self.view addSubview:campaignTableView];
    
    [campaignTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    engagementsTableView = [[UITableView alloc] init];
    [engagementsTableView registerClass:[EngagementsTableCell class] forCellReuseIdentifier:@"EngCell"];
    engagementsTableView.delegate = self;
    engagementsTableView.dataSource = self;
    engagementsTableView.tag = 2;
    engagementsTableView.estimatedRowHeight = 100;
    engagementsTableView.rowHeight = 100;
    engagementsTableView.hidden = YES;
    [self.view addSubview:engagementsTableView];
    
    [engagementsTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    headerView = [[HeaderView alloc] initWithUsername:username];
    [self.view addSubview:headerView];
    
    dataStore = [DataStore sharedStore];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.rightBarButtonItems = @[addButton];
    
    swapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Person"] style:UIBarButtonItemStylePlain target:self action:@selector(swapType)];
    self.navigationItem.leftBarButtonItems = @[swapButton];
    
    mode = [[UILabel alloc] init];
    mode.textColor = [UIColor blackColor];
    mode.textAlignment = NSTextAlignmentCenter;
    mode.text = @"Campaigns";
    [self.view addSubview:mode];
}

- (void)viewDidAppear:(BOOL)animated{
    [campaignTableView reloadData];
    [engagementsTableView reloadData];
}

- (void)viewDidLayoutSubviews{
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(self.topLayoutGuide.length);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.17);
    }];
    
    [mode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@20);
    }];
    
    [campaignTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(headerView.mas_bottom).offset(40);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [engagementsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(headerView.mas_bottom).offset(40);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)addItem:(UIBarButtonItem*)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Campaign" message:@"Enter a campaign name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = self;
    campaignTextField = [alertView textFieldAtIndex:0];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.cancelButtonIndex != buttonIndex){
        [campaigns addObject:[@"#" stringByAppendingString:campaignTextField.text]];
        [campaignTableView reloadData];
    }
}

- (void)swapType{
    if (campaignMode){
        swapButton.image = [UIImage imageNamed:@"Speaker"];
        mode.text = @"Engagements";
        campaignMode = NO;
        campaignTableView.hidden = YES;
        engagementsTableView.hidden = NO;
    }else{
        swapButton.image = [UIImage imageNamed:@"Person"];
        mode.text = @"Campaigns";
        campaignMode = YES;
        campaignTableView.hidden = NO;
        engagementsTableView.hidden = YES;
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 1){
        return [campaigns count];
    }else{
        return [[[DataStore sharedStore] getEngagements] count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1){
        CampaignTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (cell == nil){
            cell = [[CampaignTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //cell.textLabel.text = [campaigns objectAtIndex:indexPath.row];
        
        [cell setCampaignText:[campaigns objectAtIndex:indexPath.row]];
        
        if ([dataStore getCampaign:[campaigns objectAtIndex:indexPath.row]]){
            [cell setNumbers:[dataStore getAnalysis:[campaigns objectAtIndex:indexPath.row]]];
        }
        
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        
        return cell;
        
    }else{
        
        EngagementsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EngCell"];
        
        if (cell == nil){
            cell = [[EngagementsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EngCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell fillDetails:[[[DataStore sharedStore] getEngagements] objectAtIndex:indexPath.row]];
        
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        
        return cell;
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1){
        NSString *campaignString = [campaigns objectAtIndex:indexPath.row];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:[[MainViewController alloc] initWithCampaign:campaignString] animated:YES];
        });
    }

}

- (void)deleteCampaign:(NSNotification*)notif{
    NSString *str = [notif object];
    [campaigns removeObject:str];
    [campaignTableView reloadData];
}

@end
