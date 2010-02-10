//
//  XDataEngine.h
//  Todoist
//
//  Created by Chris Hudson on 05/10/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMUserDetails.h"
#import "XConnectionHandler.h"

@interface XDataEngine : NSObject<XConnectionHandlerDelegate> {
	DMUserDetails* userDetails;
	NSArray* projects;
	NSDictionary* labels;
	NSMutableDictionary* items;
	
	NSMutableDictionary* connectionHandlers;
}

@property (retain) NSMutableDictionary* items;
@property (retain) NSArray* projects;
@property (retain) NSDictionary* labels;
@property (retain) DMUserDetails* userDetails;
@property (retain) NSMutableDictionary* connectionHandlers;

-(DMUserDetails*) userDetailsWithDelegate:(NSObject<XDataEngineDelegate>*) delegate;
-(void) initUserData:(NSObject<XDataEngineDelegate>*) delegate;
-(void) saveUserData:(NSData*) requestData;

-(NSArray*) projectsWithDelegate:(NSObject<XDataEngineDelegate>*) delegate;
-(void) initProjectData:(NSObject<XDataEngineDelegate>*) delegate;
-(void) saveProjectData:(NSData*) requestData;

-(NSDictionary*) labelsWithDelegate:(NSObject<XDataEngineDelegate>*) delegate;
-(void) initLabelsData:(NSObject<XDataEngineDelegate>*) delegate;
-(void) saveLabelData:(NSData*) requestData;

-(NSArray*) itemsForProjectId:(int)projectId withDelegate:(NSObject<XDataEngineDelegate>*) delegate;
-(void) initUncompleteItemsDataForProjectId:(int) projectId withDelegate:(NSObject<XDataEngineDelegate>*) delegate;
-(void) initCompleteItemsDataForProjectId:(int) projectId withDelegate:(NSObject<XDataEngineDelegate>*) delegate;
-(void) saveUncompleteItemData:(NSData*) requestData forProjectId:(int) projectId;
-(void) saveCompleteItemData:(NSData*) requestData forProjectId:(int) projectId;

-(NSString*) idStringForId:(int) dataId;
-(NSString*) idStringForId:(int) dataId andProjectId:(int) projectId;

@end
