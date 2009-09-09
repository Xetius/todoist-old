//
//  ItemListItemTableViewCell.h
//  Todoist
//
//  Created by Chris Hudson on 24/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableViewCellBase.h"
#import "DMTaskItem.h"

@interface ItemListItemTableViewCell : XTableViewCellBase {
	DMTaskItem* details;
	UIFont* normalFont;
	UIFont* boldFont;
	UIFont* italicFont;
	UIFont* boldItalicFont;
}

@property (retain) DMTaskItem* details;
@property (retain) UIFont* normalFont;
@property (retain) UIFont* boldFont;
@property (retain) UIFont* italicFont;
@property (retain) UIFont* boldItalicFont;

-(CGFloat) cellHeightForWidth:(CGFloat) width;

-(CGSize) sizeForWord:(NSString*) word withFormat:(NSString*) format;
-(void) drawWord:(NSString*) word atPoint:(CGPoint) pt withFormat:(NSString*) format onContext:(CGContextRef) context;

@end
