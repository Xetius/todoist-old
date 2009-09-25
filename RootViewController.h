//
//  RootViewController.h
//  Todoist
//
//  Created by Chris Hudson on 14/08/2009.
//  Copyright Xetius Services Ltd. 2009. All rights reserved.
//

#import "XConnectionHandler.h"

@interface RootViewController : UITableViewController <XConnectionHandlerDelegate> {
	NSArray* projects;
	NSDictionary* labels;
	NSMutableDictionary* connectionHandlers;
	int loadedData;
	NSArray* uncompleteItems;
	NSArray* completeItems;
	NSString* api_token;
}

@property (retain) NSArray* projects;
@property (retain) NSDictionary* labels;
@property (retain) NSMutableDictionary* connectionHandlers;
@property (assign) int loadedData;
@property (retain) NSArray* uncompleteItems;
@property (retain) NSArray* completeItems;
@property (retain) NSString* api_token;

-(void) connectionDidFinishLoading:(int) connectionId withData:(NSData*) requestData;
-(void) loadUncompleteItems:(NSData*) requestData;
-(void) loadCompleteItems:(NSData*) requestData;
-(void) loadNextPage;

@end
