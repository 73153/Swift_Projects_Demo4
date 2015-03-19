//
//  ViewController.m
//  228_PresetationController
//
//  Created by llv22 on 6/28/14.
//  Copyright (c) 2014 llv22. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController (){
    int index;
}

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if(!self.people){
        self.people = @[@"Dima", @"Johannes", @"Jason", @"Gordie", @"Jacob", @"Andy", @"Nic", @"Jim", @"ShuChen", @"Toby", @"Debbie", @"Justin", @"Karl", @"Chris",  @"Marian", @"Ben", @"Colin", @"Morgan", @"Bruce", @"Sophia", @"David", @"Jordan", @"Bill", @"Ian"];
    }
    self.lableItem.text = self.people[self->index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)popupForPeople:(id)sender{
    // see http://stackoverflow.com/questions/20490809/instantiating-uitableviewcontroller-in-appdelegate-to-work-with-storyboard-ios
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TableViewController* contentController = (TableViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MyTableView"];
    contentController.modalPresentationStyle = UIModalPresentationPopover;
    contentController.parentVC = self;
    
    UIPopoverPresentationController *popPC = contentController.popoverPresentationController;
    popPC.sourceView = self.view;
    popPC.barButtonItem = (UIBarButtonItem*)sender;
    popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popPC.delegate = self;
    [self presentViewController:contentController animated:YES completion:^(){
        contentController.title = self.lableItem.text;
    }];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationFullScreen;
}

// see https://devforums.apple.com/message/1022241#1022241
- (UIViewController *) presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style{
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller.presentedViewController];
    return navController;
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    NSLog(@"dismiss");
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    NSLog(@"should dismiss");
    return YES;
}

@end
