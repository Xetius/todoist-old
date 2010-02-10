//
//  ItemListViewController.m
//  Todoist
//
//  Created by Chris Hudson on 26/09/2009.
//  Copyright 2009 Xetius Software. All rights reserved.
//

#import "TodoistAppDelegate.h"
#import "ItemListViewController.h"
#import "LoadingItemsTableViewCell.h"
#import "ItemDetailsViewController.h"
#import "DMTaskItem.h"
#import "UIColor+Hex.h"

@implementation ItemListViewController

@synthesize projectId;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {		
	}
    return self;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

-(void)viewDidLoad {
	[super viewDidLoad];
	UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
	[self.navigationItem setRightBarButtonItem:editButton];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	DLog (@"Requesting projects");
	XDataEngine* engine = [(TodoistAppDelegate*)[[UIApplication sharedApplication] delegate] engine];
	NSArray* items = [engine itemsForProjectId:[self projectId] withDelegate:self];
	if (items != nil) {
		int num = [items count];
		DLog (@"Sections in table:%d", num);
		return [items count];
	}
	else {
		return 1;
	}
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	DLog (@"Requesting projects");
	XDataEngine* engine = [(TodoistAppDelegate*)[[UIApplication sharedApplication] delegate] engine];
	NSArray* items = [engine itemsForProjectId:[self projectId] withDelegate:self];
	if (items != nil) {
		int num = [[items objectAtIndex:section] count];
		DLog (@"Rows in section:%d, %d", section, num);
		return [[items objectAtIndex:section] count];
	}
	else {
		return 1;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	XDataEngine* engine = [(TodoistAppDelegate*)[[UIApplication sharedApplication] delegate] engine];
	NSArray* items = [engine itemsForProjectId:[self projectId] withDelegate:self];
	if (items != nil) {
		static NSString* cellIdentifier = @"itemCell";
		ItemListViewCell* cell = (ItemListViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"ItemListViewCell" owner:self options:nil];
			cell = itemCell;
		}
		DMTaskItem* item = [[items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		[cell setContentText:[item content]];
		[cell setLabelsText:[item labelStringWithDelegate:self]];
		NSString* dateString = @"-";
		if ([item due_date] != nil) {
			NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
			[df setDateFormat:@"dd-MM-yyyy"];
			dateString = [df stringFromDate:[item due_date]];
		}
		[cell setDatesText:dateString];
		return cell;
	}
	else {
		static NSString* cellIdentifier = @"ItemLoading";
		
		LoadingItemsTableViewCell* cell = (LoadingItemsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			NSArray* topLevelObjects = [[NSBundle mainBundle]
										loadNibNamed:@"LoadingItemsTableViewCell"
										owner:nil options:nil];
			for (id currentObject in topLevelObjects) {
				if ([currentObject isKindOfClass:[UITableViewCell class]]) {
					cell = (LoadingItemsTableViewCell*) currentObject;
					break;
				}
			}
		}
		
		cell.label.text = @"Loading project items...";
		
		return cell;		
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	XDataEngine* engine = [(TodoistAppDelegate*)[[UIApplication sharedApplication] delegate] engine];
	NSArray* items = [engine itemsForProjectId:[self projectId] withDelegate:self];
	if (items != nil) {
		DMTaskItem* item = [[items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		
		ItemDetailsViewController* viewController = [[[ItemDetailsViewController alloc] initWithNibName:@"ItemDetailsViewController" bundle:nil] autorelease];
		[[self navigationController] pushViewController:viewController animated:YES];

		viewController.contentField.text = item.content;
		NSString* dateString = @"-";
		if ([item due_date] != nil) {
			NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
			[df setDateFormat:@"EEE dd-MM-yyyy HH:mm:ss"];
			dateString = [df stringFromDate:[item due_date]];
		}		
		viewController.dateField.text = dateString;
		viewController.labelsField.text = [item labelStringWithDelegate:self];
		viewController.priorityControl.selectedSegmentIndex = item.priority;	
	}
}

- (void)dealloc {
	[super dealloc];
}

-(void) dataDidCompleteForId:(int)dataId {
	DLog (@"Calling dataDidCompleteForId:%d", dataId);
	[[self tableView] reloadData];
}

-(UIFont*) fontForId:(int) fontId {
	return [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
}

-(UIColor*) colorForId:(int) colorId {
	return [UIColor	blackColor];
}

- (IBAction) EditTable:(id)sender{
	if(self.editing)
	{
		[super setEditing:NO animated:NO];
//		[tblSimpleTable setEditing:NO animated:NO];
//		[tblSimpleTable reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		[super setEditing:YES animated:YES];
//		[tblSimpleTable setEditing:YES animated:YES];
//		[tblSimpleTable reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}
@end
