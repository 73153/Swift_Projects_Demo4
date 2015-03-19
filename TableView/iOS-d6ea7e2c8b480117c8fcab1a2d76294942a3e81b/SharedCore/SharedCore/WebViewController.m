//  Copyright 2010 Jonathan Steele
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)init
{
	self = [super init];
	if (self) {
        // Custom initialization
		self.hidesBottomBarWhenPushed = YES;
    }
	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setUrl:(NSString *)urlString
{
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
	self.view = webView;
	webView.delegate = self;
	webView.scalesPageToFit = YES;

	// load URL
	NSURL *webUrl = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:webUrl];
	[webView loadRequest:request];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

@end