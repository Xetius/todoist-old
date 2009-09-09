//
//  DMTaskItem.m
//  Todoist
//
//  Created by Chris Hudson on 10/08/2009.
//  Copyright 2009 Xetius Services Ltd. All rights reserved.
//

#import "DMTaskItem.h"
#import "RegexKitLite.h"

#define INTER_WORD_SPACING	4
#define INTER_LINE_SPACING	2
#define CONTENT_FONT_SIZE	14

@implementation DMTaskItem

@synthesize delegate;
@synthesize completed;
@synthesize words;
@synthesize formats;
@synthesize simpleFormat;
@synthesize indent;
@synthesize paragraph;
@synthesize priority;

-(void) drawInRect:(CGRect) rect {
	
	CGPoint pt = CGPointMake (0.0, 0.0);
	
	int max_item = [self.words count];
	for (int i = 0; i<max_item; i++) {
		
		BOOL shortenWord = NO;
		// Calculate the space available for the single word with the formatting
		NSString* word = [self.words objectAtIndex:i];
		NSString* format = [self.formats objectAtIndex:i];
		
		CGSize sz = [delegate sizeForWord:word withFormat:format];
		if (pt.x + sz.width > rect.size.width) {
			pt.y += (sz.height + INTER_LINE_SPACING);
			pt.x = 0.0;
			
			// Shorten the word on the next line
			if (sz.width > rect.size.width) {
				shortenWord = YES;
				sz.width = rect.size.width;
			} 
		}
		
		[word drawAtPoint:pt withFont:[UIFont systemFontOfSize:CONTENT_FONT_SIZE]];
		pt.x += (sz.width + INTER_WORD_SPACING);
	}
}

-(CGFloat) contentHeightForWidth:(CGFloat) width {
	CGPoint pt = CGPointZero;	
	CGFloat rowHeight = 0.0;
	
	int max_item = [self.words count];
	for (int i = 0; i<max_item; i++) {
		
		BOOL shortenWord = NO;
		// Calculate the space available for the single word with the formatting
		NSString* word = [self.words objectAtIndex:i];
		NSString* format = [self.formats objectAtIndex:i];
		CGSize sz = [delegate sizeForWord:word withFormat:format];
		rowHeight = sz.height;
		if (pt.x + sz.width > width) {
			pt.y += (sz.height + INTER_LINE_SPACING);
			pt.x = 0.0;
			
			// Shorten the word on the next line
			if (sz.width > width) {
				shortenWord = YES;
				sz.width = width;
			} 
		}
		pt.x += (sz.width + INTER_WORD_SPACING);
	}
	
	return (pt.y + rowHeight);
}

-(void) setContent:(NSString*) cont
{
	self.words = [[self wordsForContent:cont] retain];
	//self.formats = [[self formatForContent:cont] retain];
	//self.simpleFormat = [[self buildSimpleFormat:self.formats] retain];
}

-(NSString*) contentWithoutFormatting:(NSString*) cont {
	NSString* stringWithoutFormat = [cont stringByReplacingOccurrencesOfRegex:@"%\\((.+?)\\)\\s*([^%]+?)%" withString:@" $2"];
	
	return [stringWithoutFormat autorelease];
}

-(NSArray*) wordsForContent:(NSString*) cont {
	
	NSString* stringWithoutFormat = [cont stringByReplacingOccurrencesOfRegex:@"%\\((.+?)\\)\\s*([^%]+?)%" withString:@" $2"];
	NSArray* arrayOfWords = [stringWithoutFormat componentsSeparatedByRegex:@"\\s+"];
	
	return arrayOfWords;
}

-(NSArray*) formatForContent:(NSString*) cont {
	
	const char* original = [cont cStringUsingEncoding:NSUTF8StringEncoding];
	char* formatted = malloc((strlen(original) + 1) * sizeof (char));
	strcpy(formatted, original);
	char* charPtr = formatted;
	BOOL inFormat = NO;	
	char format = 'a';

	while (*charPtr) {
		
		if (*charPtr == ' ') {
			// Do nothing, leave as space
		}
		else if (inFormat) {
			if (*charPtr != '%') {
				*charPtr = format;
			}
			else {
				inFormat = NO;
				format = 'a' + DMTaskItemFormatNone;
			}
		}
		else {
			if (*charPtr == '%' && *(charPtr+1) == '(') {
				BOOL lookAhead = YES;
				char* lookAheadPtr = charPtr+2;
				unsigned char newFormat = DMTaskItemFormatNone;
				while (lookAhead) {
					if (*lookAheadPtr) {
						if (*lookAheadPtr == ')') {
							lookAhead = NO;
							inFormat = YES;
							charPtr = lookAheadPtr ++; 
							format = 'a' + newFormat;
						}
						else {
							switch (*lookAheadPtr) {
								case 'b':
									{
										newFormat |= DMTaskItemFormatBold;
									}
									break;
								case 'i':
									{
										newFormat |= DMTaskItemFormatItalic;
									}
									break;
								case 'u':
									{
										newFormat |= DMTaskItemFormatUnderline;
									}
									break;
								case 'h':
									{
										if (*lookAheadPtr+1 == 'l') {
											newFormat |= DMTaskItemFormatHighlight;
											*lookAheadPtr++;
										}
										else {
											// h not followed by l so not a valid format
											lookAhead = NO;
										}
									}
									break;
								default:
									break;
							}
						}
						lookAheadPtr++;
					}
					else {
						lookAhead = NO;
					}					
				}
			} 
			else {
				*charPtr = format;
			}
		}
		charPtr++;
	}
	
	NSString* newString = [[[NSString alloc] initWithUTF8String:formatted] autorelease];
	free(formatted);	
	return [self wordsForContent:newString];
}

-(NSArray*) buildSimpleFormat:(NSArray*) arrayOfFormats {
	NSMutableArray* simple = [NSMutableArray array];
	
	for (int i=0; i<[arrayOfFormats count]; i++) {
		NSString* formatString = [arrayOfFormats objectAtIndex:i];
		NSString* firstChar = [formatString substringToIndex:1];
		BOOL isSimple = [formatString isMatchedByRegex:[NSString stringWithFormat:@"^%@+$", firstChar]];
		NSNumber* boolNumber = [NSNumber numberWithBool:isSimple];
		[simple addObject:boolNumber];
		DLog (@"%@ : %@", [formats objectAtIndex:i], (isSimple?@"YES":@"NO"));
	}
	
	return [NSArray arrayWithArray:simple];
}

-(void) dealloc {

	[words release];
	[formats release];
	[simpleFormat release];
	[super dealloc];
}
@end
