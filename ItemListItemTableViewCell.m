//
//  ItemListItemTableViewCell.m
//  Todoist
//
//  Created by Chris Hudson on 24/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//

#import "RegexKitLite.h"
#import "ItemListItemTableViewCell.h"
#import "UIColor+Hex.h"

@implementation ItemListItemTableViewCell

@synthesize details;
@synthesize	normalFont;
@synthesize boldFont;
@synthesize italicFont;
@synthesize boldItalicFont;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setDetails:(DMTaskItem*) newDetails {

	if (details != newDetails) {
		[details release];
		details = [newDetails retain];
	}
	
	[self setNeedsDisplay];
}

- (void)dealloc {
    [super dealloc];
}

-(CGFloat) cellHeightForWidth:(CGFloat) width {
	return [self.details contentHeightForWidth:width];
}

- (void)drawContentView:(CGRect) rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIColor* backgroundColor	= [UIColor colorForHex:@"FFFEFF"];
	UIColor* textColor			= [UIColor colorForHex:@"262626"];
	
	[backgroundColor set];
	DLog (@"Fill Rect");
	CGContextFillRect(context, rect);
	
	[textColor set];
	[details drawInRect:rect];
}

@end
