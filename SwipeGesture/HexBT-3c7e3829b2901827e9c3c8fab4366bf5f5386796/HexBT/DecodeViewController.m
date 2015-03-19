//
//  DecodeViewController.m
//  HexBT
//
//  Created by Pan Ziyue on 6/9/13.
//  Copyright (c) 2013 Pan Ziyue. All rights reserved.
//

#import "DecodeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

#import "CommonObjCMethods.h"

@interface DecodeViewController ()

@end

@implementation DecodeViewController

@synthesize userInput, output;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Makes the text fields rounded
    userInput.placeholder=@"Input encoded message (make sure there is only 1 type of encoding)";
    output.placeholder=@"Output decoded message here (note that MD5 and SHA1 cannot be decoded)";
    
    // Sets the colors of the background
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
    
    //Set title text attributes
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    label.text = @"Decoder";
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    self.navigationItem.titleView = label;
    
    // Adds action to tap & dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // Adds action to swipe down & dismiss keyboard
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [swipeDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:swipeDown];
}

-(void)dismissKeyboard {
    [userInput resignFirstResponder];
}

//This will convert according to the language detected
-(IBAction)setType:(id)sender
{
    NSInteger type = [self detectType:[self isBase64Data:userInput.text] hexadecimal:[self isHexadecimal:userInput.text] binary:[self isBinary:userInput.text]];
    if ([userInput text].length<1) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error: No input!" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (type==0) {
        output.text=[CommonObjCMethods binToText:userInput.text];
    }
    else if (type==1) {
        output.text=[CommonObjCMethods hexToText:userInput.text];
    }
    else if (type==2) {
        output.text=[CommonObjCMethods base64Decode:userInput.text];
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error: Invalid input!" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        output.text=@"";
    }    
    [userInput resignFirstResponder];
}

-(IBAction)share:(id)sender
{
    if ([output hasText]) {
        [SVProgressHUD showWithStatus:@"Loading..."];
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            UIActivityViewController *actViewCtrl=[[UIActivityViewController alloc]initWithActivityItems:@[output.text] applicationActivities:nil];
            [self presentViewController:actViewCtrl animated:YES completion:^(void){
                [SVProgressHUD dismiss];
            }];
        });
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Nothing To Share!" message:nil delegate:nil cancelButtonTitle:@"Back" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(IBAction)pasteToTextView:(id)sender
{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    userInput.text = [pb string];
}

//This is the method to return an NSInteger accordingly
-(NSInteger)detectType:(BOOL)base64 hexadecimal:(BOOL)hex binary:(BOOL)binary
{
    //Make sure the checking of characters are in this order!
    if (binary) {
        return 0; //Type 0 means binary
    }
    else if (hex) {
        return 1; //Type 1 means hexadecimal
    }
    else if (base64) {
        return 2; //Type 2 means base64
    }
    else {
        return 3; //Type 3 is error/invalid text
    }
}

//Checking if an NSString is encoded in Base64
-(BOOL)isBase64Data:(NSString *)input
{
    input=[[input componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    if ([input length] % 4 == 0) {
        static NSCharacterSet *invertedBase64CharacterSet = nil;
        if (invertedBase64CharacterSet == nil) {
            invertedBase64CharacterSet = [[NSCharacterSet
                                           characterSetWithCharactersInString:
                                           @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="]
                                          invertedSet];
        }
        return [input rangeOfCharacterFromSet:invertedBase64CharacterSet options:NSLiteralSearch].location == NSNotFound;
    }
    return NO;
}

//Checking if an NSString is encoded in hexadecimal
-(BOOL)isHexadecimal:(NSString *)input
{
    NSString *moreText=[input uppercaseString];
    moreText=[[moreText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"1234567890ABCDEF"];
    set = [set invertedSet];
    NSRange range = [moreText rangeOfCharacterFromSet:set];
    
    if (range.location == NSNotFound&&moreText.length%2==0) //If you don't get any characters that are not in the hex set
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//Checking if an NSString is encoded in binary
-(BOOL)isBinary:(NSString *)input
{
    input=[[input componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"01"];
    set = [set invertedSet];
    NSRange range = [input rangeOfCharacterFromSet:set];
    
    if (range.location == NSNotFound&&input.length%8==0) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
