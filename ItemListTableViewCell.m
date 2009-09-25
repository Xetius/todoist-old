//
//  ItemListTableViewCell.m
//  Todoist
//
//  Created by Chris Hudson on 11/09/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import "ItemListTableViewCell.h"
#import "UIColor+Hex.h"
#import "RegexKitLite.h"

@implementation ItemListTableViewCell

@synthesize details;
@synthesize cellDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [super dealloc];
}

- (void)drawContentView:(CGRect) rect {
	// subclasses must implement this
	DLog (@"start Drawing Cell Content");
	CGContextRef context = UIGraphicsGetCurrentContext();	
	
	UIColor* backgroundColor = [[cellDelegate colorForId:BACKGROUND_COLOR_ID] retain];
	[backgroundColor set];
	CGContextFillRect(context, rect);
	[backgroundColor release];
	
	// Adjust for checkbox (Which we will create later TODO:)
	rect.origin.x += 40;
	rect.size.width -= 40;
	
	// Adjust for indent;
	rect.origin.x += ((self.details.indent - 1) * INDENT_SIZE);
	rect.size.width -= ((self.details.indent - 1) * INDENT_SIZE);
	
	CGPoint pt = rect.origin;
	pt.y += ITEM_LIST_TOP_BORDER;
	
	if (self.details.labels) {
		DLog (@"Drawing labels");
		UIFont* labelFont = [[cellDelegate fontForId:LABEL_FONT_ID] retain];
		CGSize labelsSize = [self.details.labels sizeWithFont:labelFont constrainedToSize:rect.size];
		
		UIColor* labelColor = [[cellDelegate colorForId:LABEL_COLOR_ID] retain]; 
		[labelColor set];
		[self drawText:self.details.labels atPoint:pt withFont:labelFont forWidth:rect.size.width];
		[labelColor release];
		[labelFont release];
	}
	else {
		DLog (@"No labels to draw");
	}

//	pt.y += labelsSize.height;
//	pt.y += ITEM_LIST_PADDING;
//	switch (self.details.priority) {
//		case 1:
//		{
//			textColor = p1color;
//		}
//			break;
//		case 2:
//		{
//			textColor = p2color;
//		}
//			break;
//		case 3:
//		{
//			textColor = p3color;
//		}
//			break;
//		case 4:
//		{
//			textColor = p4color;
//		}
//			break;
//		default:
//		{
//			textColor = p4color;
//		}
//			break;
//	}
//	[textColor set];
//	[self drawText:self.details.content atPoint:pt withFont:[UIFont systemFontOfSize:CONTENT_FONT_SIZE] forWidth:rect.size.width];
	DLog (@"end Drawing Cell Content");
}

-(CGFloat) cellHeightForWidth:(CGFloat) width {	
	DLog (@"start Calculate Cell Height");
	width -= 40;
	width -= ((self.details.indent - 1) * INDENT_SIZE);
	if (self.details.labels) {
		UIFont* labelFont = [[cellDelegate fontForId:LABEL_FONT_ID] retain];
		//UIFont* contentFont = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
		CGSize labelSize = [self.details.labels sizeWithFont:labelFont constrainedToSize:CGSizeMake(width, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
		//CGSize contentSize = [self.details.content sizeWithFont:contentFont constrainedToSize:CGSizeMake(width, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
		//DLog(@"Label Height:%0.2f - Content Height:%0.2f", labelSize.height, contentSize.height);
		[labelFont release];
		return labelSize.height + ITEM_LIST_TOP_BORDER + ITEM_LIST_BOTTOM_BORDER;
	}
	else {
		return ITEM_LIST_TOP_BORDER + ITEM_LIST_BOTTOM_BORDER;
	}
	DLog (@"end Calculate Cell Height");
}


-(CGFloat) drawText:(NSString*) text atPoint:(CGPoint) pt withFont:(UIFont*) font forWidth:(CGFloat) width {

	CGSize sz = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
	CGRect rect = CGRectMake(pt.x, pt.y, sz.width, sz.height);
	[text drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap];
	
	return sz.height;
}

@end
