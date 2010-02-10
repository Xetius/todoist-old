//
//  LoadingItemsTableViewCell.h
//  Todoist
//
//  Created by Chris Hudson on 08/10/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingItemsTableViewCell : UITableViewCell {
	UIActivityIndicatorView* activity;
	UILabel* label;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* activity;
@property (nonatomic, retain) IBOutlet UILabel* label;

@end
