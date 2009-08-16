//
//  DataModelTests.h
//  Todoist
//
//  Created by Chris Hudson on 10/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Dependent unit tests mean unit test code depends on an application to be injected into.
//  Setting this to 0 means the unit test code is designed to be linked into an independent executable.
#define USE_DEPENDENT_UNIT_TEST 1

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
//#import "application_headers" as required


@interface DataModelTests : SenTestCase {

}

#if USE_DEPENDENT_UNIT_TEST
- (void) testAppDelegate;       // simple test on application
#else
- (void) testMath;              // simple standalone test
#endif

@end
