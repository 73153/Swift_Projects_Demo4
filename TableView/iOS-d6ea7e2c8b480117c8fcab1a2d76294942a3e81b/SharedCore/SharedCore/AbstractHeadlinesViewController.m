//
//  AbstractHeadlinesViewController.m
//  SharedCore
//
//  Created by Jonathan Steele on 2/9/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

#import "AbstractHeadlinesViewController.h"
#import "GDataXMLNode.h"
#import "Feed.h"
#import "WebViewController.h"

@implementation AbstractHeadlinesViewController

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

- (void)handleParsing:(NSData *)data
{
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    NSArray *nodes = [doc nodesForXPath:@"//item" error:nil];
    for (GDataXMLElement *node in nodes) {
        Feed *feed = [[Feed alloc] init];
        
        NSArray *titles = [node elementsForName:@"title"];
        if (titles.count > 0) {
            GDataXMLElement *title = [titles objectAtIndex:0];
            feed.title = title.stringValue;
        }
        
        NSArray *links = [node elementsForName:@"link"];
        if (links.count > 0) {
            GDataXMLElement *link = [links objectAtIndex:0];
            feed.link = link.stringValue;
        }
        
        NSArray *pubDates = [node elementsForName:@"pubDate"];
        if (pubDates.count > 0) {
            GDataXMLElement *pubDate = [pubDates objectAtIndex:0];
            feed.pubDate = pubDate.stringValue;
        }

        [self.list addObject:feed];
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
    static NSString *CellIdentifier = @"HeadlinesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Feed *feed = [self.list objectAtIndex:indexPath.row];
    cell.textLabel.text = feed.title;
    cell.detailTextLabel.text = feed.pubDate;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feed *feed = [self.list objectAtIndex:indexPath.row];
    WebViewController *webview = [[WebViewController alloc] init];
    [webview setUrl:feed.link];
    [[self navigationController] pushViewController:webview animated:YES];
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
