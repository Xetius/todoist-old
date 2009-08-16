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
	NSOperationQueue* operationQueue;
	
	DMUserDetails* userDetails;
	BOOL isLoggedIn;
}

@property (nonatomic, retain) XActivityIndicator* largeActivityIndicator;
@property (nonatomic, retain) SplashScreen* splashScreen;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (retain) NSOperationQueue* operationQueue;
@property (retain) DMUserDetails* userDetails;
@property (assign) BOOL isLoggedIn;

-(void) beginLogon;
-(void) performLogon;
-(void) didFinishLogon;
-(void) showSplashScreen:(BOOL) show;
-(void) createSplashScreen;
-(void) showActivityIndicator:(BOOL)show;
-(void) showActivityIndicator:(BOOL)show withCenter:(CGPoint)point;
-(void) createLargeActivityIndicatorView;

@end

