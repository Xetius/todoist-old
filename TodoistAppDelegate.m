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
#import "DMLabelItem.h"
#import "DMProjectItem.h"

@implementation TodoistAppDelegate

@synthesize largeActivityIndicator;
@synthesize splashScreen;
@synthesize window;
@synthesize navigationController;
@synthesize userDetails;
@synthesize projects;
@synthesize labels;
@synthesize isLoggedIn;
@synthesize connectionHandlers;
@synthesize connectionLoaded;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
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
	[splashScreen release];
	[largeActivityIndicator release];
	[userDetails release];
	
	[super dealloc];
}

-(void) beginLogon 
{
	DLog (@"beginLogon");
	[self setConnectionLoaded:0];
	NSString* userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"username_pref"];
	NSString* password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password_pref"];
	NSString* loginUrl = [NSString stringWithFormat:@"http://todoist.com/API/login?email=%@&password=%@", userName, password];
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:loginUrl]
										 cachePolicy:NSURLRequestUseProtocolCachePolicy
									 timeoutInterval:60.0];
	XConnectionHandler* loginHandler = [[XConnectionHandler alloc] initWithId:LOGIN_CONNECTION_ID andDelegate:self];
	NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:req delegate:loginHandler];
	if (conn) {
		[connectionHandlers setObject:loginHandler forKey:[NSNumber numberWithInt:LOGIN_CONNECTION_ID]];
	}
	else {
		DLog (@"Failure to create login connection");
		// Display non-connection message
	}
	[loginHandler release];
}

-(void) initRequestsForLabelsAndProjects 
{
	NSString* token = [[userDetails api_token] autorelease];
	NSString* labelsUrl = [NSString stringWithFormat:@"http://todoist.com/API/getLabels?token=%@", token];
	NSString* projectsUrl = [NSString stringWithFormat:@"http://todoist.com/API/getProjects?token=%@", token];
	
	NSURLRequest* labelsRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:labelsUrl]
												   cachePolicy:NSURLRequestUseProtocolCachePolicy
											   timeoutInterval:60.0];
	NSURLRequest* projectsRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:projectsUrl]
													 cachePolicy:NSURLRequestUseProtocolCachePolicy
												 timeoutInterval:60.0];
	
	XConnectionHandler* labelsHandler = [[XConnectionHandler alloc] initWithId:LABELS_CONNECTION_ID andDelegate:self];
	XConnectionHandler* projectsHandler = [[XConnectionHandler alloc] initWithId:PROJECTS_CONNECTION_ID andDelegate:self];
	
	NSURLConnection* labelsConnection = [[NSURLConnection alloc] initWithRequest:labelsRequest delegate:labelsHandler];
	if (labelsConnection) {
		DLog (@"initiated request for Label data");
		[connectionHandlers setObject:labelsHandler forKey:[NSNumber numberWithInt:LABELS_CONNECTION_ID]];
	}
	else {
		// Handle Error
		DLog (@"Failure to create labels connection");
	}
	[labelsHandler release];
	
	NSURLConnection* projectsConnection = [[NSURLConnection alloc] initWithRequest:projectsRequest delegate:projectsHandler];
	if (projectsConnection) {
		DLog (@"initiated request for Projects data");
		[connectionHandlers setObject:projectsConnection forKey:[NSNumber numberWithInt:PROJECTS_CONNECTION_ID]];
	}
	else {
		// Handle Error
		DLog (@"Failure to create projects connection");
	}
	[projectsHandler release];
}

-(void) connectionDidFailLoading:(int) connectionId withError:(NSError*) error {
	switch (connectionId) {
		case LOGIN_CONNECTION_ID:
		{
			DLog(@"connectionDidFailLoading:LOGIN_CONNECTION_ID");
		}
			break;
		case LABELS_CONNECTION_ID:
		{
			DLog(@"connectionDidFailLoading:LABELS_CONNECTION_ID");
		}
			break;
		case PROJECTS_CONNECTION_ID:
		{
			DLog(@"connectionDidFailLoading:PROJECTS_CONNECTION_ID");
		}
			break;
		default:
			break;
	}
}

