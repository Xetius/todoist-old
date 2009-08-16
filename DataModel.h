//
//  DataModel.h
//  Todoist
//
//  Created by Chris Hudson on 10/08/2009.
//  Copyright 2009 Xetius Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON/JSON.h";
#import "DMUserDetails.h";
#import "DMProjectItem.h";
#import "DMLabelItem.h";

@interface DataModel : NSObject {
	DMUserDetails* userDetails;
	NSArray* projects;
	NSDictionary* labels;
	
	BOOL isLoggedIn;
}

@property BOOL isLoggedIn;
@property (copy) DMUserDetails* userDetails;
@property (copy) NSArray* projects;
@property (copy) NSDictionary* labels;

-(BOOL) login;
-(BOOL) loginWithUserName:(NSString*) userName AndPassword:(NSString*) password;
-(BOOL) loadProjects;
-(BOOL) loadLabels;
-(BOOL) loadItemsForProject:(long)projectId;
@end
