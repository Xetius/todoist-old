//
//  DataModelTests.m
//  Todoist
//
//  Created by Chris Hudson on 10/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//

#import "DataModelTests.h"
#import "DataModel.h"

@implementation DataModelTests

#if USE_DEPENDENT_UNIT_TEST     // all "code under test" is in the iPhone Application

- (void) testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIAppliation failed to find the AppDelegate");
	
	DataModel* model = [[DataModel alloc] init];
	BOOL success = NO;
	success = [model loginWithUserName:@"c@xetius.com" AndPassword:@"wrong"];
	STAssertFalse (success, @"Should fail with incorrect password");
	
	success = [model loginWithUserName:@"c@xetius.com" AndPassword:@"sandman1"];
	STAssertTrue (success, @"Should success with correct password");
	
	success = [model getProjects];
	STAssertTrue (success, @"Should successfully obtain the projects");
}

#else                           // all "code under test" must be linked into the Unit Test bundle

- (void) testMath {
    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}


#endif


@end
