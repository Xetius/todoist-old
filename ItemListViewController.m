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

@implementation ItemListViewController

@synthesize projectId;
@synthesize itemList;
@synthesize activity;
@synthesize labels;
@synthesize connections;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		self.title = @"Item";
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self initLoadItems];
}

-(void) initLoadItems
{
	DLog (@"Start ItemListViewController::initLoadItems");
	[itemList release];	
	itemList = [[NSMutableArray alloc] initWithObjects: [[NSArray alloc] init], [[NSArray alloc] init], nil];
	
	TodoistAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
	NSString* api_token = delegate.userDetails.api_token;
	
	NSString* incompleteItemsUrl = [NSString stringWithFormat:@"http://todoist.com/API/getUncompletedItems?project_id=%ld&token=%@", self.projectId, api_token];
	NSString* completeItemsUrl = [NSString stringWithFormat:@"http://todoist.com/API/getCompletedItems?project_id=%ld&token=%@", self.projectId, api_token];
	
	NSURLRequest* incompleteRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:incompleteItemsUrl]
													   cachePolicy:NSURLRequestUseProtocolCachePolicy
												   timeoutInterval:60.0];
	NSURLRequest* completeRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:completeItemsUrl]
													   cachePolicy:NSURLRequestUseProtocolCachePolicy
												   timeoutInterval:60.0];
	
	XConnectionHandler* uncompleteConnectionHandler = [[XConnectionHandler alloc] initWithId:UNCOMPLETE_ITEMS_CONNECTION_ID andDelegate:self];
	NSURLConnection* uncompleteConnection = [[NSURLConnection alloc] initWithRequest:incompleteRequest delegate:uncompleteConnectionHandler];
	if (uncompleteConnection) {
		[connections setObject:uncompleteConnectionHandler forKey:[NSNumber numberWithInt:UNCOMPLETE_ITEMS_CONNECTION_ID]];
	}
	else {
		// Handle Errors
	}
	[uncompleteConnectionHandler release];
	
	XConnectionHandler* completeConnectionHandler = [[XConnectionHandler alloc] initWithId:COMPLETE_ITEMS_CONNECTION_ID andDelegate:self];
	NSURLConnection* completeConnection = [[NSURLConnection alloc] initWithRequest:completeRequest delegate:completeConnectionHandler];
	if (completeConnection) {
		[connections setObject:completeConnectionHandler forKey:[NSNumber numberWithInt:COMPLETE_ITEMS_CONNECTION_ID]];
	}
	else {
		// Handle Errors
	}
	[completeConnectionHandler release];
}

-(void) connectionDidFinishLoading:(int) connectionId withData:(NSData*) requestData {
	switch (connectionId) {
		case UNCOMPLETE_ITEMS_CONNECTION_ID:
		{
			[self loadUncompleteItems:requestData];
		}
			break;
		case COMPLETE_ITEMS_CONNECTION_ID:
		{
			[self loadCompleteItems:requestData];
		}
			break;
		default:
			break;
	}
}

-(void) loadUncompleteItems:(NSData*) data {
	NSString* jsonData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];	
	NSMutableArray* uncompleteItems = [NSMutableArray arrayWithCapacity:1];
	
	// Iterate through each of the uncomplete items and build the list of data for each cell
	for (id item in [jsonData JSONValue]) {
		DMTaskItem* taskItem = [[DMTaskItem alloc] init];
		
		[taskItem setCompleted:NO];
		[taskItem setContent:[item objectForKey:@"content"]];
		[taskItem setIndent:[[item objectForKey:@"indent"] intValue]];
		for (id labelId in [item objectForKey:@"labels"]) {
			
		}
		
		[uncompleteItems addObject:[taskItem retain]];
		[taskItem release];
	}
	
	[itemList replaceObjectAtIndex:0 withObject:uncompleteItems];
	[[self tableView] reloadData];	
}

-(void) loadCompleteItems:(NSData*) data {
	NSString* jsonData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];	
	NSMutableArray* completeItems = [[NSMutableArray alloc] initWithCapacity:1];
		
	for (id item in [jsonData JSONValue]) {
		DMTaskItem* taskItem = [[DMTaskItem alloc] init];
		
		[taskItem setCompleted:YES];
		[taskItem setContent:[item objectForKey:@"content"]];
		[taskItem setIndent:[[item objectForKey:@"indent"] intValue]];
		
		[completeItems addObject:[taskItem retain]];
		[taskItem release];
	}
	
	[itemList replaceObjectAtIndex:1 withObject:completeItems];
	[[self tableView] reloadData];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	return [itemList count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[itemList objectAtIndex:section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"itemList";
    
    ItemListTableViewCell *cell = (ItemListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ItemListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.details = [[itemList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"itemList";
    
    ItemListTableViewCell *cell = (ItemListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ItemListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.details = [[itemList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	CGFloat height = [cell cellHeightForWidth:320.0];
	
	return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


- (void)dealloc {
    [super dealloc];
}


@end

