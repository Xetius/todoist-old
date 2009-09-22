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
#import "XConnectionHandler.h"
#import "ItemListTableViewCell.h"

@interface ItemListViewController : UITableViewController<XConnectionHandlerDelegate,ItemListTableViewCellDelegate> {
	long projectId;
	NSMutableArray* itemList;
	XActivityIndicator* activity;
	NSDictionary* labels;
	NSMutableDictionary* connections;
	
	UIFont* labelFont;
	UIFont* contentFont;
	
	UIColor* backgroundColor;
	UIColor* labelColor;
	UIColor* dateColor;
	UIColor* priority1Color;
	UIColor* priority2Color;
	UIColor* priority3Color;
	UIColor* priority4Color;
}

@property (assign) long projectId;
@property (retain) NSMutableArray* itemList;
@property (retain) NSDictionary* labels;
@property (retain) NSMutableDictionary* connections;
@property (retain) XActivityIndicator* activity;

@property (retain) UIFont* labelFont;
@property (retain) UIFont* contentFont;

@property (retain) UIColor* backgroundColor;
@property (retain) UIColor* labelColor;
@property (retain) UIColor* dateColor;
@property (retain) UIColor* priority1Color;
@property (retain) UIColor* priority2Color;
@property (retain) UIColor* priority3Color;
@property (retain) UIColor* priority4Color;

-(void) initLoadItems;
-(void) connectionDidFinishLoading:(int) connectionId withData:(NSData*) requestData;
-(void) loadUncompleteItems:(NSData*) data;
-(void) loadCompleteItems:(NSData*) data;

@end
