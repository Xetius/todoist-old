//
//  UIColor+colorForHex.h
//  Todoist
//
//  Created by Chris Hudson on 11/07/2009.
//  Copyright 2009 Xetius Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor(Hex)

+ (UIColor*) colorForHex:(NSString*) hexColor;
+ (UIColor*) colorForHex:(NSString*) hexColor withAlpha:(float) a;

@end
