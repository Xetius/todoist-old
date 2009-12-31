//
//  XConnectionHandlerBase.m
//  Todoist
//
//  Created by Chris Hudson on 14/09/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import "XConnectionHandler.h"

@implementation XConnectionHandler

@synthesize connectionId;
@synthesize delegate;
@synthesize requestDelegate;
@synthesize requestData;
@synthesize projectId;

-(id) initWithId:(int) newConnectionId andDelegate:(NSObject<XConnectionHandlerDelegate>*) newDelegate
{
	if (self = [super init]) {
		delegate = [newDelegate retain];
		connectionId = newConnectionId;
		requestData = [[NSMutableData data] retain];
		requestDelegate = nil;
		projectId = 0;
	}

	return self;
}

-(void) dealloc {
	[delegate release];
	[requestDelegate release];
	[requestData release];
	[super dealloc];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	DLog (@"XConnectionHandler::connection:didReceiveResponse");
    [requestData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	DLog (@"XConnectionHandler::connection:didReceiveData");
    [requestData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLog (@"XConnectionHandler::connection:didFailWithError");
    [requestData release];
	[connection release];
	
    // inform the user
    DLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);

	if (projectId != 0) {
		[delegate connectionDidFailLoading:[self connectionId] withError:error andProjectId:projectId];
	}
	else {
		[delegate connectionDidFailLoading:[self connectionId] withError:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    DLog (@"XConnectionHandler::connectiondidFinishLoading");
	if (projectId != 0) {
		DLog (@"Calling connectionDidFinishLoading with project id:%d", [self projectId]);
		[delegate connectionDidFinishLoading:[self connectionId] withData:[self requestData] andProjectId:[self projectId]];
	}
	else {
		DLog (@"Calling connectionDidFinishLoading without project id");
		[delegate connectionDidFinishLoading:[self connectionId] withData:[self requestData]];
	}

}

@end
