//
//  XTableViewCellBase.m
//  CustomDrawnCell
//
//  Created by Chris Hudson on 10/07/2009.
//  Copyright 2009 Xetius Software Ltd. All rights reserved.
//

#import "XTableViewCellBase.h"

@interface XTableViewCellBaseView : UIView
@end

@implementation XTableViewCellBaseView

-(void) drawRect:(CGRect) r {
	[(XTableViewCellBase*)[self superview] drawContentView:r];
}

@end

@implementation XTableViewCellBase

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		contentView = [[XTableViewCellBaseView alloc] initWithFrame:CGRectZero];
		contentView.opaque = YES;
		[self addSubview:contentView];
		[contentView release];
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)setFrame:(CGRect) f {
	[super setFrame:f];
	CGRect b = [self bounds];
	b.size.height -= 1;
	[contentView setFrame:b];
}

-(void)setNeedsDisplay {
	[super setNeedsDisplay];
	[contentView setNeedsDisplay];
}

- (void)drawContentView:(CGRect) rect {
	// subclasses must implement this
}

@end
