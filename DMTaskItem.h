//
//  DMTaskItem.h
//  Todoist
//
//  Created by Chris Hudson on 10/08/2009.
//  Copyright 2009 Xetius Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XConnectionHandler.h"

@interface DMTaskItem : NSObject {

	NSString* content;
	BOOL	  completed;	
	int		  priority;
	int		  indent;
	NSArray*  labels;
	NSString* display_date;
	NSString* entered_date;
	int		  type;
}

@property (assign) BOOL completed;
@property (assign) int indent;
@property (assign) int priority;
@property (retain) NSString* content;
@property (retain) NSArray*  labels;
@property (retain) NSString* display_date;
@property (retain) NSString* entered_date;
@property (assign) int type;

-(NSString*) labelStringWithDelegate:(NSObject<XDataEngineDelegate>*) delegate;

@end
