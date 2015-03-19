//
//  ViewController.h
//  228_PresetationController
//
//  Created by llv22 on 6/28/14.
//  Copyright (c) 2014 llv22. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) IBOutlet UIBarButtonItem* rightButtonItem;
@property (nonatomic, strong) IBOutlet UILabel* lableItem;

@property (nonatomic, strong) NSArray* people;

- (IBAction)popupForPeople:(id)sender;

@end

