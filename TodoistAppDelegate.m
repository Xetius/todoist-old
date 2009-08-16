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
@synthesize operationQueue;
@synthesize userDetails;
@synthesize isLoggedIn;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	operationQueue = [[NSOperationQueue alloc] init];
    // Override point for customization after app launch    
	
	[self showSplashScreen:YES];
	[self showActivityIndicator:YES];
	[self beginLogon];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[operationQueue release];
	[splashScreen release];
	[largeActivityIndicator release];
	[userDetails release];
	
	[super dealloc];
}

-(void) beginLogon 
{
	DLog (@"beginLogon");
	NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(performLogon) object:nil];
	[operationQueue addOperation:operation];
	[operation release];
}

-(void) performLogon 
{
	DLog(@"performLogon");
	
	NSString* userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"username_pref"];
	NSString* password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password_pref"];
	
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://todoist.com/API/login?email=%@&password=%@",userName, password]];
	NSString* loginDetails = [NSString stringWithContentsOfURL:url];
	
	if ([loginDetails compare:@"\"LOGIN_ERROR\""] == NSOrderedSame) 
	{
		self.isLoggedIn = NO;
	}
	else
	{
		if (userDetails) {
			[userDetails release];
		}
		
		NSDictionary* jsonData			= [loginDetails JSONValue];
		
		userDetails						= [[[DMUserDetails alloc] init] retain];
		userDetails.id					= [[jsonData objectForKey:@"id"] intValue];
		userDetails.api_token			= [jsonData objectForKey:@"api_token"];
		userDetails.full_name			= [jsonData objectForKey:@"full_name"];
		userDetails.mobile_number		= [jsonData objectForKey:@"mobile_number"];
		userDetails.mobile_host			= [jsonData objectForKey:@"mobile_host"];
		userDetails.email				= [jsonData objectForKey:@"email"];
		userDetails.twitter				= [jsonData objectForKey:@"twitter"];
		userDetails.jabber				= [jsonData objectForKey:@"jabber"];
		userDetails.msn					= [jsonData objectForKey:@"msn"];
		userDetails.start_page			= [jsonData objectForKey:@"start_page"];
		userDetails.date_format			= [[jsonData objectForKey:@"date_format"] intValue];
		userDetails.time_format			= [[jsonData objectForKey:@"time_format"] intValue];
		userDetails.sort_order			= [[jsonData objectForKey:@"sort_order"] intValue];
		userDetails.timezone			= [jsonData objectForKey:@"timezone"];
		userDetails.tz_offset			= [jsonData objectForKey:@"tz_offset"];
		userDetails.premium_until		= [jsonData objectForKey:@"premium_until"];
		userDetails.default_reminder	= [jsonData objectForKey:@"default_reminder"];
		
		self.isLoggedIn = YES;
	}
	
	[self performSelectorOnMainThread:@selector(didFinishLogon) withObject:nil waitUntilDone:NO];
}

-(void) didFinishLogon
{
	DLog (@"didFinishLogon");
	[self showActivityIndicator:NO];
	[self showSplashScreen:NO];
	
	if (self.isLoggedIn)
	{
		RootViewController* viewController = [[RootViewController alloc] initWithStyle:UITableViewStylePlain];
		[navigationController pushViewController:viewController animated:NO];
		[viewController release];
		
		[window addSubview:[navigationController view]];
		[window makeKeyAndVisible];
	}
	else
	{
		
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

- (void)createLargeActivityIndicatorView {
	largeActivityIndicator = [[XActivityIndicator alloc] initWithFrame:CGRectMake(85,180, 150, 120)];
	[window addSubview:largeActivityIndicator];
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

-(void) createSplashScreen
{
	if (splashScreen)
	{
		[splashScreen release];
	}
	
	splashScreen = [[SplashScreen alloc] initWithNibName:@"SplashScreen" bundle:nil];
	[window addSubview:splashScreen.view];
}

@end

