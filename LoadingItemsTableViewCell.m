//
//  LoadingItemsTableViewCell.m
//  Todoist
//
//  Created by Chris Hudson on 08/10/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import "LoadingItemsTableViewCell.h"


@implementation LoadingItemsTableViewCell

@synthesize activity;
@synthesize label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}

@end
