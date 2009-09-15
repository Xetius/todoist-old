//
//  ItemListTableViewCell.h
//  Todoist
//
//  Created by Chris Hudson on 11/09/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableViewCellBase.h"
#import "DMTaskItem.h"

@interface ItemListTableViewCell : XTableViewCellBase {
	DMTaskItem* details;
}

@property (retain) DMTaskItem* details;

-(CGFloat) cellHeightForWidth:(CGFloat) width;

@end
