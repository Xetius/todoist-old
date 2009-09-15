//
//  DMTaskItem.h
//  Todoist
//
//  Created by Chris Hudson on 10/08/2009.
//  Copyright 2009 Xetius Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMTaskItem : NSObject {

	NSString* content;
	BOOL	  completed;	
	int		  priority;
	int		  indent;
	NSArray*  labels;
}

@property (assign) BOOL completed;
@property (assign) int indent;
@property (assign) int priority;
@property (retain) NSString* content;
@property (retain) NSArray* labels;

@end
