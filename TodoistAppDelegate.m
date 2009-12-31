//
//  TodoistAppDelegate.m
//  Todoist
//
//  Created by Chris Hudson on 14/08/2009.
//  Copyright Xetius Services Ltd. 2009. All rights reserved.
//

#import "TodoistAppDelegate.h"
#import "RootViewController.h"
#import "JSON/JSON.h"

@implementation TodoistAppDelegate

@synthesize largeActivityIndicator;
@synthesize splashScreen;
@synthesize window;
@synthesize navigationController;
@synthesize engine;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    // Override point for customization after app launch    
	[self showSplashScreen:YES];
	[self showActivityIndicator:YES];
	
	engine = [[XDataEngine alloc] init];
	DMUserDetails* userDetails = [engine userDetailsWithDelegate:self];
	
	if (userDetails != nil) {
		[self dataDidCompleteForId:LOGIN_CONNECTION_ID];
	}
	else {
		[self showActivityIndicator:YES];
		[self showSplashScreen:YES];
	}
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[splashScreen release];
	[largeActivityIndicator release];
	
	[engine release]; 
	[super dealloc];
}

- (void)createLargeActivityIndicatorView {
	if (largeActivityIndicator == nil) {
		largeActivityIndicator = [[XActivityIndicator alloc] initWithFrame:CGRectMake(0,0,320,480)];
		[window addSubview:largeActivityIndicator];
	}
}

-(void)showActivityIndicator:(BOOL)show {
	[self showActivityIndicator:show withCenter:CGPointMake(160,240)];
}

-(void)showActivityIndicator:(BOOL)show withCenter:(CGPoint)point {
	if (largeActivityIndicator==nil) {
		[self createLargeActivityIndicatorView];
	}
	
	[largeActivityIndicator showActivityIndicator:show withCenter:point];
}

-(void) createSplashScreen
{
	if (splashScreen != nil)
	{
		[splashScreen autorelease];
	}
	
	splashScreen = [[SplashScreen alloc] initWithNibName:@"SplashScreen" bundle:nil];
	[window addSubview:splashScreen.view];
}

-(void) showSplashScreen:(BOOL) show
{
	if (splashScreen == nil)
	{
		[self createSplashScreen];
	}
	
	if (show)
	{
		if (splashScreen.view.alpha != 1) {
			[UIView beginAnimations:@"splash" context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
			[UIView setAnimationDuration:0.4];
			splashScreen.view.alpha=1;
			[UIView commitAnimations];		
		}
	}
	else
	{
		if (splashScreen.view.alpha != 0) {
			[UIView beginAnimations:@"splash" context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
			[UIView setAnimationDuration:0.4];
			splashScreen.view.alpha=0;
			[UIView commitAnimations];		
		}
	}
}

-(void) dataDidCompleteForId:(int) dataId {
	[self showActivityIndicator:NO];
	[self showSplashScreen:NO];
	
	RootViewController* viewController = [[RootViewController alloc] initWithStyle:UITableViewStyleGrouped];		
	[navigationController pushViewController:viewController animated:NO];
	[viewController release];
	
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];		
}

@end

