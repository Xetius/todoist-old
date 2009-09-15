//
//  XConnectionHandlerBase.h
//  Todoist
//
//  Created by Chris Hudson on 14/09/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XConnectionHandlerDelegate

-(void) connectionDidFinishLoading:(int) connectionId withData:(NSData*) requestData;

@end

@interface XConnectionHandler : NSObject {
	int connectionId;
	NSObject<XConnectionHandlerDelegate>* delegate;
	NSMutableData* requestData;
}

@property (assign) int connectionId;
@property (retain) NSObject<XConnectionHandlerDelegate>* delegate;
@property (retain) NSMutableData* requestData;

-(id) initWithId:(int) newConnectionId andDelegate:(NSObject<XConnectionHandlerDelegate>*) newDelegate;

@end
