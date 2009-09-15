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

@interface TodoistAppDelegate : NSObject <UIApplicationDelegate> {
    
	XActivityIndicator* largeActivityIndicator;
	SplashScreen* splashScreen;
    UIWindow *window;
    UINavigationController *navigationController;
	
	DMUserDetails* userDetails;
	BOOL isLoggedIn;
	
	NSMutableData* requestData;
}

@property (nonatomic, retain) XActivityIndicator* largeActivityIndicator;
@property (nonatomic, retain) SplashScreen* splashScreen;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (retain) DMUserDetails* userDetails;
@property (assign) BOOL isLoggedIn;
@property (retain) NSMutableData* requestData;

-(void) beginLogon;
-(void) showSplashScreen:(BOOL) show;
-(void) createSplashScreen;
-(void) showActivityIndicator:(BOOL)show;
-(void) showActivityIndicator:(BOOL)show withCenter:(CGPoint)point;
-(void) createLargeActivityIndicatorView;

@end

