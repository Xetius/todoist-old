//
//  DMTaskItem.h
//  Todoist
//
//  Created by Chris Hudson on 10/08/2009.
//  Copyright 2009 Xetius Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
	DMTaskItemFormatNone = 0,
	DMTaskItemFormatBold = 1,
	DMTaskItemFormatItalic = 2,
	DMTaskItemFormatUnderline = 4,
	DMTaskItemFormatHighlight = 8,
	DMTaskItemFormatMax = 15
};
typedef uint32_t DMTaskItemFormat;

@protocol DMTaskItemDelegate

-(UIFont*) fontForFormat:(DMTaskItemFormat) format;
-(CGSize) sizeForWord:(NSString*) word withFormat:(NSString*) format;

@end


@interface DMTaskItem : NSObject {
	NSObject<DMTaskItemDelegate>* delegate;
	BOOL completed;
	NSArray* words;
	NSArray* formats;
	NSArray* simpleFormat;
	NSString* paragraph;
	
	int priority;
	int indent;
}

@property (retain) NSObject<DMTaskItemDelegate>* delegate;
@property (assign) BOOL completed;
@property (retain) NSArray* words;
@property (retain) NSArray* formats;
@property (retain) NSArray* simpleFormat;
@property (assign) int indent;
@property (assign) int priority;
@property (retain) NSString* paragraph;

-(void) drawInRect:(CGRect) rect;
-(void) setContent:(NSString*) cont;
-(void) drawWord:(NSString*) word atPoint:(CGPoint) pt withFormat:(NSString*) format;
-(NSArray*) wordsForContent:(NSString*) cont;
-(NSArray*) formatForContent:(NSString*) cont;
-(NSArray*) buildSimpleFormat:(NSArray*) formatArray;
-(CGFloat) contentHeightForWidth:(CGFloat) width;

@end
