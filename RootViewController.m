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
@synthesize loadedData;
@synthesize uncompleteItems;
@synthesize completeItems;
@synthesize api_token;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.title = @"Projects";
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
	// retrieve the data for the selected item.
	long projectId = [(DMProjectItem*)[[self projects] objectAtIndex:indexPath.row] id];

	[self setLoadedData:0];
	
	DLog (@"Initialising request for incomplete and complete items");
	NSString* incompleteItemsUrl = [NSString stringWithFormat:@"http://todoist.com/API/getUncompletedItems?project_id=%ld&token=%@", projectId, self.api_token];
	NSString* completeItemsUrl = [NSString stringWithFormat:@"http://todoist.com/API/getCompletedItems?project_id=%ld&token=%@", projectId, self.api_token];
	
	NSURLRequest* incompleteRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:incompleteItemsUrl]
													   cachePolicy:NSURLRequestUseProtocolCachePolicy
												   timeoutInterval:60.0];
	NSURLRequest* completeRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:completeItemsUrl]
													 cachePolicy:NSURLRequestUseProtocolCachePolicy
												 timeoutInterval:60.0];

	XConnectionHandler* uncompleteConnectionHandler = [[XConnectionHandler alloc] initWithId:UNCOMPLETE_ITEMS_CONNECTION_ID andDelegate:self];
	NSURLConnection* uncompleteConnection = [[NSURLConnection alloc] initWithRequest:incompleteRequest delegate:uncompleteConnectionHandler];
	if (uncompleteConnection) {
		[connectionHandlers setObject:uncompleteConnectionHandler forKey:[NSNumber numberWithInt:UNCOMPLETE_ITEMS_CONNECTION_ID]];
	}
	else {
		// Handle Errors
		DLog(@"Error adding uncomplete items connection request");
	}
	[uncompleteConnectionHandler release];
	
	XConnectionHandler* completeConnectionHandler = [[XConnectionHandler alloc] initWithId:COMPLETE_ITEMS_CONNECTION_ID andDelegate:self];
	NSURLConnection* completeConnection = [[NSURLConnection alloc] initWithRequest:completeRequest delegate:completeConnectionHandler];
	if (completeConnection) {
		[connectionHandlers setObject:completeConnectionHandler forKey:[NSNumber numberWithInt:COMPLETE_ITEMS_CONNECTION_ID]];
	}
	else {
		// Handle Errors
		DLog(@"Error adding complete items connection request");
	}
	[completeConnectionHandler release];
}

-(void) connectionDidFailLoading:(int)connectionId withError:(NSError *)error
{
	
}

-(void) connectionDidFinishLoading:(int) connectionId withData:(NSData*) requestData 
{
	switch (connectionId) {
		case UNCOMPLETE_ITEMS_CONNECTION_ID:
		{
			DLog(@"finished loading uncomplete items.  Processing downloaded data");
			[self loadUncompleteItems:requestData];
		}
			break;
		case COMPLETE_ITEMS_CONNECTION_ID:
		{
			DLog(@"finished loading complete items.  Processing downloaded data");
			[self loadCompleteItems:requestData];
		}
			break;
	}
	
	if (loadedData & (UNCOMPLETE_ITEMS_CONNECTION_DATA | COMPLETE_ITEMS_CONNECTION_DATA)) {
		[self loadNextPage];
	}
}

-(void) loadUncompleteItems:(NSData*) requestData
{
	NSString* jsonData = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];	
	NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity:1];
	
	// Iterate through each of the uncomplete items and build the list of data for each cell
	for (NSDictionary* item in [jsonData JSONValue]) {
		DMTaskItem* taskItem = [[DMTaskItem alloc] init];
		
		[taskItem setCompleted:NO];
		[taskItem setContent:[item objectForKey:@"content"]];
		[taskItem setIndent:[[item objectForKey:@"indent"] intValue]];
		NSMutableArray* labelArray = [NSMutableArray array];
		for (NSDecimalNumber* labelId in [item objectForKey:@"labels"]) {
			[labelArray addObject:[@"@" stringByAppendingString:[[labels objectForKey:labelId] name]]];
		}
		NSString* labelString = ([labelArray count]?[labelArray componentsJoinedByString:@" "]:@"-");
		DLog(@"labels:%@", labelString);
		[taskItem setLabels:labelString];
		
		[tempArray addObject:[taskItem retain]];
		[taskItem release];
	}
	
	uncompleteItems = [[NSArray arrayWithArray:tempArray] retain];
	
	loadedData |= UNCOMPLETE_ITEMS_CONNECTION_DATA;
}

-(void) loadCompleteItems:(NSData*) requestData
{
	NSString* jsonData = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];	
	NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity:1];
	
	// Iterate through each of the uncomplete items and build the list of data for each cell
	for (NSDictionary* item in [jsonData JSONValue]) {
		DMTaskItem* taskItem = [[DMTaskItem alloc] init];
		
		[taskItem setCompleted:YES];
		[taskItem setContent:[item objectForKey:@"content"]];
		[taskItem setIndent:[[item objectForKey:@"indent"] intValue]];
		NSMutableArray* labelArray = [NSMutableArray array];
		for (NSDecimalNumber* labelId in [item objectForKey:@"labels"]) {
			[labelArray addObject:[@"@" stringByAppendingString:[[labels objectForKey:labelId] name]]];
		}
		NSString* labelString = [labelArray componentsJoinedByString:@" "];
		DLog(@"labels:%@", labelString);
		[taskItem setLabels:labelString];
		
		[tempArray addObject:[taskItem retain]];
		[taskItem release];
	}
	
	completeItems = [[NSArray arrayWithArray:tempArray] retain];
	
	loadedData |= COMPLETE_ITEMS_CONNECTION_DATA;
}

-(void) loadNextPage
{
	DLog (@"Finished loading all items.  Loading ItemListViewController");
	ItemListViewController* viewController = [[ItemListViewController alloc] initWithStyle:UITableViewStyleGrouped];
	viewController.itemList = [[NSArray alloc] initWithObjects:uncompleteItems, completeItems, nil];
	viewController.labels = [[self labels] retain];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)dealloc {
    [super dealloc];
}


@end

