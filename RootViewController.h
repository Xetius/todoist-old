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
	
	BOOL projectsNeedReloading;
	BOOL labelsNeedReloading;
}

@property (retain) NSArray* projects;
@property (retain) NSDictionary* labels;
@property (retain) NSMutableDictionary* connectionHandlers;
@property (assign) BOOL projectsNeedReloading;
@property (assign) BOOL labelsNeedReloading;

-(void) initLoadData;
-(void) connectionDidFinishLoading:(int) connectionId withData:(NSData*) requestData;
-(void) loadProjectData:(NSData*) requestData;
-(void) loadLabelsData:(NSData*) requestData;

@end
