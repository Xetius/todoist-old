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

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        
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

- (void)drawContentView:(CGRect) r {
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
	CGContextFillRect(context, r);
}


@end
