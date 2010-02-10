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

- (void)drawRect:(CGRect)r
{
	[(XTableViewCellBase *)[self superview] drawContentView:r];
}

@end



@implementation XTableViewCellBase

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
		contentView = [[XTableViewCellBaseView alloc] initWithFrame:CGRectZero];
		contentView.opaque = YES;
		[self addSubview:contentView];
		[contentView release];
    }
    return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)setNeedsDisplay
{
	[super setNeedsDisplay];
	[contentView setNeedsDisplay];
}

- (void)drawContentView:(CGRect)r
{
	// subclasses should implement this
}

@end
