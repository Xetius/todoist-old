//
//  RootViewController.m
//  Todoist
//
//  Created by Chris Hudson on 14/08/2009.
//  Copyright Xetius Services Ltd. 2009. All rights reserved.
//

#import "ProjectItemTableViewCell.h"
#import "LoadingItemsTableViewCell.h"
#import "TodoistAppDelegate.h"
#import "RootViewController.h"
#import "ItemListViewController.h"
#import "UIColor+Hex.h"
#import "XConnectionHandler.h"
#import "DMProjectItem.h"
#import "DMLabelItem.h"
#import "DMTaskItem.h"
#import "JSON.h"

@implementation RootViewController

- (void)viewDidLoad {

    self.title = @"Projects";

	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void) dataDidCompleteForId:(int) dataId {
	DLog (@"Reloading Data");
	[self.tableView reloadData];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	XDataEngine* engine = [(TodoistAppDelegate*)[[UIApplication sharedApplication] delegate] engine];
	NSArray* projects = [engine projectsWithDelegate:self];
	if (projects != nil) {
		return [projects count];		
	}
	else {
		return 1;
	}

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	XDataEngine* engine = [(TodoistAppDelegate*)[[UIApplication sharedApplication] delegate] engine];
	NSArray* projects = [engine projectsWithDelegate:self];
	if (projects != nil) {
		static NSString* cellIdentifier = @"Project";
		
		ProjectItemTableViewCell* cell = (ProjectItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[[ProjectItemTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		}
		
		// Configure the cell.
		DMProjectItem* projectItem = [projects objectAtIndex:indexPath.row];
		
		cell.content = projectItem.name;
		cell.count = projectItem.cache_count;
		cell.color = [UIColor colorForHex:projectItem.color];
		cell.indent = projectItem.indent;
		cell.editing = self.editing;
		
		return cell;
	}
	else {
		static NSString* cellIdentifier = @"ProjectLoading";
		
		LoadingItemsTableViewCell* cell = (LoadingItemsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			NSArray* topLevelObjects = [[NSBundle mainBundle]
										loadNibNamed:@"LoadingItemsTableViewCell"
										owner:nil options:nil];
			for (id currentObject in topLevelObjects) {
				if ([currentObject isKindOfClass:[UITableViewCell class]]) {
					cell = (LoadingItemsTableViewCell*) [currentObject autorelease];
					break;
				}
			}
		}
		
		cell.label.text = @"Loading project items...";
		
		return cell;
	}

}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	XDataEngine* engine = [(TodoistAppDelegate*)[[UIApplication sharedApplication] delegate] engine];
	NSArray* projects = [engine projectsWithDelegate:self];
	if (projects != nil) {
		ItemListViewController* viewController = [[[ItemListViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
		viewController.projectId = [[projects objectAtIndex:indexPath.row] id];
		[[self navigationController] pushViewController:viewController animated:YES];
	}
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)dealloc {
    [super dealloc];
}


@end

