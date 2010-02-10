//
//  XDataEngine.m
//  Todoist
//
//  Created by Chris Hudson on 05/10/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import "XDataEngine.h"
#import "JSON.h"
#import "DMProjectItem.h"
#import "DMLabelItem.h"
#import "DMTaskItem.h"

@implementation XDataEngine

@synthesize items;
@synthesize projects;
@synthesize labels;
@synthesize userDetails;
@synthesize connectionHandlers;

-(id) init {
	if (self = [super init]) {
		items = [[NSMutableDictionary alloc] init];
		projects = nil;
		labels = nil;
		userDetails = nil;
		connectionHandlers = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void) dealloc {
	[items release];
	[projects release];
	[labels release];
	[userDetails release];
	[connectionHandlers release];
	[super dealloc];
}

// User Details return, init and save
-(DMUserDetails*) userDetailsWithDelegate:(NSObject<XDataEngineDelegate>*) delegate {
	DLog (@"userDetailsWithDelegate");
	if (userDetails == nil) {
		if ([connectionHandlers objectForKey:[NSNumber numberWithInt:LOGIN_CONNECTION_ID]] == nil) {
			DLog (@"Requesting user details");
			[self initUserData:[delegate autorelease]];
		}
		else {
			DLog (@"User details already requested");
		}

	}
	return userDetails;
}

-(void) initUserData:(NSObject<XDataEngineDelegate>*) delegate {
	DLog(@"initUserData");
	
	NSString* userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"username_pref"];
	NSString* password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password_pref"];
	NSString* loginUrl = [NSString stringWithFormat:@"http://todoist.com/API/login?email=%@&password=%@", userName, password];
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:loginUrl]
										 cachePolicy:NSURLRequestUseProtocolCachePolicy
									 timeoutInterval:60.0];
	XConnectionHandler* loginHandler = [[XConnectionHandler alloc] initWithId:LOGIN_CONNECTION_ID andDelegate:self];
	NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:req delegate:loginHandler];
	if (conn) {
		[loginHandler setRequestDelegate:[delegate retain]];
		[connectionHandlers setObject:loginHandler forKey:[NSNumber numberWithInt:LOGIN_CONNECTION_ID]];
	}
	else {
		DLog (@"Failure to create login connection");
	}
	[loginHandler release];
}

- (void)saveUserData:(NSData*) requestData;
{
    NSLog(@"Succeeded! Received %d bytes of data",[requestData length]);
	[userDetails autorelease];
	NSString* loginDetails = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
	if ([loginDetails compare:@"\"LOGIN_ERROR\""] == NSOrderedSame) 
	{
		DLog (@"Login Failed : LOGIN_ERROR");
	}
	else
	{
		DLog (@"Login Success");
		
		NSDictionary* jsonData				= [loginDetails JSONValue];
		
		self.userDetails					= [[DMUserDetails alloc] init];
		self.userDetails.id					= [[jsonData objectForKey:@"id"] intValue];
		self.userDetails.api_token			= [[jsonData objectForKey:@"api_token"] retain];
		self.userDetails.full_name			= [[jsonData objectForKey:@"full_name"] retain];
		self.userDetails.mobile_number		= [[jsonData objectForKey:@"mobile_number"] retain];
		self.userDetails.mobile_host		= [[jsonData objectForKey:@"mobile_host"] retain];
		self.userDetails.email				= [[jsonData objectForKey:@"email"] retain];
		self.userDetails.twitter			= [[jsonData objectForKey:@"twitter"] retain];
		self.userDetails.jabber				= [[jsonData objectForKey:@"jabber"] retain];
		self.userDetails.msn				= [[jsonData objectForKey:@"msn"] retain];
		self.userDetails.start_page			= [[jsonData objectForKey:@"start_page"] retain];
		self.userDetails.date_format		= [[jsonData objectForKey:@"date_format"] intValue];
		self.userDetails.time_format		= [[jsonData objectForKey:@"time_format"] intValue];
 		self.userDetails.sort_order			= [[jsonData objectForKey:@"sort_order"] intValue];
		self.userDetails.timezone			= [[jsonData objectForKey:@"timezone"] retain];
		self.userDetails.tz_offset			= [[jsonData objectForKey:@"tz_offset"] retain];
		self.userDetails.premium_until		= [[jsonData objectForKey:@"premium_until"] retain];
		self.userDetails.default_reminder	= [[jsonData objectForKey:@"default_reminder"] retain];
	}
}

