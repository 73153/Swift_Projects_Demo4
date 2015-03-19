//
//  CommonObjCMethods.m
//  HexBT
//
//  Created by Pan Ziyue on 11/6/14.
//  Copyright (c) 2014 Pan Ziyue. All rights reserved.
//

#import "CommonObjCMethods.h"
#import "MNNSStringWithUnichar.h"
#import "NSData+Base64.h"

@implementation CommonObjCMethods

+(NSString *)textToBin:(NSString *)text
{
    NSString *value=[[NSString alloc]init]; //The alloc init is VERY IMPORTANT! It makes sure it's even properly present in the memory and not deallocated for no good reason
    NSString *strChar;
    bool blank=true;
    
    while (blank)
    {
        for (int x=0; x<text.length; x++)
        {
            strChar=[MNNSStringWithUnichar stringWithUnichar:[text characterAtIndex:x]];
            //For caps
            if ([strChar isEqualToString:@"A"]) { //For A
                value=[value stringByAppendingString:@"01000001"];
            }
            else if ([strChar isEqualToString:@"B"]) { //For B
                value=[value stringByAppendingString:@"01000010"];
            }
            else if ([strChar isEqualToString:@"C"]) { //For C
                value=[value stringByAppendingString:@"01000011"];
            }
            else if ([strChar isEqualToString:@"D"]) {
                value=[value stringByAppendingString:@"01000100"];
            }
            else if ([strChar isEqualToString:@"E"]) {
                value=[value stringByAppendingString:@"01000101"];
            }
            else if ([strChar isEqualToString:@"F"]) {
                value=[value stringByAppendingString:@"01000110"];
            }
            else if ([strChar isEqualToString:@"G"]) {
                value=[value stringByAppendingString:@"01000111"];
            }
            else if ([strChar isEqualToString:@"H"]) {
                value=[value stringByAppendingString:@"01001000"];
            }
            else if ([strChar isEqualToString:@"I"]) {
                value=[value stringByAppendingString:@"01001001"];
            }
            else if ([strChar isEqualToString:@"J"]) {
                value=[value stringByAppendingString:@"01001010"];
            }
            else if ([strChar isEqualToString:@"K"]) {
                value=[value stringByAppendingString:@"01001011"];
            }
            else if ([strChar isEqualToString:@"L"]) {
                value=[value stringByAppendingString:@"01001100"];
            }
            else if ([strChar isEqualToString:@"M"]) {
                value=[value stringByAppendingString:@"01001101"];
            }
            else if ([strChar isEqualToString:@"N"]) {
                value=[value stringByAppendingString:@"01001110"];
            }
            else if ([strChar isEqualToString:@"O"]) {
                value=[value stringByAppendingString:@"01001111"];
            }
            else if ([strChar isEqualToString:@"P"]) {
                value=[value stringByAppendingString:@"01010000"];
            }
            else if ([strChar isEqualToString:@"Q"]) {
                value=[value stringByAppendingString:@"01010001"];
            }
            else if ([strChar isEqualToString:@"R"]) {
                value=[value stringByAppendingString:@"01010010"];
            }
            else if ([strChar isEqualToString:@"S"]) {
                value=[value stringByAppendingString:@"01010011"];
            }
            else if ([strChar isEqualToString:@"T"]) {
                value=[value stringByAppendingString:@"01010100"];
            }
            else if ([strChar isEqualToString:@"U"]) {
                value=[value stringByAppendingString:@"01010101"];
            }
            else if ([strChar isEqualToString:@"V"]) {
                value=[value stringByAppendingString:@"01010110"];
            }
            else if ([strChar isEqualToString:@"W"]) {
                value=[value stringByAppendingString:@"01010111"];
            }
            else if ([strChar isEqualToString:@"X"]) {
                value=[value stringByAppendingString:@"01011000"];
            }
            else if ([strChar isEqualToString:@"Y"]) {
                value=[value stringByAppendingString:@"01011001"];
            }
            else if ([strChar isEqualToString:@"Z"]) {
                value=[value stringByAppendingString:@"01011010"];
            }
            //Now onto small case ones
            else if ([strChar isEqualToString:@"a"]) {
                value=[value stringByAppendingString:@"01100001"];
            }
            else if ([strChar isEqualToString:@"b"]) {
                value=[value stringByAppendingString:@"01100010"];
            }
            else if ([strChar isEqualToString:@"c"]) {
                value=[value stringByAppendingString:@"01100011"];
            }
            else if ([strChar isEqualToString:@"d"]) {
                value=[value stringByAppendingString:@"01100100"];
            }
            else if ([strChar isEqualToString:@"e"]) {
                value=[value stringByAppendingString:@"01100101"];
            }
            else if ([strChar isEqualToString:@"f"]) {
                value=[value stringByAppendingString:@"01100110"];
            }
            else if ([strChar isEqualToString:@"g"]) {
                value=[value stringByAppendingString:@"01100111"];
            }
            else if ([strChar isEqualToString:@"h"]) {
                value=[value stringByAppendingString:@"01101000"];
            }
            else if ([strChar isEqualToString:@"i"]) {
                value=[value stringByAppendingString:@"01101001"];
            }
            else if ([strChar isEqualToString:@"j"]) {
                value=[value stringByAppendingString:@"01101010"];
            }
            else if ([strChar isEqualToString:@"k"]) {
                value=[value stringByAppendingString:@"01101011"];
            }
            else if ([strChar isEqualToString:@"l"]) {
                value=[value stringByAppendingString:@"01101100"];
            }
            else if ([strChar isEqualToString:@"m"]) {
                value=[value stringByAppendingString:@"01101101"];
            }
            else if ([strChar isEqualToString:@"n"]) {
                value=[value stringByAppendingString:@"01101110"];
            }
            else if ([strChar isEqualToString:@"o"]) {
                value=[value stringByAppendingString:@"01101111"];
            }
            else if ([strChar isEqualToString:@"p"]) {
                value=[value stringByAppendingString:@"01110000"];
            }
            else if ([strChar isEqualToString:@"q"]) {
                value=[value stringByAppendingString:@"01110001"];
            }
            else if ([strChar isEqualToString:@"r"]) {
                value=[value stringByAppendingString:@"01110010"];
            }
            else if ([strChar isEqualToString:@"s"]) {
                value=[value stringByAppendingString:@"01110011"];
            }
            else if ([strChar isEqualToString:@"t"]) {
                value=[value stringByAppendingString:@"01110100"];
            }
            else if ([strChar isEqualToString:@"u"]) {
                value=[value stringByAppendingString:@"01110101"];
            }
            else if ([strChar isEqualToString:@"v"]) {
                value=[value stringByAppendingString:@"01110110"];
            }
            else if ([strChar isEqualToString:@"w"]) {
                value=[value stringByAppendingString:@"01110111"];
            }
            else if ([strChar isEqualToString:@"x"]) {
                value=[value stringByAppendingString:@"01111000"];
            }
            else if ([strChar isEqualToString:@"y"]) {
                value=[value stringByAppendingString:@"01111001"];
            }
            else if ([strChar isEqualToString:@"z"]) {
                value=[value stringByAppendingString:@"01111010"];
            }
            else if ([strChar isEqualToString:@" "]) {
                value=[value stringByAppendingString:@"00100000"];
            }
            else if ([strChar isEqualToString:@"1"]) {
                value=[value stringByAppendingString:@"00110001"];
            }
            else if ([strChar isEqualToString:@"2"]) {
                value=[value stringByAppendingString:@"00110010"];
            }
            else if ([strChar isEqualToString:@"3"]) {
                value=[value stringByAppendingString:@"00110010"];
            }
            else if ([strChar isEqualToString:@"4"]) {
                value=[value stringByAppendingString:@"00110100"];
            }
            else if ([strChar isEqualToString:@"5"]) {
                value=[value stringByAppendingString:@"00110101"];
            }
            else if ([strChar isEqualToString:@"6"]) {
                value=[value stringByAppendingString:@"00110110"];
            }
            else if ([strChar isEqualToString:@"7"]) {
                value=[value stringByAppendingString:@"00110111"];
            }
            else if ([strChar isEqualToString:@"8"]) {
                value=[value stringByAppendingString:@"00111000"];
            }
            else if ([strChar isEqualToString:@"9"]) {
                value=[value stringByAppendingString:@"00111001"];
            }
            else if ([strChar isEqualToString:@"0"]) {
                value=[value stringByAppendingString:@"00110000"];
            }
            else if ([strChar isEqualToString:@"-"]) {
                value=[value stringByAppendingString:@"00101101"];
            }
            else if ([strChar isEqualToString:@"/"]) {
                value=[value stringByAppendingString:@"00101111"];
            }
            else if ([strChar isEqualToString:@":"]) {
                value=[value stringByAppendingString:@"00111010"];
            }
            else if ([strChar isEqualToString:@";"]) {
                value=[value stringByAppendingString:@"00111011"];
            }
            else if ([strChar isEqualToString:@"("])
            {
                value=[value stringByAppendingString:@"00101000"];
            }
            else if ([strChar isEqualToString:@")"])
            {
                value=[value stringByAppendingString:@"00101001"];
            }
            else if ([strChar isEqualToString:@"$"])
            {
                value=[value stringByAppendingString:@"00100100"];
            }
            else if ([strChar isEqualToString:@"&"])
            {
                value=[value stringByAppendingString:@"00100110"];
            }
            else if ([strChar isEqualToString:@"@"])
            {
                value=[value stringByAppendingString:@"01000000"];
            }
            else if ([strChar isEqualToString:@"\""]) //The " character needs escaping
            {
                value=[value stringByAppendingString:@"00100010"];
            }
            else if ([strChar isEqualToString:@"."])
            {
                value=[value stringByAppendingString:@"00101110"];
            }
            else if ([strChar isEqualToString:@","])
            {
                value=[value stringByAppendingString:@"00101100"];
            }
            else if ([strChar isEqualToString:@"?"])
            {
                value=[value stringByAppendingString:@"00111111"];
            }
            else if ([strChar isEqualToString:@"!"])
            {
                value=[value stringByAppendingString:@"00100001"];
            }
            else if ([strChar isEqualToString:@"'"])
            {
                value=[value stringByAppendingString:@"00100001"];
            }
            else if ([strChar isEqualToString:@"["])
            {
                value=[value stringByAppendingString:@"01011011"];
            }
            else if ([strChar isEqualToString:@"]"])
            {
                value=[value stringByAppendingString:@"01011101"];
            }
            else if ([strChar isEqualToString:@"{"])
            {
                value=[value stringByAppendingString:@"01111011"];
            }
            else if ([strChar isEqualToString:@"}"])
            {
                value=[value stringByAppendingString:@"01111101"];
            }
            else if ([strChar isEqualToString:@"#"])
            {
                value=[value stringByAppendingString:@"00100011"];
            }
            else if ([strChar isEqualToString:@"\%"])
            {
                value=[value stringByAppendingString:@"00100101"];
            }
            else if ([strChar isEqualToString:@"^"])
            {
                value=[value stringByAppendingString:@"01011110"];
            }
            else if ([strChar isEqualToString:@"*"])
            {
                value=[value stringByAppendingString:@"00101010"];
            }
            else if ([strChar isEqualToString:@"+"])
            {
                value=[value stringByAppendingString:@"00101011"];
            }
            else if ([strChar isEqualToString:@"="])
            {
                value=[value stringByAppendingString:@"00111101"];
            }
            else if ([strChar isEqualToString:@"_"])
            {
                value=[value stringByAppendingString:@"01011111"];
            }
            else if ([strChar isEqualToString:@"\\"])
            {
                value=[value stringByAppendingString:@"01011100"];
            }
            else if ([strChar isEqualToString:@"|"])
            {
                value=[value stringByAppendingString:@"01111100"];
            }
            else if ([strChar isEqualToString:@"~"])
            {
                value=[value stringByAppendingString:@"01111110"];
            }
            else if ([strChar isEqualToString:@"<"])
            {
                value=[value stringByAppendingString:@"00111100"];
            }
            else if ([strChar isEqualToString:@">"])
            {
                value=[value stringByAppendingString:@"00111110"];
            }
            else if ([strChar isEqualToString:@"£"])
            {
                value=[value stringByAppendingString:@"10011100"];
            }
            else if ([strChar isEqualToString:@"¥"])
            {
                value=[value stringByAppendingString:@"10011101"];
            }
            else if ([strChar isEqualToString:@"•"])
            {
                value=[value stringByAppendingString:@"11111001"];
            }
            else if ([strChar isEqualToString:@"€"])
            {
                value=[value stringByAppendingString:@"10000000"];
            }
            else if ([strChar isEqualToString:@"\n"])
            {
                value=[value stringByAppendingString:@"00001010"];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error: Invalid input, no non-ASCII characters are allowed" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
                value=@"";
                blank=false;
            }
            
        }
        blank=false;
    }
    return value;
}

