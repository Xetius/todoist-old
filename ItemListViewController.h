//
//  ItemListViewController.h
//  Todoist
//
//  Created by Chris Hudson on 15/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMTaskItem.h"
#import "XActivityIndicator.h"

@interface ItemListViewController : UITableViewController<DMTaskItemDelegate> {
	long projectId;
	NSMutableArray* itemList;
	XActivityIndicator* activity;
	
	UIFont* normalFont;
	UIFont* boldFont;
	UIFont* italicFont;
	UIFont* boldItalicFont;
}

@property long projectId;
@property (retain) NSMutableArray* itemList;
@property (retain) XActivityIndicator* activity;

@property (retain) UIFont* normalFont;
@property (retain) UIFont* boldFont;
@property (retain) UIFont* italicFont;
@property (retain) UIFont* boldItalicFont;

-(void) willLoadItems;
-(void) didFinishLoadingItems;

@end