// Project details return, init and save
-(NSArray*) projectsWithDelegate:(NSObject<XDataEngineDelegate>*) delegate {
	if (projects == nil) {
		XConnectionHandler* handler = [connectionHandlers objectForKey:[NSNumber numberWithInt:PROJECTS_CONNECTION_ID]];
		if (handler != nil) {
			DLog (@"Project details already requested");
		}
		else {
			DLog (@"Requesting project details");
			[self initProjectData:delegate];
		}
	}
	return projects;
}

-(void) initProjectData:(NSObject<XDataEngineDelegate>*) delegate {
	NSString* token = [userDetails api_token];	
	NSString* projectsUrl = [NSString stringWithFormat:@"http://todoist.com/API/getProjects?token=%@", token];
	NSURLRequest* projectsRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:projectsUrl]
													 cachePolicy:NSURLRequestUseProtocolCachePolicy
												 timeoutInterval:60.0];
	XConnectionHandler* projectsHandler = [[[XConnectionHandler alloc] initWithId:PROJECTS_CONNECTION_ID andDelegate:self] autorelease];
	
	NSURLConnection* projectsConnection = [[NSURLConnection alloc] initWithRequest:projectsRequest delegate:projectsHandler];
	if (projectsConnection != nil) {
		DLog (@"initiated request for Projects data");
		[projectsHandler setRequestDelegate:delegate];
		[connectionHandlers setObject:projectsHandler forKey:[NSNumber numberWithInt:PROJECTS_CONNECTION_ID]];
	}
	else {
		// Handle Error
		DLog (@"Failure to create projects connection");
	}
	
}

