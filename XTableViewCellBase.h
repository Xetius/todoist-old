//
//  XTableViewCellBase.h
//  CustomDrawnCell
//
//  Created by Chris Hudson on 10/07/2009.
//  Copyright 2009 Xetius Software Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XTableViewCellBase : UITableViewCell {
	UIView* contentView;
}

- (void)drawContentView:(CGRect) rect;

@end
