//
//  AbstractScheduleViewController.m
//  SharedCore
//
//  Created by Jonathan Steele on 2/9/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

#import "AbstractScheduleViewController.h"
#import "ScheduleTableCell.h"
#import "GDataXMLNode.h"
#import "Event.h"

@implementation AbstractScheduleViewController

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

- (void) makeURLRequest:(NSString *)url
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               if (([httpResponse statusCode]/100) == 2) {
                                   [self handleParsing:data];
                               }
                           }
     ];
}

- (void) handleParsing:(NSData *)data
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHH:mm"];
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSArray *nodes = [doc nodesForXPath:@"//current_events[@academicYear='2013']/*" error:nil];
    for (GDataXMLElement *node in nodes) {
        Event *eventObject = [[Event alloc] init];
        
        NSString *dateString = [node attributeForName:@"date"].stringValue;
        
        NSArray *events = [node elementsForName:@"event"];
        if (events.count > 0) {
            GDataXMLElement *event = [events objectAtIndex:0];
            NSString *easternTime = [event attributeForName:@"eastern_time"].stringValue;
            NSString *date = [dateString stringByAppendingString:easternTime];
            eventObject.date = [dateFormatter dateFromString:date];
            eventObject.homeScore = [event attributeForName:@"hs"].stringValue;
            eventObject.homeTeam = [event attributeForName:@"hn"].stringValue;
            eventObject.awayScore = [event attributeForName:@"vs"].stringValue;
            eventObject.awayTeam = [event attributeForName:@"vn"].stringValue;
        }
        
        [self.list addObject:eventObject];
    }
    [self.tableView reloadData];
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
    static NSString *CellIdentifier = @"SchedulesCell";
    ScheduleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [cell configureWithEvents:[self.list objectAtIndex:indexPath.row]];
    
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
