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

@protocol ItemListTableViewCellDelegate
-(UIFont*) fontForId:(int) fontID;
-(UIColor*) colorForId:(int) colorID;
@end

@interface ItemListTableViewCell : XTableViewCellBase {
	DMTaskItem* details;
	NSObject<ItemListTableViewCellDelegate>* cellDelegate;
}

@property (retain) DMTaskItem* details;
@property (retain) NSObject<ItemListTableViewCellDelegate>* cellDelegate;

-(CGFloat) cellHeightForWidth:(CGFloat) width;
-(CGFloat) drawText:(NSString*) text atPoint:(CGPoint) pt withFont:(UIFont*) font forWidth:(CGFloat) width;

@end
