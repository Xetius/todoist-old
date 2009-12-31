//
//  ItemListViewController.h
//  Todoist
//
//  Created by Chris Hudson on 26/09/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDataEngine.h"
#import "ItemListViewCell.h"

@interface ItemListViewController : UITableViewController<XDataEngineDelegate> {
	long projectId;
	IBOutlet ItemListViewCell* itemCell;
}

@property (assign) long projectId;

@end
