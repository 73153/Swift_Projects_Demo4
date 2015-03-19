//
//  AbstractTwitterViewController.m
//  SharedCore
//
//  Created by Jonathan Steele on 2/9/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

#import "AbstractTwitterViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface AbstractTwitterViewController ()

@property (nonatomic) NSArray *list;

@end

@implementation AbstractTwitterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)twitterTimeline:(NSString *)screenName
{
    ACAccountStore *account = [[ACAccountStore alloc] init]; // Creates AccountStore object.
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted == YES) {
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType]; // Retrieves an array of Twitter accounts configured on the device.
            
            // If there is least one account we will contact the Twitter API.
            if ([arrayOfAccounts count] > 0) {
                ACAccount *twitterAccount = [arrayOfAccounts lastObject]; // Sets the last account on the device to the twitterAccount variable.
                
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"]; // API call that returns entires in a user's timeline.
                
                // The requestAPI requires us to tell it how much data to return so we use a NSDictionary to set the 'count'.
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setObject:screenName forKey:@"screen_name"];
                [parameters setObject:@"100" forKey:@"count"];
                
                // This is where we are getting the data using SLRequest.
                SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:parameters];
                posts.account = twitterAccount;
                
                // The postRequest: method call now accesses the NSData object returned.
                [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error) {
                    // The NSJSONSerialization class is then used to parse the data returned and assign it to our array.
                    self.list = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                    if (self.list.count != 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData]; // Here we tell the table view to reload the data it just recieved.
                        });
                    }
                }];
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TwitterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *tweet = self.list[indexPath.row];
    if ([tweet[@"retweeted_status"] count] > 0) {
        tweet = tweet[@"retweeted_status"];
    }
    cell.textLabel.text = tweet[@"user"][@"screen_name"];
    cell.detailTextLabel.text = tweet[@"text"];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}*/

@end
