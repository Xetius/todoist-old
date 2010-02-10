//
//  ItemDetailsViewController.h
//  Todoist
//
//  Created by Chris Hudson on 23/12/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemDetailsViewController : UIViewController {
	IBOutlet UITextView*  contentField;
	IBOutlet UITextField* dateField;
	IBOutlet UITextField* labelsField;
	IBOutlet UISegmentedControl* priorityControl;
}

@property (nonatomic, retain) IBOutlet UITextView* contentField;
@property (nonatomic, retain) IBOutlet UITextField* dateField;
@property (nonatomic, retain) IBOutlet UITextField* labelsField;
@property (nonatomic, retain) IBOutlet UISegmentedControl* priorityControl;

- (IBAction) EditTable:(id)sender;

@end
