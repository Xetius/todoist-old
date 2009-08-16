//
//  ItemListViewController.h
//  Todoist
//
//  Created by Chris Hudson on 15/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XActivityIndicator.h"

@interface ItemListViewController : UITableViewController {
	long projectId;
	NSMutableArray* itemList;
	XActivityIndicator* activity;
}

@property long projectId;
@property (retain) NSMutableArray* itemList;
@property (retain) XActivityIndicator* activity;

-(void) willLoadItems;
-(void) didFinishLoadingItems;

@end
