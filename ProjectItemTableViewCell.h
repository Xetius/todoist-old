//
//  ProjectItemTableViewCell.h
//  Todoist
//
//  Created by Chris Hudson on 16/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableViewCellBase.h"

@interface ProjectItemTableViewCell : XTableViewCellBase {	
	NSString*	content;
	UIColor*	color;
	int			count;
	int			indent;
	bool		editing;
}

@property (retain) NSString* content;
@property (retain) UIColor* color;
@property (assign) int count;
@property (assign) int indent;
@property (assign) bool editing;

@end
