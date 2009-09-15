//
//  ItemListTableViewCell.m
//  Todoist
//
//  Created by Chris Hudson on 11/09/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import "ItemListTableViewCell.h"
#import "UIColor+Hex.h"

@implementation ItemListTableViewCell

@synthesize details;

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
	DLog (@"Drawing Cell Content");
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIColor* backgroundColor	= [UIColor colorForHex:@"FFFEFF"];
	UIColor* labelColor			= [UIColor colorForHex:@"008800"];
	UIColor* p1color			= [UIColor colorForHex:@"FF0000"];
	UIColor* p2color			= [UIColor colorForHex:@"0079B5"];
	UIColor* p3color			= [UIColor colorForHex:@"008800"];
	UIColor* p4color			= [UIColor colorForHex:@"262626"];
	UIColor* textColor = p4color;
	
	[backgroundColor set];
	CGContextFillRect(context, rect);

	// Adjust for checkbox (Which we will create later TODO:)
	rect.origin.x += 40;
	rect.size.width -= 40;
	
	// Adjust for indent;
	rect.origin.x += ((self.details.indent - 1) * INDENT_SIZE);
	rect.size.width -= ((self.details.indent - 1) * INDENT_SIZE);
	
	NSString* labels = [self.details.labels componentsJoinedByString:@" "];
	CGSize labelsSize = [labels sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT_SIZE] forWidth:rect.size.width lineBreakMode:UILineBreakModeWordWrap];
	
	CGPoint pt = rect.origin;
	pt.y += ITEM_LIST_TOP_BORDER;
	
	[labelColor set];
	[labels drawAtPoint:pt forWidth:rect.size.width withFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE] lineBreakMode:UILineBreakModeWordWrap];
	pt.y += labelsSize.height;
	pt.y += ITEM_LIST_PADDING;
	switch (self.details.priority) {
		case 1:
		{
			textColor = p1color;
		}
			break;
		case 2:
		{
			textColor = p2color;
		}
			break;
		case 3:
		{
			textColor = p3color;
		}
			break;
		case 4:
		{
			textColor = p4color;
		}
			break;
		default:
		{
			textColor = p4color;
		}
			break;
	}
	[textColor set];
	[self.details.content drawAtPoint:pt forWidth:rect.size.width withFont:[UIFont systemFontOfSize:CONTENT_FONT_SIZE] lineBreakMode:UILineBreakModeWordWrap];
}

-(CGFloat) cellHeightForWidth:(CGFloat) width {
	
	width -= 40;
	width -= ((self.details.indent - 1) * INDENT_SIZE);
	
	CGSize labelsSize = [[self.details.labels componentsJoinedByString:@" "] sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT_SIZE] forWidth:width lineBreakMode:UILineBreakModeWordWrap];
	CGSize contentSize = [self.details.content sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE] forWidth:width lineBreakMode:UILineBreakModeWordWrap];
	
	return labelsSize.height + contentSize.height + ITEM_LIST_TOP_BORDER + ITEM_LIST_BOTTOM_BORDER + ITEM_LIST_PADDING;
}

@end
