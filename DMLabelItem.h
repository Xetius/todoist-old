//
//  DMLabelItem.h
//  Todoist
//
//  Created by Chris Hudson on 10/08/2009.
//  Copyright 2009 Xetius Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DMLabelItem : NSObject {
	NSString* color;
	int count;
	long uid;
	long id;
	NSString* name;
}

@property (copy) NSString* color;
@property int count;
@property long uid;
@property long id;
@property (copy) NSString* name;

@end
