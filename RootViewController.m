//
//  RootViewController.m
//  Todoist
//
//  Created by Chris Hudson on 14/08/2009.
//  Copyright Xetius Services Ltd. 2009. All rights reserved.
//

#import "ProjectItemTableViewCell.h"
#import "TodoistAppDelegate.h"
#import "RootViewController.h"
#import "ItemListViewController.h"
#import "UIColor+Hex.h"
#import "XConnectionHandler.h"
#import "DMProjectItem.h"
#import "DMLabelItem.h"
#import "JSON.h"

@implementation RootViewController

@synthesize projects;
@synthesize labels;
@synthesize connectionHandlers;
@synthesize projectsNeedReloading;
@synthesize labelsNeedReloading;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.title = @"Projects";
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	// Load the projects from Web
	self.projectsNeedReloading = YES;
	self.labelsNeedReloading = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self initLoadData];
}


-(void) initLoadData
{
	DLog(@"Start RootViewController::initLoadData");
	TodoistAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
	if (projectsNeedReloading) {
		NSString* projectsUrl = [NSString stringWithFormat:@"http://todoist.com/API/getProjects?token=%@", delegate.userDetails.api_token];
		NSURLRequest* projectsRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:projectsUrl]
												 cachePolicy:NSURLRequestUseProtocolCachePolicy
											 timeoutInterval:60.0];
		XConnectionHandler* projectHandler = [[XConnectionHandler alloc] initWithId:PROJECTS_CONNECTION_ID andDelegate:self];
		NSURLConnection* projectsConnection = [[NSURLConnection alloc] initWithRequest:projectsRequest delegate:projectHandler];
		if (projectsConnection) {
			[connectionHandlers setObject:projectHandler forKey:[NSNumber numberWithInt:PROJECTS_CONNECTION_ID]];
		}
		else {
			// Handle errors
			DLog (@"Should handle errors for projectsConnection failing to create");
		}
		[projectHandler release];
		
		self.projectsNeedReloading = NO;
	}
	
	if (labelsNeedReloading) {
		NSString* labelsUrl = [NSString stringWithFormat:@"http://todoist.com/API/getLabels?token=%@", delegate.userDetails.api_token];
		NSURLRequest* labelsRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:labelsUrl]
													  cachePolicy:NSURLRequestUseProtocolCachePolicy
												  timeoutInterval:60.0];
		XConnectionHandler* labelsHandler = [[XConnectionHandler alloc] initWithId:LABELS_CONNECTION_ID andDelegate:self];
		NSURLConnection* labelsConnection = [[NSURLConnection alloc] initWithRequest:labelsRequest delegate:labelsHandler];
		if (labelsConnection) {
			[connectionHandlers setObject:labelsHandler forKey:[NSNumber numberWithInt:LABELS_CONNECTION_ID]];
		}
		else {
			// Handle errors
			DLog (@"Should handle errors for labelsConnection failing to create");
		}
		[labelsHandler release];
	}
}

-(void) connectionDidFinishLoading:(int) connectionId withData:(NSData*) requestData 
{
	switch (connectionId) {
		case PROJECTS_CONNECTION_ID:
		{
			[self loadProjectData:requestData];
		}
			break;
		case LABELS_CONNECTION_ID:
		{
			[self loadLabelsData:requestData];
		}
			break;
		default:
			break;
	}
	
	[connectionHandlers removeObjectForKey:[NSNumber numberWithInt:connectionId]];
}

-(void) loadProjectData:(NSData*) requestData
{
	DLog (@"loadProjectsData");
	// Clear out all old data
	[self.projects release];
	
	NSString* data = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
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
	[[self tableView] reloadData];
	self.projectsNeedReloading = NO;
}

-(void) loadLabelsData:(NSData *)requestData {
	DLog (@"loadLabelsData");
	[self.labels release];
	
	NSString* data = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
	NSDictionary* jsonLabelsDictionary = [data JSONValue];
	NSMutableDictionary* labelsTemp = [NSMutableDictionary dictionaryWithCapacity:1];
	for (id name in jsonLabelsDictionary) {
		DLog(@"Label:%@", name);
		NSDictionary* jsonLabel = [jsonLabelsDictionary objectForKey:name];
		DMLabelItem* labelItem = [[DMLabelItem alloc] init];
		labelItem.name = [jsonLabel objectForKey:@"name"];
		labelItem.labelId = [[jsonLabel objectForKey:@"id"] longValue];
		labelItem.uid = [[jsonLabel objectForKey:@"uid"] longValue];
		labelItem.color = [[jsonLabel objectForKey:@"color"] intValue];
		labelItem.count = [[jsonLabel objectForKey:@"count"] intValue];
		[labelsTemp setObject:labelItem forKey:[NSNumber numberWithLong:labelItem.labelId]];
		[labelItem release];
	}
	self.labels = labelsTemp;
	[[self tableView] reloadData];
	self.labelsNeedReloading = NO;
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
		cell.frame = CGRectMake(0.0, 0.0, 320.0, ROW_HEIGHT);
    }
    
	// Configure the cell.
	DMProjectItem* projectItem = [[self projects] objectAtIndex:indexPath.row];
	
	cell.content = projectItem.name;
	cell.count = projectItem.cache_count;
	cell.color = [UIColor colorForHex:projectItem.color];
	cell.indent = projectItem.indent;

    return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Navigation logic may go here -- for example, create and push another view controller.
	ItemListViewController* viewController = [[ItemListViewController alloc] initWithStyle:UITableViewStylePlain];
	viewController.projectId = [(DMProjectItem*)[[self projects] objectAtIndex:indexPath.row] id];
	viewController.labels = self.labels;
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

