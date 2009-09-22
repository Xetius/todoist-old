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
@synthesize requestData;

-(id) initWithId:(int) newConnectionId andDelegate:(NSObject<XConnectionHandlerDelegate>*) newDelegate
{
	if (self = [super init]) {
		delegate = newDelegate;
		connectionId = newConnectionId;
		requestData = [[NSMutableData data] retain];
	}

	return self;
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
	[connection release];
    [requestData release];
	
    // inform the user
    DLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	[delegate connectionDidFailLoading:[self connectionId] withError:error]; 
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    DLog (@"XConnectionHandler::connectiondidFinishLoading");
	[delegate connectionDidFinishLoading:[self connectionId] withData:[self requestData]];
}

@end
