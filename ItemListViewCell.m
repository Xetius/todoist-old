//
//  ItemListViewCell.m
//  Todoist
//
//  Created by Chris Hudson on 30/11/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import "ItemListViewCell.h"


@implementation ItemListViewCell

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


-(void) setLabelsText:(NSString*) _text{
	labelsLabel.text = _text;
}

-(void) setDatesText:(NSString*) _text {	
	datesLabel.text = _text;
}

-(void) setContentText:(NSString*) _text {
	contentLabel.text = _text;
}


@end
