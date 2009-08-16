//
//  DMProjectItem.h
//  Todoist
//
//  Created by Chris Hudson on 10/08/2009.
//  Copyright 2009 Xetius Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DMProjectItem : NSObject {
	long user_id;
	NSString* name;
	NSString* color;
	int collapsed;
	int item_order;
	int cache_count;
	int indent;
	long id;
}

@property long user_id;
@property (copy) NSString* name;
@property (copy) NSString* color;
@property int collapsed;
@property int item_order;
@property int cache_count;
@property int indent;
@property long id;

@end
