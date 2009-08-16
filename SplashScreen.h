//
//  SplashScreen.h
//  Todoist
//
//  Created by Chris Hudson on 15/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SplashScreen : UIViewController {
	IBOutlet UILabel* version;
	IBOutlet UILabel* status;
}

@property (nonatomic, retain) IBOutlet UILabel* version;
@property (nonatomic, retain) IBOutlet UILabel* status;

@end
