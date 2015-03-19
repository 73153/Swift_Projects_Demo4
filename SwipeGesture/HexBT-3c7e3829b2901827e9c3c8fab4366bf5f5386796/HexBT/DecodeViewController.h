//
//  DecodeViewController.h
//  HexBT
//
//  Created by Pan Ziyue on 6/9/13.
//  Copyright (c) 2013 Pan Ziyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

@interface DecodeViewController : UITableViewController
{
    IBOutlet GCPlaceholderTextView *userInput;
    IBOutlet GCPlaceholderTextView *output;
}

@property (strong,nonatomic) IBOutlet GCPlaceholderTextView *userInput;
@property (strong,nonatomic) IBOutlet GCPlaceholderTextView *output;

-(BOOL)isBase64Data:(NSString *)input;
-(BOOL)isHexadecimal:(NSString *)input;
-(BOOL)isBinary:(NSString *)input;
-(NSInteger)detectType:(BOOL)base64 hexadecimal:(BOOL)hex binary:(BOOL)binary;

-(IBAction)setType:(id)sender;
-(IBAction)share:(id)sender;
-(IBAction)pasteToTextView:(id)sender;

@end
