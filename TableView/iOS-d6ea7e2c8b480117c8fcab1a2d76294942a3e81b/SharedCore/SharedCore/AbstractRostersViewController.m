//
//  RostersViewController.m
//  NolesFootball
//
//  Created by Jonathan Steele on 1/22/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

#import "AbstractRostersViewController.h"
#import "GDataXMLNode.h"
#import "Rosters.h"

@implementation AbstractRostersViewController

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

- (void)parsing:(NSString *)url
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               if (([httpResponse statusCode]/100) == 2) {
                                   GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
                                   [self handleStaffParsing:doc];
                                   [self handlePlayerParsing:doc];
                                   [self.tableView reloadData];
                               }
                           }
     ];
}

- (void)handleStaffParsing:(GDataXMLDocument *)doc
{
    NSArray *nodes = [doc nodesForXPath:@"//asst_coach_lev1 | //asst_coach_lev2 | //asst_coach_lev3 | //head_coach | //other" error:nil];
    for (GDataXMLElement *node in nodes) {
        Rosters *rostersObject = [[Rosters alloc] init];
        
        NSArray *firstNames = [node elementsForName:@"first_name"];
        if (firstNames.count > 0) {
            GDataXMLElement *firstName = [firstNames objectAtIndex:0];
            rostersObject.firstName = firstName.stringValue;
        }
        
        NSArray *lastNames = [node elementsForName:@"last_name"];
        if (lastNames.count > 0) {
            GDataXMLElement *lastName = [lastNames objectAtIndex:0];
            rostersObject.lastName = lastName.stringValue;
        }
        
        NSArray *positions = [node elementsForName:@"position"];
        if (positions.count > 0) {
            GDataXMLElement *pos = [positions objectAtIndex:0];
            rostersObject.position = pos.stringValue;
        }
        
        [self.staffList addObject:rostersObject];
    }
}

- (void)handlePlayerParsing:(GDataXMLDocument *)doc
{
    NSArray *nodes = [doc nodesForXPath:@"//player" error:nil];
    for (GDataXMLElement *node in nodes) {
        Rosters *rostersObject = [[Rosters alloc] init];
        
        NSArray *firstNames = [node elementsForName:@"first_name"];
        if (firstNames.count > 0) {
            GDataXMLElement *firstName = [firstNames objectAtIndex:0];
            rostersObject.firstName = firstName.stringValue;
        }
        
        NSArray *lastNames = [node elementsForName:@"last_name"];
        if (lastNames.count > 0) {
            GDataXMLElement *lastName = [lastNames objectAtIndex:0];
            rostersObject.lastName = lastName.stringValue;
        }
        
        NSArray *positions = [node elementsForName:@"position"];
        if (positions.count > 0) {
            GDataXMLElement *pos = [positions objectAtIndex:0];
            rostersObject.position = pos.stringValue;
        }

        
        [self.playerList addObject:rostersObject];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [self.staffList count];
    }
    return [self.playerList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Staff";
    }
    return @"Player";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RostersCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Rosters *roster;
    if (indexPath.section == 0) {
        roster = [self.staffList objectAtIndex:indexPath.row];
    } else {
        roster = [self.playerList objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", roster.firstName, roster.lastName];
    cell.detailTextLabel.text = roster.position;
    
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
