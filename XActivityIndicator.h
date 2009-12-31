//
//  XActivityIndicator.h
//  Todoist
//
//  Created by Chris Hudson on 15/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XActivityIndicator : UIView {
	UIImage* overlay;
	UIImageView* back;
	UIActivityIndicatorView* indicator;
	UILabel* label;
}

@property (retain) UIImage* overlay;
@property (retain) UIImageView* back;
@property (retain) UIActivityIndicatorView* indicator;
@property (retain) UILabel* label;

-(void) showActivityIndicator:(BOOL)show;
-(void) showActivityIndicator:(BOOL)show withCenter:(CGPoint)point;
-(void) setText:(NSString *)newText;

@end
