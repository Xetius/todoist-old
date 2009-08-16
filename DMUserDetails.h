//
//  DMUserDetails.h
//  Todoist
//
//  Created by Chris Hudson on 10/08/2009.
//  Copyright 2009 Xetius Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DMUserDetails : NSObject {
	long id;
	NSString* api_token;
	NSString* full_name;
	NSString* mobile_number;
	NSString* mobile_host;
	NSString* email;
	NSString* jabber;
	NSString* twitter;
	NSString* msn;
	NSString* start_page;
	int date_format;
	int time_format;
	int sort_order;
	NSString* timezone;
	NSArray* tz_offset;
	NSString* premium_until;
	NSString* default_reminder;
}

@property long id;
@property (copy) NSString* api_token;
@property (copy) NSString* full_name;
@property (copy) NSString* mobile_number;
@property (copy) NSString* mobile_host;
@property (copy) NSString* email;
@property (copy) NSString* twitter;
@property (copy) NSString* jabber;
@property (copy) NSString* msn;
@property (copy) NSString* start_page;
@property int date_format;
@property int time_format;
@property int sort_order;
@property (copy) NSString* timezone;
@property (copy) NSArray* tz_offset;
@property (copy) NSString* premium_until;
@property (copy) NSString* default_reminder;

@end
