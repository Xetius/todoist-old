//
//  ItemListViewController.m
//  Todoist
//
//  Created by Chris Hudson on 15/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//

#import "ItemListViewController.h"
#import "ItemListTableViewCell.h"
#import "TodoistAppDelegate.h"
#import "DMTaskItem.h"
#import "JSON/JSON.h"
#import "RegexKitLite.h"
#import "XConnectionHandler.h"
#import "UIColor+Hex.h"

@implementation ItemListViewController

@synthesize projectId;
@synthesize itemList;
@synthesize activity;
@synthesize labels;
@synthesize connections;

@synthesize labelFont;
@synthesize contentFont;

@synthesize backgroundColor;
@synthesize labelColor;
@synthesize dateColor;
@synthesize priority1Color;
@synthesize priority2Color;
@synthesize priority3Color;
@synthesize priority4Color;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		DLog (@"Creating colours and fonts");
		
		self.title = @"Item";

		labelFont			= [[UIFont systemFontOfSize:LABEL_FONT_SIZE] retain];
		contentFont			= [[UIFont systemFontOfSize:CONTENT_FONT_SIZE] retain];

		backgroundColor		= [[UIColor colorForHex:@"FFFEFF"] retain];
		labelColor			= [[UIColor colorForHex:@"008800"] retain];
		dateColor			= [[UIColor colorForHex:@"262626"] retain];
		priority1Color		= [[UIColor colorForHex:@"FF0000"] retain];
		priority2Color		= [[UIColor colorForHex:@"0079B5"] retain];
		priority3Color		= [[UIColor colorForHex:@"008800"] retain];
		priority4Color		= [[UIColor colorForHex:@"262626"] retain];
	}
    return self;
}

- (void)dealloc {
	[labels release];
	[itemList release];
	[labelFont release];
	[contentFont release];
	[backgroundColor release];
	[labelColor release];
	[dateColor release];
	[priority1Color release];
	[priority2Color release];
	[priority3Color release];
	[priority4Color release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.itemList count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.itemList objectAtIndex:section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"itemList";
    
    ItemListTableViewCell *cell = (ItemListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ItemListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.cellDelegate = self;
	cell.details = [[self.itemList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"itemList";
    
    ItemListTableViewCell *cell = (ItemListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ItemListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.cellDelegate = self;
	cell.details = [[self.itemList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	CGFloat height = [cell cellHeightForWidth:320.0];
	
	return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


// ItemListTableViewCellDelegate methods
-(UIFont*) fontForId:(int) fontID {
	UIFont* requestedFont = nil;
	switch (fontID) {
		case LABEL_FONT_ID:
		{
			requestedFont = labelFont;
		}
			break;
		case CONTENT_FONT_ID:
		{
			requestedFont = contentFont;
		}
			break;
		case DATE_FONT_ID:
		{
			requestedFont = contentFont;
		}
			break;
		default:
		{
			requestedFont = contentFont;
		}
			break;
	}
	return [requestedFont autorelease];
}

-(UIColor*) colorForId:(int) colorID {
	UIColor* requestedColor = nil;
	switch (colorID) {
		case BACKGROUND_COLOR_ID:
		{
			requestedColor = backgroundColor;
		}
			break;
		case LABEL_COLOR_ID:
		{
			requestedColor = labelColor;
		}
			break;
		case DATE_COLOR_ID:
		{
			requestedColor = dateColor;
		}
			break;
		case PRIORITY_1_COLOR_ID:
		{
			requestedColor = priority1Color;
		}
			break;
		case PRIORITY_2_COLOR_ID:
		{
			requestedColor = priority2Color;
		}
			break;
		case PRIORITY_3_COLOR_ID:
		{
			requestedColor = priority3Color;
		}
			break;
		case PRIORITY_4_COLOR_ID:
		{
			requestedColor = priority4Color;
		}
			break;
		default:
		{
			requestedColor = priority4Color;
		}
			break;
	}
	return [requestedColor autorelease];
}

@end

