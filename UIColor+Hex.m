//
//  UIColor+colorForHex.m
//  Todoist
//
//  Created by Chris Hudson on 11/07/2009.
//  Copyright 2009 Xetius Software Ltd. All rights reserved.
//

#import "UIColor+Hex.h"


@implementation UIColor(Hex)


+ (UIColor*) colorForHex:(NSString*) hexColor {
	return [UIColor colorForHex:hexColor withAlpha:1.0f];
}

+ (UIColor*) colorForHex:(NSString*) hexColor withAlpha:(float) a {
	hexColor = [[hexColor stringByTrimmingCharactersInSet:
				 [NSCharacterSet whitespaceAndNewlineCharacterSet]
				 ] uppercaseString];  
	
	if ([hexColor length] < 6) {
		return [UIColor blackColor];
	}
	
	if ([hexColor hasPrefix:@"#"])
	{
		hexColor = [hexColor substringFromIndex:1];
	}
	
	if ([hexColor length] != 6) {
		return [UIColor blackColor];
	}
	
	NSRange range;
	range.location = 0;
	range.length = 2;
	
	NSString* rString = [hexColor substringWithRange:range];
	
	range.location = 2;
	NSString* gString = [hexColor substringWithRange:range];
	
	range.location = 4;
	NSString* bString = [hexColor substringWithRange:range];
	
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r/255.0f) green:((float) g/255.0f) blue:((float) b/255.0f) alpha:a];
}

@end
