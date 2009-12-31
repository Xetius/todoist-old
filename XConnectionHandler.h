//
//  XConnectionHandlerBase.h
//  Todoist
//
//  Created by Chris Hudson on 14/09/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XDataEngineDelegate

-(void) dataDidCompleteForId:(int) dataId;

@end

@protocol XConnectionHandlerDelegate

-(void) connectionDidFinishLoading:(int) connectionId withData:(NSData*) requestData;
-(void) connectionDidFinishLoading:(int) connectionId withData:(NSData*) requestData andProjectId:(int) projectId;
-(void) connectionDidFailLoading:(int) connectionId withError:(NSError*) error;
-(void) connectionDidFailLoading:(int) connectionId withError:(NSError*) error andProjectId:(int) projectId;

@end

@interface XConnectionHandler : NSObject {
	int connectionId;
	NSObject<XConnectionHandlerDelegate>* delegate;
	NSObject<XDataEngineDelegate>* requestDelegate;
	NSMutableData* requestData;
	int projectId;
}

@property (assign) int connectionId;
@property (retain) NSObject<XConnectionHandlerDelegate>* delegate;
@property (retain) NSObject<XDataEngineDelegate>* requestDelegate;
@property (retain) NSMutableData* requestData;
@property (assign) int projectId;

-(id) initWithId:(int) newConnectionId andDelegate:(NSObject<XConnectionHandlerDelegate>*) newDelegate;

@end
