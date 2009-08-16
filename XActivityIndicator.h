//
//  XActivityIndicator.h
//  Todoist
//
//  Created by Chris Hudson on 15/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XActivityIndicator : UIView {

}

-(void)showActivityIndicator:(BOOL)show;
-(void)showActivityIndicator:(BOOL)show withCenter:(CGPoint)point;

@end