-(void) connectionDidFinishLoading:(int) connectionId withData:(NSData*) requestData 
{
	switch (connectionId) {
		case LOGIN_CONNECTION_ID:
		{
			DLog (@"connectionDidFinishLoading:LOGIN_CONNECTION_ID");
			[self saveUserData:requestData];
			[self initRequestsForLabelsAndProjects];
			connectionLoaded |= LOGIN_CONNECTION_DATA;
		}
			break;
		case LABELS_CONNECTION_ID:
		{
			DLog (@"connectionDidFinishLoading:LABELS_CONNECTION_ID");
			[self loadLabelsData:requestData];
			connectionLoaded |= LABELS_CONNECTION_DATA;
		}
			break;
		case PROJECTS_CONNECTION_ID:
		{
			DLog (@"connectionDidFinishLoading:PROJECTS_CONNECTION_ID");
			[self loadProjectsData:requestData];
			connectionLoaded |= PROJECTS_CONNECTION_DATA;
		}
			break;

		default:
			break;
	}
	
	[connectionHandlers removeObjectForKey:[NSNumber numberWithInt:connectionId]];
	if (self.connectionLoaded & (LOGIN_CONNECTION_DATA | PROJECTS_CONNECTION_DATA | LABELS_CONNECTION_ID)) {
		[self allDataLoaded];
	}
}

- (void)saveUserData:(NSData*) requestData;
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[requestData length]);
	
	NSString* loginDetails = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
	if ([loginDetails compare:@"\"LOGIN_ERROR\""] == NSOrderedSame) 
	{
		DLog (@"Login Failed : LOGIN_ERROR");
		self.isLoggedIn = NO;
	}
	else
	{
		DLog (@"Login Success");
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
}

-(void) loadLabelsData:(NSData*) requestData 
{
	// Loaded Labels Data so build dictionary to contain it
    NSLog(@"Succeeded! Received %d bytes of data",[requestData length]);
	NSString* data = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
	NSDictionary* jsonLabelsDictionary = [data JSONValue];
	NSMutableDictionary* labelsTemp = [NSMutableDictionary dictionaryWithCapacity:1];
	for (id name in jsonLabelsDictionary) {
		DLog(@"Label:%@", name);
		NSDictionary* jsonLabel = [jsonLabelsDictionary objectForKey:name];
		DMLabelItem* labelItem = [[DMLabelItem alloc] init];
		labelItem.name = [jsonLabel objectForKey:@"name"];
		labelItem.labelId = [[jsonLabel objectForKey:@"id"] longValue];
		labelItem.uid = [[jsonLabel objectForKey:@"uid"] longValue];
		labelItem.color = [[jsonLabel objectForKey:@"color"] intValue];
		labelItem.count = [[jsonLabel objectForKey:@"count"] intValue];
		[labelsTemp setObject:labelItem forKey:[NSNumber numberWithLong:labelItem.labelId]];
		[labelItem release];
	}
	self.labels = labelsTemp;	
}

-(void) loadProjectsData:(NSData*) requestData
{
    NSLog(@"Succeeded! Received %d bytes of data",[requestData length]);
	NSString* data = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
	NSArray* jsonProjectsArray = [data JSONValue];
	NSMutableArray* projectsTemp = [NSMutableArray arrayWithCapacity:1];
	for (NSDictionary* jsonProject in jsonProjectsArray) 
	{
		DMProjectItem* projectItem = [[DMProjectItem alloc] init];
		projectItem.user_id = [[jsonProject objectForKey:@"user_id"] longValue];
		projectItem.name = [jsonProject objectForKey:@"name"];
		projectItem.color = [jsonProject objectForKey:@"color"];
		projectItem.collapsed = [[jsonProject objectForKey:@"collapsed"] intValue];
		projectItem.item_order = [[jsonProject objectForKey:@"item_order"] intValue];
		projectItem.cache_count = [[jsonProject objectForKey:@"cache_count"] intValue];
		projectItem.indent = [[jsonProject objectForKey:@"indent"] intValue];
		projectItem.id = [[jsonProject objectForKey:@"id"] longValue];
		
		[projectsTemp addObject:projectItem];
		[projectItem release];
	}
	self.projects = projectsTemp;	
}

-(void) allDataLoaded 
{
	DLog(@"allDataLoaded");
	[self showActivityIndicator:NO];
	[self showSplashScreen:NO];
	
	if (self.isLoggedIn)
	{
		RootViewController* viewController = [[RootViewController alloc] initWithStyle:UITableViewStyleGrouped];
		viewController.labels = [[self labels] retain];
		viewController.projects = [[self projects] retain];
		
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

