//
//  ItemListViewCell.h
//  Todoist
//
//  Created by Chris Hudson on 30/11/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemListViewCell : UITableViewCell {
	IBOutlet UILabel* labelsLabel;
	IBOutlet UILabel* datesLabel;
	IBOutlet UILabel* contentLabel;
}

-(void) setLabelsText:(NSString*) _text;
-(void) setDatesText:(NSString*) _text;
-(void) setContentText:(NSString*) _text;

@end
