//
//  DMTaskItem.m
//  Todoist
//
//  Created by Chris Hudson on 10/08/2009.
//  Copyright 2009 Xetius Services Ltd. All rights reserved.
//

#import "DMTaskItem.h"
#import "RegexKitLite.h"
#import "XDataEngine.h"
#import "TodoistAppDelegate.h"

@implementation DMTaskItem

@synthesize completed;
@synthesize indent;
@synthesize content;
@synthesize priority;
@synthesize labels;
@synthesize display_date;
@synthesize entered_date;
@synthesize type;

-(void) dealloc {
	[labels release];
	[content release];
	[super dealloc];
}

-(NSString*) description 
{
	return content;
}

-(NSString*) labelStringWithDelegate:(NSObject<XDataEngineDelegate>*) delegate
{
	XDataEngine* engine = [(TodoistAppDelegate*)[[UIApplication sharedApplication] delegate] engine];
	if (labels != nil) 
	{
		NSDictionary* labelList = [engine labelsWithDelegate:delegate];
		if (labelList == nil) {
			DLog(@"Label List is Nil");
		}
		else {
			DLog(@"Label List is NOT Nil");
			NSEnumerator *e = [labels objectEnumerator];
			NSNumber* labelId;
			
			while ((labelId = [e nextObject])) 
			{
				NSLog(@"label : %@", [labelList objectForKey:labelId]);		
			}
			
		}
	}
	return @"My Labels";
}

@end
