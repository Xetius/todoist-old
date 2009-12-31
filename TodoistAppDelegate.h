//
//  TodoistAppDelegate.h
//  Todoist
//
//  Created by Chris Hudson on 14/08/2009.
//  Copyright Xetius Services Ltd. 2009. All rights reserved.
//

#import "SplashScreen.h"
#import "XActivityIndicator.h"
#import "XDataEngine.h"

@interface TodoistAppDelegate : NSObject <UIApplicationDelegate, XDataEngineDelegate> {
    
	XActivityIndicator* largeActivityIndicator;
	SplashScreen* splashScreen;
    UIWindow *window;
    UINavigationController *navigationController;
	
	XDataEngine* engine;
}

@property (nonatomic, retain) XActivityIndicator* largeActivityIndicator;
@property (nonatomic, retain) SplashScreen* splashScreen;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) XDataEngine* engine;

-(void) showSplashScreen:(BOOL) show;
-(void) createSplashScreen;
-(void) showActivityIndicator:(BOOL)show;
-(void) showActivityIndicator:(BOOL)show withCenter:(CGPoint)point;
-(void) createLargeActivityIndicatorView;

@end