-(void) saveProjectData:(NSData*) requestData {
    DLog(@"Succeeded! Received %d bytes of data",[requestData length]);
	NSString* data = [[[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding] autorelease];
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

// Labels return, init and save
-(NSDictionary*) labelsWithDelegate:(NSObject<XDataEngineDelegate>*) delegate {
	
	if (self.labels == nil) {
		XConnectionHandler* handler = [connectionHandlers objectForKey:[NSNumber numberWithInt:LABELS_CONNECTION_ID]];
		if ( handler != nil) {
			DLog (@"Label data already requested.");
		}
		else {
			DLog (@"Requesting label data.");
			[self initLabelsData:delegate];
		}
	}
	return self.labels;
}

-(void) initLabelsData:(NSObject<XDataEngineDelegate>*) delegate {
	NSString* token = [userDetails api_token];
	NSString* url = [NSString stringWithFormat:@"http://todoist.com/API/getLabels?token=%@", token];
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
	
	XConnectionHandler* handler = [[[XConnectionHandler alloc] initWithId:LABELS_CONNECTION_ID andDelegate:self] autorelease];
	
	
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:handler];
	if (connection) {
		DLog (@"initiated request for Label data");
		[handler setRequestDelegate:delegate];
		[connectionHandlers setObject:handler forKey:[NSNumber numberWithInt:LABELS_CONNECTION_ID]];
	}
	else {
		// Handle Error
		DLog (@"Failure to create labels connection");
	}
}

-(void) saveLabelData:(NSData*) requestData {
	// Loaded Labels Data so build dictionary to contain it
    DLog(@"Succeeded! Received %d bytes of data",[requestData length]);
	NSString* data = [[[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary* jsonLabelsDictionary = [data JSONValue];
	NSMutableDictionary* labelsTemp = [NSMutableDictionary dictionaryWithCapacity:1];
	for (id name in jsonLabelsDictionary) {
		DLog(@"Label:%@", name);
		NSDictionary* jsonLabel = [jsonLabelsDictionary objectForKey:name];
		DMLabelItem* labelItem = [[DMLabelItem alloc] init];
		labelItem.name = [jsonLabel objectForKey:@"name"];
		labelItem.labelId = [[jsonLabel objectForKey:@"id"] longValue];
		labelItem.uid = [[jsonLabel objectForKey:@"uid"] longValue];
		labelItem.color = [jsonLabel objectForKey:@"color"];
		labelItem.count = [[jsonLabel objectForKey:@"count"] intValue];
		[labelsTemp setObject:labelItem forKey:[NSNumber numberWithLong:labelItem.labelId]];
		[labelItem release];
	}
	self.labels = labelsTemp;	
}	

-(NSArray*) itemsForProjectId:(int)projectId withDelegate:(NSObject<XDataEngineDelegate>*)delegate {
	DLog(@"Requesting items for project id:%d", projectId);
	NSString* uIdString = [self idStringForId:UNCOMPLETE_ITEMS_CONNECTION_ID andProjectId:projectId];
	NSString* cIdString = [self idStringForId:COMPLETE_ITEMS_CONNECTION_ID andProjectId:projectId];
	DLog(@"Requesting uncomplete items:%@ and complete items:%@", uIdString, cIdString);
	NSArray* uItems = [items objectForKey:uIdString];
	NSArray* cItems = [items objectForKey:cIdString];
	
	if (uItems != nil) {
		DLog (@"Uncomplete item found");
	}
	else {
		DLog (@"Uncomplete item not found");
		// Check the connection handlers to see if this item is already requested
		if ([connectionHandlers objectForKey:uIdString] != nil) {
			// Object exists so already requested
			DLog (@"Uncomplete items requested");
		}
		else {
			DLog (@"Uncomplete items not requested.  Initiating request.");
			[self initUncompleteItemsDataForProjectId:projectId withDelegate:delegate];
		}
	}
	
	if (cItems != nil) {
		DLog (@"Complete item found");
	}
	else {
		DLog (@"Complete item not found");
		// Check the connection handlers to see if this item is already requested
		if ([connectionHandlers objectForKey:cIdString] != nil) {
			// Object exists so already requested
			DLog (@"Complete items requested");
		}
		else {
			DLog (@"Complete items not requested.  Initiating request.");
			[self initCompleteItemsDataForProjectId:projectId withDelegate:delegate];
		}
	}
	
	if ((uItems == nil) && (cItems == nil)) {
		return nil;
	}
	else {
		return [[[NSArray alloc] initWithObjects:uItems, cItems, nil] autorelease];
	}

	return nil;
}

-(void) initUncompleteItemsDataForProjectId:(int) projectId withDelegate:(NSObject<XDataEngineDelegate>*)delegate {
	NSString* token = [[self userDetails] api_token];
	NSString* url = [NSString stringWithFormat:@"http://todoist.com/API/getUncompletedItems?token=%@&project_id=%d", token, projectId];
	DLog (@"Requesting URL:%@", url);
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
	XConnectionHandler* handler = [[[XConnectionHandler alloc] initWithId:UNCOMPLETE_ITEMS_CONNECTION_ID andDelegate:self] autorelease];
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:handler];
	if (connection) {
		DLog (@"Initiating request for uncomplete items");
		[handler setRequestDelegate:delegate];
		[handler setProjectId:projectId];
		[connectionHandlers setObject:handler forKey:[self idStringForId:UNCOMPLETE_ITEMS_CONNECTION_ID andProjectId:projectId]];
	}
	else {
		DLog (@"Failure to create uncomplete items connection");
	}
}

-(void) initCompleteItemsDataForProjectId:(int) projectId withDelegate:(NSObject<XDataEngineDelegate>*)delegate 
{
	NSString* token = [[self userDetails] api_token];
	NSString* url = [NSString stringWithFormat:@"http://todoist.com/API/getCompletedItems?token=%@&project_id=%d", token, projectId];
	DLog (@"Requesting URL:%@", url);
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
	XConnectionHandler* handler = [[[XConnectionHandler alloc] initWithId:COMPLETE_ITEMS_CONNECTION_ID andDelegate:self] autorelease];
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:handler];
	if (connection) {
		DLog (@"Initiating request for complete items");
		[handler setRequestDelegate:delegate];
		[handler setProjectId:projectId];
		[connectionHandlers setObject:handler forKey:[self idStringForId:COMPLETE_ITEMS_CONNECTION_ID andProjectId:projectId]];
	}
	else {
		DLog (@"Failure to create complete items connection");
	}
}

-(void) saveUncompleteItemData:(NSData*) requestData forProjectId:(int) projectId 
{
	NSArray* jsonData = [[[[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding] autorelease] JSONValue];
	NSMutableArray* tempArray = [NSMutableArray array];
	if (([jsonData isKindOfClass:[NSArray class]]) && ([jsonData count] > 0))
	{
		for (id item in jsonData) 
		{
			DMTaskItem* newItem = [[[DMTaskItem alloc] init] autorelease];
			newItem.completed = NO;
			newItem.content = [item objectForKey:@"content"];
			newItem.indent = [[item objectForKey:@"indent"] intValue];
			newItem.labels = [item objectForKey:@"labels"];
			newItem.priority = [[item objectForKey:@"priority"] intValue];
			NSString* date = [item objectForKey:@"due_date"];
			if (![date isKindOfClass:[NSNull class]]) {
				NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
				[df setDateFormat:@"EEE MMM dd HH:mm:ss yyyy"];
				newItem.due_date = [df dateFromString:date];
			}
			else {
				newItem.due_date = nil;
			}
			
			newItem.entered_date = [item objectForKey:@"date_string"];
			newItem.type = 0;
			[tempArray addObject:newItem];
		}
		NSString* idString = [self idStringForId:UNCOMPLETE_ITEMS_CONNECTION_ID andProjectId:projectId];
		[items setObject:tempArray forKey:idString];
	}
}

-(void) saveCompleteItemData:(NSData*) requestData forProjectId:(int) projectId	
{
	NSArray* jsonData = [[[[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding] autorelease] JSONValue];
	NSMutableArray* tempArray = [NSMutableArray array];
	if ([jsonData isKindOfClass:[NSArray class]])
	{
		for (id item in jsonData) 
		{
			DMTaskItem* newItem = [[[DMTaskItem alloc] init] autorelease];
			newItem.completed = YES;
			newItem.content = [item objectForKey:@"content"];
			newItem.indent = [[item objectForKey:@"indent"] intValue];
			newItem.labels = [item objectForKey:@"labels"];
			newItem.priority = [[item objectForKey:@"priority"] intValue];
			NSString* date = [item objectForKey:@"due_date"];
			if (date != nil) {
				NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
				[df setDateFormat:@"EEE MMM dd HH:mm:ss yyyy"];
				newItem.due_date = [df dateFromString:date];
			}
			else {
				newItem.due_date = nil;
			}

			newItem.entered_date = [item objectForKey:@"date_string"];
			newItem.type = 0;
			[tempArray addObject:newItem];
		}

		NSString* idString = [self idStringForId:COMPLETE_ITEMS_CONNECTION_ID andProjectId:projectId];
		[items setObject:tempArray forKey:idString];
	}
}

-(void) connectionDidFailLoading:(int) connectionId withError:(NSError*) error 
{
	[self connectionDidFailLoading:connectionId withError:error andProjectId:0];
}

-(void) connectionDidFailLoading:(int) connectionId withError:(NSError*) error andProjectId:(int) projectId
{
	switch (connectionId) {
		case LOGIN_CONNECTION_ID:
		{
			DLog(@"connectionDidFailLoading:LOGIN_CONNECTION_ID");
			[connectionHandlers removeObjectForKey:[NSNumber numberWithInt:LOGIN_CONNECTION_ID]];
		}
			break;
		case LABELS_CONNECTION_ID:
		{
			DLog(@"connectionDidFailLoading:LABELS_CONNECTION_ID");
			[connectionHandlers removeObjectForKey:[NSNumber numberWithInt:LABELS_CONNECTION_ID]];
		}
			break;
		case PROJECTS_CONNECTION_ID:
		{
			DLog(@"connectionDidFailLoading:PROJECTS_CONNECTION_ID");
			[connectionHandlers removeObjectForKey:[NSNumber numberWithInt:PROJECTS_CONNECTION_ID]];
		}
			break;
		case COMPLETE_ITEMS_CONNECTION_ID:
		{
			DLog(@"connectionDidFailLoading:COMPLETE_ITEMS_CONNECTION_ID");
		}
			break;
		case UNCOMPLETE_ITEMS_CONNECTION_ID:
		{
			DLog(@"connectionDidFailLoading:UNCOMPLETE_ITEMS_CONNECTION_ID");
		}
			break;
		default:
		{
			DLog(@"connectionDidFailLoading:UNKNOWN_ID:%d", connectionId);
		}
			break;
	}
}

-(void) connectionDidFinishLoading:(int) connectionId withData:(NSData*) requestData 
{
	[self connectionDidFinishLoading:connectionId withData:requestData andProjectId:0];
}

-(void) connectionDidFinishLoading:(int) connectionId withData:(NSData*) requestData andProjectId:(int) projectId
{
	switch (connectionId) {
		case LOGIN_CONNECTION_ID:
		{
			DLog (@"connectionDidFinishLoading:LOGIN_CONNECTION_ID");
			[self saveUserData:requestData];
			XConnectionHandler* connectionHandler = [connectionHandlers objectForKey:[NSNumber numberWithInt:LOGIN_CONNECTION_ID]];
			[[connectionHandler requestDelegate] dataDidCompleteForId:LOGIN_CONNECTION_ID];
			[connectionHandlers removeObjectForKey:[NSNumber numberWithInt:LOGIN_CONNECTION_ID]];
		}
			break;
		case LABELS_CONNECTION_ID:
		{
			DLog (@"connectionDidFinishLoading:LABELS_CONNECTION_ID");
			[self saveLabelData:requestData];
			XConnectionHandler* connectionHandler = [connectionHandlers objectForKey:[NSNumber numberWithInt:LABELS_CONNECTION_ID]];
			[[connectionHandler requestDelegate] dataDidCompleteForId:LABELS_CONNECTION_ID];
			[connectionHandlers removeObjectForKey:[NSNumber numberWithInt:LABELS_CONNECTION_ID]];
		}
			break;
		case PROJECTS_CONNECTION_ID:
		{
			DLog (@"connectionDidFinishLoading:PROJECTS_CONNECTION_ID");
			[self saveProjectData:requestData];
			XConnectionHandler* connectionHandler = [connectionHandlers objectForKey:[NSNumber numberWithInt:PROJECTS_CONNECTION_ID]];
			[[connectionHandler requestDelegate] dataDidCompleteForId:PROJECTS_CONNECTION_ID];
			[connectionHandlers removeObjectForKey:[NSNumber numberWithInt:PROJECTS_CONNECTION_ID]];
		}
			break;
		case COMPLETE_ITEMS_CONNECTION_ID:
		{
			DLog (@"connectionDidFinishLoading:COMPLETE_ITEMS_CONNECTION_ID");
			[self saveCompleteItemData:requestData forProjectId:projectId];
			XConnectionHandler* connectionHandler = [connectionHandlers objectForKey:[self idStringForId:COMPLETE_ITEMS_CONNECTION_ID andProjectId:projectId]];
			[[connectionHandler requestDelegate] dataDidCompleteForId:COMPLETE_ITEMS_CONNECTION_ID ];
			[connectionHandlers removeObjectForKey:[self idStringForId:COMPLETE_ITEMS_CONNECTION_ID andProjectId:projectId]];
		}
			break;
		case UNCOMPLETE_ITEMS_CONNECTION_ID:
		{
			DLog (@"connectionDidFinishLoading:UNCOMPLETE_ITEMS_CONNECTION_ID");
			[self saveUncompleteItemData:requestData forProjectId:projectId];
			XConnectionHandler* connectionHandler = [connectionHandlers objectForKey:[self idStringForId:UNCOMPLETE_ITEMS_CONNECTION_ID andProjectId:projectId]];
			[[connectionHandler requestDelegate] dataDidCompleteForId:UNCOMPLETE_ITEMS_CONNECTION_ID];
			[connectionHandlers removeObjectForKey:[self idStringForId:UNCOMPLETE_ITEMS_CONNECTION_ID andProjectId:projectId]];
		}
			break;
			
		default:
			break;
	}
}

-(NSString*) idStringForId:(int) dataId {
	return [[self idStringForId:dataId andProjectId:0] autorelease];
}

-(NSString*) idStringForId:(int) dataId andProjectId:(int) projectId {
	switch (dataId) {
		case LOGIN_CONNECTION_ID:
		{
			return USER_DATA_ID_STRING;
		}
			break;
		case PROJECTS_CONNECTION_ID:
		{
			return PROJECT_DATA_ID_STRING;
		}
			break;
		case LABELS_CONNECTION_ID:
		{
			return LABEL_DATA_ID_STRING;
		}
			break;
		case ITEMS_CONNECTION_ID:
		{
			return [NSString stringWithFormat:ITEM_DATA_ID_STRING, projectId];
		}
			break;
		case UNCOMPLETE_ITEMS_CONNECTION_ID:
		{
			return [NSString stringWithFormat:UNCOMPLETE_ITEMS_DATA_ID_STRING, projectId];
		}
			break;
		case COMPLETE_ITEMS_CONNECTION_ID:
		{
			return [NSString stringWithFormat:COMPLETE_ITEMS_DATA_ID_STRING, projectId];
		}
			break;
		default:
		{
			return UNKNOWN_DATA_ID_STRING;
		}
			break;
	}	
}
	
@end
