//
//  DMTaskItem.m
//  Todoist
//
//  Created by Chris Hudson on 10/08/2009.
//  Copyright 2009 Xetius Services Ltd. All rights reserved.
//

#import "DMTaskItem.h"
#import "RegexKitLite.h"

@implementation DMTaskItem

@synthesize completed;
@synthesize indent;
@synthesize content;
@synthesize priority;
@synthesize labels;

-(void) dealloc {
	[labels release];
	[content release];
	[super dealloc];
}

@end
