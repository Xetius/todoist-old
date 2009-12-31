//
//  XActivityIndicator.m
//  Todoist
//
//  Created by Chris Hudson on 15/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//

#import "XActivityIndicator.h"

@implementation XActivityIndicator

@synthesize overlay;
@synthesize back;
@synthesize indicator;
@synthesize label;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
		self.alpha = 0;
		overlay = [[UIImage imageNamed:@"overlay.png"]stretchableImageWithLeftCapWidth:15 topCapHeight:15];
		back = [[UIImageView alloc]initWithFrame:CGRectMake(85, 180, 150, 120)];
		back.alpha = 0.7;
		[back setImage:overlay];
		[self addSubview:back];
		[back release];
		indicator = [[UIActivityIndicatorView alloc]init];
		[indicator setCenter:CGPointMake(160,240)];
		[indicator setBounds:CGRectMake(0, 0, 37, 37)];
		[indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[self addSubview:indicator];
		[indicator startAnimating];
		[indicator release];
		label = [[UILabel alloc]initWithFrame:CGRectMake(95, 265, 130, 25)];
		label.textAlignment = UITextAlignmentCenter;
		label.text = @"Loading";
		label.textColor = [UIColor whiteColor];
		label.font = [UIFont boldSystemFontOfSize:19];
		label.opaque = NO;
		label.backgroundColor = [UIColor clearColor];
		label.adjustsFontSizeToFitWidth = YES;
		[self addSubview:label];
		[label release];		
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

-(void) setText:(NSString*) newText {
	label.text = newText;
}

- (void)dealloc {
    [super dealloc];
}

-(void)showActivityIndicator:(BOOL)show {
	[self showActivityIndicator:show withCenter:CGPointMake(160,240)];
}

-(void)showActivityIndicator:(BOOL)show withCenter:(CGPoint)point {
	if (show) {
		if (self.alpha!=1) {
			self.center = point;
			[UIView beginAnimations:@"activity" context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
			[UIView setAnimationDuration:0.4];
			self.alpha=1;
			[UIView commitAnimations];
		}
	}
	else {
		if (self.alpha!=0) {
			[UIView beginAnimations:@"activity" context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
			[UIView setAnimationDuration:0.4];
			self.alpha=0;
			[UIView commitAnimations];			
		}
	}
}


@end
