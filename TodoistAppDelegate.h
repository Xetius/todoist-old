//
//  TodoistAppDelegate.h
//  Todoist
//
//  Created by Chris Hudson on 14/08/2009.
//  Copyright Xetius Services Ltd. 2009. All rights reserved.
//

#import "SplashScreen.h"
#import "DMUserDetails.h"
#import "XActivityIndicator.h"
#import "XConnectionHandler.h"

@interface TodoistAppDelegate : NSObject <UIApplicationDelegate, XConnectionHandlerDelegate> {
    
	XActivityIndicator* largeActivityIndicator;
	SplashScreen* splashScreen;
    UIWindow *window;
    UINavigationController *navigationController;
	
	DMUserDetails* userDetails;
	NSArray* projects;
	NSDictionary* labels;
	
	BOOL isLoggedIn;
	
	NSMutableDictionary* connectionHandlers;
	int connectionLoaded;
}

@property (nonatomic, retain) XActivityIndicator* largeActivityIndicator;
@property (nonatomic, retain) SplashScreen* splashScreen;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (retain) DMUserDetails* userDetails;
@property (retain) NSArray* projects;
@property (retain) NSDictionary* labels;
@property (assign) BOOL isLoggedIn;
@property (retain) NSMutableDictionary* connectionHandlers;
@property (assign) int connectionLoaded;

-(void) beginLogon;
-(void) showSplashScreen:(BOOL) show;
-(void) createSplashScreen;
-(void) showActivityIndicator:(BOOL)show;
-(void) showActivityIndicator:(BOOL)show withCenter:(CGPoint)point;
-(void) createLargeActivityIndicatorView;
-(void) saveUserData:(NSData*) requestData;
-(void) initRequestsForLabelsAndProjects;
-(void) loadLabelsData:(NSData *)requestData;
-(void) loadProjectsData:(NSData *)requestData;
-(void) allDataLoaded;
@end

