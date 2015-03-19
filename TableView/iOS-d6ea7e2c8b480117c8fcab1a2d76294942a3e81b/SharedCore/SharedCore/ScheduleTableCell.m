//
//  ScheduleTableCell.m
//  SharedCore
//
//  Created by Jonathan Steele on 5/19/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

#import "ScheduleTableCell.h"
#import "Event.h"

@interface ScheduleTableCell()

@property (nonatomic, weak) IBOutlet UILabel *homeTeam;
@property (nonatomic, weak) IBOutlet UILabel *homeTeamScore;
@property (nonatomic, weak) IBOutlet UILabel *awayTeam;
@property (nonatomic, weak) IBOutlet UILabel *awayTeamScore;
@property (nonatomic, weak) IBOutlet UILabel *date;

@property (nonatomic, readonly) NSDateFormatter *dateFormatter;

@end

@implementation ScheduleTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureWithEvents:(Event *)event
{
    self.homeTeam.text = event.homeTeam;
    self.homeTeamScore.text = event.homeScore;
    self.awayTeam.text = event.awayTeam;
    self.awayTeamScore.text = event.awayScore;
    self.date.text = [self.dateFormatter stringFromDate:event.date];
}

// On-demand initializer for read-only property.
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd 'at' hh:mma"];
    }
    return dateFormatter;
}

@end
