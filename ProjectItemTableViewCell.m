//
//  ProjectItemTableViewCell.m
//  Todoist
//
//  Created by Chris Hudson on 16/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//

#import "ProjectItemTableViewCell.h"
#import "UIColor+Hex.h"

@implementation ProjectItemTableViewCell

@synthesize content;
@synthesize count;
@synthesize color;
@synthesize indent;

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

-(void) setContent:(NSString*) s
{
	if (content != s)
	{
		[content release];
		content = [s retain];
	}
	[self setNeedsDisplay];
}

-(void) setCount:(int) n
{
	count = n;
	[self setNeedsDisplay];
}

-(void) setIndent:(int) n
{
	indent = n;
	[self setNeedsDisplay];
}

- (void)drawContentView:(CGRect) r {
	DLog (@"drawContentRect");

	// subclasses must implement this
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIColor* backgroundColor	= [UIColor colorForHex:@"FFFEFF"];
	UIColor* textColor			= [UIColor colorForHex:@"262626"];
	
	if (self.selected)
	{
		backgroundColor = [UIColor clearColor];
		textColor		= [UIColor colorForHex:@"FFFEFF"];
	}
	
	[backgroundColor set];
	DLog (@"Fill Rect");
	CGContextFillRect(context, r);
	
	// Rectangle r contains the whole bounds of the cell rectangle.
	// We need to offset the cell correctly
	double offset = (INDENT_SIZE * ([self indent] - 1.0));
	DLog (@"Indent Offset: %f", offset);
	r.origin.x += offset;
	r.size.width -= offset;
	
	// Now we need to calculate the rectangle for the backing of the count
	// Start with same as r
	CGRect colorRect = r;
	// Now make it square
	colorRect.size.width = colorRect.size.height;
	// And inset it by 2 px each side
	colorRect = CGRectInset(colorRect, 5.0, 5.0);
	// Now we have this, r forward by the height of the cell (Because we made the colour square... square)
	r.origin.x += r.size.height;
	r.size.width += r.size.height;
	
	// Now we can set the colour and draw the square
	[[self color] set];
	CGContextFillRect(context, colorRect);
	
	// Draw the count in the colour square
	// Set the text colour and write the item count into the square
	[textColor set];
	UIFont* countFont = [UIFont systemFontOfSize:16];
	NSString* itemCount = [NSString stringWithFormat:@"%d", [self count]];
	
	// Get size of the text
	CGSize textSize = [itemCount sizeWithFont:countFont];
	// Calculate difference to colorRect.size
	float dx = colorRect.size.width - textSize.width;
	float dy = colorRect.size.height - textSize.height;
	// reduce colorRect to size of text.  This ensures that it keeps it centred.
	colorRect = CGRectInset(colorRect, dx/2.0, dy/2.0);
	// draw the text in this rect
	[itemCount drawInRect:colorRect withFont:countFont lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
	
	// Now draw the content text now
	UIFont* contentFont = [UIFont systemFontOfSize:18];
	// Size of the text
	CGSize contentSize = [content sizeWithFont:contentFont];
	// Calculate difference to rect r
	dx = r.size.width - contentSize.width;
	dy = r.size.height - contentSize.height;
	// resize to make the rect the same size as the contentRect
	// set the width.  origin.x should be the same as before
	r.size.width -= dx;
	// Inset height by y to centre it
	r = CGRectInset(r, 0.0, dy/2.0);
	// draw the content text in this rect
	[content drawInRect:r withFont:contentFont lineBreakMode:UILineBreakModeTailTruncation];
}


@end