+(NSString *)binToText:(NSString *)text
{
    NSString *value=[[NSString alloc]init];
    NSString *strChar;
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    if (text.length%8==0) {
        for (int i=0; i<text.length; i++) {
            if (i%8==0) {
                NSString *ch = [text substringWithRange:NSMakeRange(i, 8)];
                [array addObject:ch];
            }
        }
    }
    else
    {
        value=@"";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error: Invalid input!" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    bool blank=true;
    
    while (blank)
    {
        for (int x=0; x<[array count]; x++)
        {
            strChar=array[x];
            //For caps
            if ([strChar isEqualToString:@"01000001"]) { //For A
                value=[value stringByAppendingString:@"A"];
            }
            else if ([strChar isEqualToString:@"01000010"]) { //For B
                value=[value stringByAppendingString:@"B"];
            }
            else if ([strChar isEqualToString:@"01000011"]) { //For C
                value=[value stringByAppendingString:@"C"];
            }
            else if ([strChar isEqualToString:@"01000100"]) {
                value=[value stringByAppendingString:@"D"];
            }
            else if ([strChar isEqualToString:@"01000101"]) {
                value=[value stringByAppendingString:@"E"];
            }
            else if ([strChar isEqualToString:@"01000110"]) {
                value=[value stringByAppendingString:@"F"];
            }
            else if ([strChar isEqualToString:@"01000111"]) {
                value=[value stringByAppendingString:@"G"];
            }
            else if ([strChar isEqualToString:@"01001000"]) {
                value=[value stringByAppendingString:@"H"];
            }
            else if ([strChar isEqualToString:@"01001001"]) {
                value=[value stringByAppendingString:@"I"];
            }
            else if ([strChar isEqualToString:@"01001010"]) {
                value=[value stringByAppendingString:@"J"];
            }
            else if ([strChar isEqualToString:@"01001011"]) {
                value=[value stringByAppendingString:@"K"];
            }
            else if ([strChar isEqualToString:@"01001100"]) {
                value=[value stringByAppendingString:@"L"];
            }
            else if ([strChar isEqualToString:@"01001101"]) {
                value=[value stringByAppendingString:@"M"];
            }
            else if ([strChar isEqualToString:@"01001110"]) {
                value=[value stringByAppendingString:@"N"];
            }
            else if ([strChar isEqualToString:@"01001111"]) {
                value=[value stringByAppendingString:@"O"];
            }
            else if ([strChar isEqualToString:@"01010000"]) {
                value=[value stringByAppendingString:@"P"];
            }
            else if ([strChar isEqualToString:@"01010001"]) {
                value=[value stringByAppendingString:@"Q"];
            }
            else if ([strChar isEqualToString:@"01010010"]) {
                value=[value stringByAppendingString:@"R"];
            }
            else if ([strChar isEqualToString:@"01010011"]) {
                value=[value stringByAppendingString:@"S"];
            }
            else if ([strChar isEqualToString:@"01010100"]) {
                value=[value stringByAppendingString:@"T"];
            }
            else if ([strChar isEqualToString:@"01010101"]) {
                value=[value stringByAppendingString:@"U"];
            }
            else if ([strChar isEqualToString:@"01010110"]) {
                value=[value stringByAppendingString:@"V"];
            }
            else if ([strChar isEqualToString:@"01010111"]) {
                value=[value stringByAppendingString:@"W"];
            }
            else if ([strChar isEqualToString:@"01011000"]) {
                value=[value stringByAppendingString:@"X"];
            }
            else if ([strChar isEqualToString:@"01011001"]) {
                value=[value stringByAppendingString:@"Y"];
            }
            else if ([strChar isEqualToString:@"01011010"]) {
                value=[value stringByAppendingString:@"Z"];
            }
            //Now onto small case ones
            else if ([strChar isEqualToString:@"01100001"]) {
                value=[value stringByAppendingString:@"a"];
            }
            else if ([strChar isEqualToString:@"01100010"]) {
                value=[value stringByAppendingString:@"b"];
            }
            else if ([strChar isEqualToString:@"01100011"]) {
                value=[value stringByAppendingString:@"c"];
            }
            else if ([strChar isEqualToString:@"01100100"]) {
                value=[value stringByAppendingString:@"d"];
            }
            else if ([strChar isEqualToString:@"01100101"]) {
                value=[value stringByAppendingString:@"e"];
            }
            else if ([strChar isEqualToString:@"01100110"]) {
                value=[value stringByAppendingString:@"f"];
            }
            else if ([strChar isEqualToString:@"01100111"]) {
                value=[value stringByAppendingString:@"g"];
            }
            else if ([strChar isEqualToString:@"01101000"]) {
                value=[value stringByAppendingString:@"h"];
            }
            else if ([strChar isEqualToString:@"01101001"]) {
                value=[value stringByAppendingString:@"i"];
            }
            else if ([strChar isEqualToString:@"01101010"]) {
                value=[value stringByAppendingString:@"j"];
            }
            else if ([strChar isEqualToString:@"01101011"]) {
                value=[value stringByAppendingString:@"k"];
            }
            else if ([strChar isEqualToString:@"01101100"]) {
                value=[value stringByAppendingString:@"l"];
            }
            else if ([strChar isEqualToString:@"01101101"]) {
                value=[value stringByAppendingString:@"m"];
            }
            else if ([strChar isEqualToString:@"01101110"]) {
                value=[value stringByAppendingString:@"n"];
            }
            else if ([strChar isEqualToString:@"01101111"]) {
                value=[value stringByAppendingString:@"o"];
            }
            else if ([strChar isEqualToString:@"01110000"]) {
                value=[value stringByAppendingString:@"p"];
            }
            else if ([strChar isEqualToString:@"01110001"]) {
                value=[value stringByAppendingString:@"q"];
            }
            else if ([strChar isEqualToString:@"01110010"]) {
                value=[value stringByAppendingString:@"r"];
            }
            else if ([strChar isEqualToString:@"01110011"]) {
                value=[value stringByAppendingString:@"s"];
            }
            else if ([strChar isEqualToString:@"01110100"]) {
                value=[value stringByAppendingString:@"t"];
            }
            else if ([strChar isEqualToString:@"01110101"]) {
                value=[value stringByAppendingString:@"u"];
            }
            else if ([strChar isEqualToString:@"01110110"]) {
                value=[value stringByAppendingString:@"v"];
            }
            else if ([strChar isEqualToString:@"01110111"]) {
                value=[value stringByAppendingString:@"w"];
            }
            else if ([strChar isEqualToString:@"01111000"]) {
                value=[value stringByAppendingString:@"x"];
            }
            else if ([strChar isEqualToString:@"01111001"]) {
                value=[value stringByAppendingString:@"y"];
            }
            else if ([strChar isEqualToString:@"01111010"]) {
                value=[value stringByAppendingString:@"z"];
            }
            else if ([strChar isEqualToString:@"00100000"]) {
                value=[value stringByAppendingString:@" "];
            }
            else if ([strChar isEqualToString:@"00110001"]) {
                value=[value stringByAppendingString:@"1"];
            }
            else if ([strChar isEqualToString:@"00110010"]) {
                value=[value stringByAppendingString:@"2"];
            }
            else if ([strChar isEqualToString:@"00110010"]) {
                value=[value stringByAppendingString:@"3"];
            }
            else if ([strChar isEqualToString:@"00110100"]) {
                value=[value stringByAppendingString:@"4"];
            }
            else if ([strChar isEqualToString:@"00110101"]) {
                value=[value stringByAppendingString:@"5"];
            }
            else if ([strChar isEqualToString:@"00110110"]) {
                value=[value stringByAppendingString:@"6"];
            }
            else if ([strChar isEqualToString:@"00110111"]) {
                value=[value stringByAppendingString:@"7"];
            }
            else if ([strChar isEqualToString:@"00111000"]) {
                value=[value stringByAppendingString:@"8"];
            }
            else if ([strChar isEqualToString:@"00111001"]) {
                value=[value stringByAppendingString:@"9"];
            }
            else if ([strChar isEqualToString:@"00110000"]) {
                value=[value stringByAppendingString:@"0"];
            }
            else if ([strChar isEqualToString:@"00101101"]) {
                value=[value stringByAppendingString:@"-"];
            }
            else if ([strChar isEqualToString:@"00101111"]) {
                value=[value stringByAppendingString:@"/"];
            }
            else if ([strChar isEqualToString:@"00111010"]) {
                value=[value stringByAppendingString:@":"];
            }
            else if ([strChar isEqualToString:@"00111011"]) {
                value=[value stringByAppendingString:@";"];
            }
            else if ([strChar isEqualToString:@"00101000"])
            {
                value=[value stringByAppendingString:@"("];
            }
            else if ([strChar isEqualToString:@"00101001"])
            {
                value=[value stringByAppendingString:@")"];
            }
            else if ([strChar isEqualToString:@"00100100"])
            {
                value=[value stringByAppendingString:@"$"];
            }
            else if ([strChar isEqualToString:@"00100110"])
            {
                value=[value stringByAppendingString:@"&"];
            }
            else if ([strChar isEqualToString:@"01000000"])
            {
                value=[value stringByAppendingString:@"@"];
            }
            else if ([strChar isEqualToString:@"00100010"]) //The " character needs escaping
            {
                value=[value stringByAppendingString:@"\""];
            }
            else if ([strChar isEqualToString:@"00101110"])
            {
                value=[value stringByAppendingString:@"."];
            }
            else if ([strChar isEqualToString:@"00101100"])
            {
                value=[value stringByAppendingString:@","];
            }
            else if ([strChar isEqualToString:@"00111111"])
            {
                value=[value stringByAppendingString:@"?"];
            }
            else if ([strChar isEqualToString:@"00100001"])
            {
                value=[value stringByAppendingString:@"!"];
            }
            else if ([strChar isEqualToString:@"00100111"])
            {
                value=[value stringByAppendingString:@"'"];
            }
            else if ([strChar isEqualToString:@"01011011"])
            {
                value=[value stringByAppendingString:@"["];
            }
            else if ([strChar isEqualToString:@"01011101"])
            {
                value=[value stringByAppendingString:@"]"];
            }
            else if ([strChar isEqualToString:@"01111011"])
            {
                value=[value stringByAppendingString:@"{"];
            }
            else if ([strChar isEqualToString:@"01111101"])
            {
                value=[value stringByAppendingString:@"}"];
            }
            else if ([strChar isEqualToString:@"00100011"])
            {
                value=[value stringByAppendingString:@"#"];
            }
            else if ([strChar isEqualToString:@"00100101"])
            {
                value=[value stringByAppendingString:@"\%"];
            }
            else if ([strChar isEqualToString:@"01011110"])
            {
                value=[value stringByAppendingString:@"^"];
            }
            else if ([strChar isEqualToString:@"00101010"])
            {
                value=[value stringByAppendingString:@"*"];
            }
            else if ([strChar isEqualToString:@"00101011"])
            {
                value=[value stringByAppendingString:@"+"];
            }
            else if ([strChar isEqualToString:@"00111101"])
            {
                value=[value stringByAppendingString:@"="];
            }
            else if ([strChar isEqualToString:@"01011111"])
            {
                value=[value stringByAppendingString:@"_"];
            }
            else if ([strChar isEqualToString:@"01011100"])
            {
                value=[value stringByAppendingString:@"\\"];
            }
            else if ([strChar isEqualToString:@"01111100"])
            {
                value=[value stringByAppendingString:@"|"];
            }
            else if ([strChar isEqualToString:@"01111110"])
            {
                value=[value stringByAppendingString:@"~"];
            }
            else if ([strChar isEqualToString:@"00111100"])
            {
                value=[value stringByAppendingString:@"<"];
            }
            else if ([strChar isEqualToString:@"00111110"])
            {
                value=[value stringByAppendingString:@">"];
            }
            else if ([strChar isEqualToString:@"10011100"])
            {
                value=[value stringByAppendingString:@"£"];
            }
            else if ([strChar isEqualToString:@"10011101"])
            {
                value=[value stringByAppendingString:@"¥"];
            }
            else if ([strChar isEqualToString:@"11111001"])
            {
                value=[value stringByAppendingString:@"•"];
            }
            else if ([strChar isEqualToString:@"10000000"])
            {
                value=[value stringByAppendingString:@"€"];
            }
            else if ([strChar isEqualToString:@"00001010"])
            {
                value=[value stringByAppendingString:@"\n"];
            }
            else
            {
                value=@"";
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error: Invalid input!" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
                blank=false;
            }
        }
        blank=false;
    }
    return value;
}

+(NSString *)textToHex:(NSString *)text
{
    //The CSIMUX converter
    NSString *toBeConverted=[self textToBin:text];
    
    int sets=(int)toBeConverted.length/4;
    NSString *hexR=[[NSString alloc]init];
    bool blank=true;
    NSString *binSet=[[NSString alloc]init];
    NSString *binSet1;
    NSString *binSet2;
    NSString *binSet3;
    NSString *binSet4;
    
    while (blank) {
        if (sets%1==0) {
            for (int x=0; x<sets; x++) {
                binSet1=[MNNSStringWithUnichar stringWithUnichar:[toBeConverted characterAtIndex:x*4]];
                binSet2=[MNNSStringWithUnichar stringWithUnichar:[toBeConverted characterAtIndex:x*4+1]];
                binSet3=[MNNSStringWithUnichar stringWithUnichar:[toBeConverted characterAtIndex:x*4+2]];
                binSet4=[MNNSStringWithUnichar stringWithUnichar:[toBeConverted characterAtIndex:x*4+3]];
                binSet=[binSet stringByAppendingString:binSet1];
                binSet=[binSet stringByAppendingString:binSet2];
                binSet=[binSet stringByAppendingString:binSet3];
                binSet=[binSet stringByAppendingString:binSet4];
                binSet=[binSet stringByAppendingString:@"/"];
                
                blank=false;
            }
        }
        else
        {
            blank=false;
        }
    }
    NSArray *binArray=[binSet componentsSeparatedByString:@"/"];
    for (int x=0; x<[binArray count]; x++) {
        if ([binArray[x] isEqualToString:@"0000"]) {
            hexR=[hexR stringByAppendingString:@"0"];
        }
        else if ([binArray[x] isEqualToString:@"0001"]) {
            hexR=[hexR stringByAppendingString:@"1"];
        }
        else if ([binArray[x] isEqualToString:@"0010"]) {
            hexR=[hexR stringByAppendingString:@"2"];
        }
        else if ([binArray[x] isEqualToString:@"0011"]) {
            hexR=[hexR stringByAppendingString:@"3"];
        }
        else if ([binArray[x] isEqualToString:@"0100"]) {
            hexR=[hexR stringByAppendingString:@"4"];
        }
        else if ([binArray[x] isEqualToString:@"0101"]) {
            hexR=[hexR stringByAppendingString:@"5"];
        }
        else if ([binArray[x] isEqualToString:@"0110"]) {
            hexR=[hexR stringByAppendingString:@"6"];
        }
        else if ([binArray[x] isEqualToString:@"0111"]) {
            hexR=[hexR stringByAppendingString:@"7"];
        }
        else if ([binArray[x] isEqualToString:@"1000"]) {
            hexR=[hexR stringByAppendingString:@"8"];
        }
        else if ([binArray[x] isEqualToString:@"1001"]) {
            hexR=[hexR stringByAppendingString:@"9"];
        }
        else if ([binArray[x] isEqualToString:@"1010"]) {
            hexR=[hexR stringByAppendingString:@"A"];
        }
        else if ([binArray[x] isEqualToString:@"1011"]) {
            hexR=[hexR stringByAppendingString:@"B"];
        }
        else if ([binArray[x] isEqualToString:@"1100"]) {
            hexR=[hexR stringByAppendingString:@"C"];
        }
        else if ([binArray[x] isEqualToString:@"1101"]) {
            hexR=[hexR stringByAppendingString:@"D"];
        }
        else if ([binArray[x] isEqualToString:@"1110"]) {
            hexR=[hexR stringByAppendingString:@"E"];
        }
        else if ([binArray[x] isEqualToString:@"1111"]) {
            hexR=[hexR stringByAppendingString:@"F"];
        }
    }
    return hexR;
}

+(NSString *)hexToText:(NSString *)text
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSString *moreText=[text uppercaseString];
    NSString *result=[[NSString alloc]init];
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"1234567890ABCDEF"];
    set = [set invertedSet];
    NSRange range = [moreText rangeOfCharacterFromSet:set];
    
    if (range.location != NSNotFound) //Catch the error here, regarding bad input
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error: Invalid hexadecimal characters" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        for (int i=0; i<moreText.length; i++) {
            [array addObject:[MNNSStringWithUnichar stringWithUnichar:[moreText characterAtIndex:i]]];
        }
        NSString *binary=[[NSString alloc]init];
        for (int x=0; x<[array count]; x++) {
            if ([array[x] isEqualToString:@"0"]) {
                binary=[binary stringByAppendingString:@"0000"];
            }
            else if ([array[x] isEqualToString:@"1"]) {
                binary=[binary stringByAppendingString:@"0001"];
            }
            else if ([array[x] isEqualToString:@"2"]) {
                binary=[binary stringByAppendingString:@"0010"];
            }
            else if ([array[x] isEqualToString:@"3"]) {
                binary=[binary stringByAppendingString:@"0011"];
            }
            else if ([array[x] isEqualToString:@"4"]) {
                binary=[binary stringByAppendingString:@"0100"];
            }
            else if ([array[x] isEqualToString:@"5"]) {
                binary=[binary stringByAppendingString:@"0101"];
            }
            else if ([array[x] isEqualToString:@"6"]) {
                binary=[binary stringByAppendingString:@"0110"];
            }
            else if ([array[x] isEqualToString:@"7"]) {
                binary=[binary stringByAppendingString:@"0111"];
            }
            else if ([array[x] isEqualToString:@"8"]) {
                binary=[binary stringByAppendingString:@"1000"];
            }
            else if ([array[x] isEqualToString:@"9"]) {
                binary=[binary stringByAppendingString:@"1001"];
            }
            else if ([array[x] isEqualToString:@"A"]) {
                binary=[binary stringByAppendingString:@"1010"];
            }
            else if ([array[x] isEqualToString:@"B"]) {
                binary=[binary stringByAppendingString:@"1011"];
            }
            else if ([array[x] isEqualToString:@"C"]) {
                binary=[binary stringByAppendingString:@"1100"];
            }
            else if ([array[x] isEqualToString:@"D"]) {
                binary=[binary stringByAppendingString:@"1101"];
            }
            else if ([array[x] isEqualToString:@"E"]) {
                binary=[binary stringByAppendingString:@"1110"];
            }
            else if ([array[x] isEqualToString:@"F"]) {
                binary=[binary stringByAppendingString:@"1111"];
            }
        }
        result= [self binToText:binary];
    }
    return result;
}

+(NSString *)base64Encode:(NSString *)plainText
{
    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainTextData base64EncodedString];
    return base64String;
}

+(NSString *)base64Decode:(NSString *)base64String
{
    NSData *plainTextData = [NSData dataFromBase64String:base64String];
    NSString *plainText = [[NSString alloc] initWithData:plainTextData encoding:NSUTF8StringEncoding];
    return plainText;
}

@end
