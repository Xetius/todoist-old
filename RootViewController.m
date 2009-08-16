//
//  RootViewController.m
//  Todoist
//
//  Created by Chris Hudson on 14/08/2009.
//  Copyright Xetius Services Ltd. 2009. All rights reserved.
//

#import "TodoistAppDelegate.h"
#import "RootViewController.h"
#import "ItemListViewController.h"
#import "DataModel.h"
#import "ProjectItemTableViewCell.h"

@implementation RootViewController

@synthesize projects;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.title = @"Projects";
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	// Load the projects from Web

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	TodoistAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
	NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(willLoadProjects) object:nil];
	[[delegate operationQueue] addOperation:operation];
	[operation release];
}


-(void) willLoadProjects
{
	TodoistAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
	
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://todoist.com/API/getProjects?token=%@", delegate.userDetails.api_token]];
	NSString* data = [NSString stringWithContentsOfURL:url];
	NSArray* jsonProjectsArray = [data JSONValue];
	NSMutableArray* projectsTemp = [NSMutableArray arrayWithCapacity:1];
	for (NSDictionary* jsonProject in jsonProjectsArray) 
	{
		DMProjectItem* projectItem = [[DMProjectItem alloc] init];
		projectItem.user_id = [[jsonProject objectForKey:@"user_id"] longValue];
		projectItem.name = [jsonProject objectForKey:@"name"];
		projectItem.color = [jsonProject objectForKey:@"color"];
		projectItem.collapsed = [[jsonProject objectForKey:@"collapsed"] intValue];
		projectItem.item_order = [[jsonProject objectForKey:@"item_order"] intValue];
		projectItem.cache_count = [[jsonProject objectForKey:@"cache_count"] intValue];
		projectItem.indent = [[jsonProject objectForKey:@"indent"] intValue];
		projectItem.id = [[jsonProject objectForKey:@"id"] longValue];
		
		[projectsTemp addObject:projectItem];
		[projectItem release];
	}
	self.projects = projectsTemp;
	[self performSelectorOnMainThread:@selector(didFinishLoadingProjects) withObject:nil waitUntilDone:NO];
}

-(void) didFinishLoadingProjects
{
	[[self tableView] reloadData];
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


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.projects.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Project";
    
    ProjectItemTableViewCell* cell = (ProjectItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ProjectItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	cell.textLabel.text = [[[self projects] objectAtIndex:indexPath.row] name];

    return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Navigation logic may go here -- for example, create and push another view controller.
	ItemListViewController* viewController = [[ItemListViewController alloc] initWithStyle:UITableViewStylePlain];
	viewController.projectId = [(DMProjectItem*)[[self projects] objectAtIndex:indexPath.row] id];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

