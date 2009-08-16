//
//  DataModel.m
//  Todoist
//
//  Created by Chris Hudson on 10/08/2009.
//  Copyright 2009 Xetius Services Ltd. All rights reserved.
//

#import "DataModel.h"


@implementation DataModel

@synthesize isLoggedIn;
@synthesize userDetails;
@synthesize projects;
@synthesize labels;

-(id) init {
	if ((self = [super init])) {
		userDetails = nil;
	}
	
	return self;
}

-(void) dealloc {
	[userDetails release];
	[super dealloc];
}

-(BOOL) login {
	NSString* userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"username_pref"];
	NSString* password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password_pref"];

	return [self loginWithUserName:userName	AndPassword:password];
}

-(BOOL) loginWithUserName:(NSString*) userName AndPassword:(NSString*) password {

	//login into Todoist and get the User Details returned
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://todoist.com/API/login?email=%@&password=%@",userName, password]];
	NSString* loginDetails = [NSString stringWithContentsOfURL:url];
	DLog (@"%@",loginDetails);

	if ([loginDetails compare:@"\"LOGIN_ERROR\""] == NSOrderedSame) 
	{
		isLoggedIn = NO;
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
		
		isLoggedIn = YES;
	}
	
	return isLoggedIn;
}

-(BOOL) loadProjects {
	BOOL retVal = self.isLoggedIn;
	if (self.isLoggedIn) 
	{
		NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://todoist.com/API/getProjects?token=%@", self.userDetails.api_token]];
		NSString* data = [NSString stringWithContentsOfURL:url];
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
		[self setProjects:projectsTemp];
	}
	
	return retVal;
}

-(BOOL) loadLabels {
	BOOL retVal = self.isLoggedIn;
	if (self.isLoggedIn)
	{
		NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://todoist.com/API/getLabels?token=%@", self.userDetails.api_token]];
		NSString* data = [NSString stringWithContentsOfURL:url];
		NSDictionary* jsonDictionary = [data JSONValue];
		NSMutableDictionary* labelsTemp = [NSMutableDictionary dictionaryWithCapacity:1];
		for (id key in jsonDictionary) 
		{
			NSDictionary* labelDetails = [jsonDictionary objectForKey:key];
			DMLabelItem* labelItem = [[DMLabelItem alloc] init];
			labelItem.color = [labelDetails objectForKey:@"color"];
			labelItem.count = [[labelDetails objectForKey:@"count"] intValue];
			labelItem.uid = [[labelDetails objectForKey:@"uid"] longValue];
			labelItem.id = [[labelDetails objectForKey:@"id"] longValue];
			labelItem.name = [labelDetails objectForKey:@"name"];
			
			[labelsTemp setObject:labelItem forKey:[NSNumber numberWithLong:labelItem.id]];
			[labelItem release];
		}
		
		[self setLabels:labelsTemp];
	}
	
	return retVal;
}

-(BOOL) loadItemsForProject:(long)projectId {
	BOOL retVal = self.isLoggedIn;
	if (self.isLoggedIn)
	{

	}
	return retVal;
}

@end
