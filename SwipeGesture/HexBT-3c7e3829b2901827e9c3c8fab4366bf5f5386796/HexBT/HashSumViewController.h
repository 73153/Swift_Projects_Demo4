//
//  HashSumViewController.h
//  HexBT
//
//  Created by Pan Ziyue on 10/8/13.
//  Copyright (c) 2013 Pan Ziyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

@interface HashSumViewController : UITableViewController <UITextViewDelegate>
{
    IBOutlet GCPlaceholderTextView *textToHash;
    IBOutlet UITextView *md5Disp;
    IBOutlet UITextView *sha1Disp;
}

@property (strong,nonatomic) IBOutlet GCPlaceholderTextView *textToHash;
@property (strong,nonatomic) IBOutlet UITextView *md5Disp;
@property (strong,nonatomic) IBOutlet UITextView *sha1Disp;

-(NSString*)sha1:(NSString*)input;
-(NSString*)md5:(NSString*)input;

-(NSString*)sha1File:(NSData*)input;
-(NSString*)md5File:(NSData*)input;

-(IBAction)convert:(id)sender;
-(IBAction)share:(id)sender;

@end
