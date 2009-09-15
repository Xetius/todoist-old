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

@interface ItemListViewController : UITableViewController<XConnectionHandlerDelegate> {
	long projectId;
	NSMutableArray* itemList;
	XActivityIndicator* activity;
	NSDictionary* labels;
	NSMutableDictionary* connections;
}

@property (assign) long projectId;
@property (retain) NSMutableArray* itemList;
@property (retain) NSDictionary* labels;
@property (retain) NSMutableDictionary* connections;
@property (retain) XActivityIndicator* activity;

-(void) initLoadItems;
-(void) connectionDidFinishLoading:(int) connectionId withData:(NSData*) requestData;
-(void) loadUncompleteItems:(NSData*) data;
-(void) loadCompleteItems:(NSData*) data;

@end
