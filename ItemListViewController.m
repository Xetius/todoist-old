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

		labelFont = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
		contentFont = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];

		backgroundColor		= [UIColor colorForHex:@"FFFEFF"];
		labelColor			= [UIColor colorForHex:@"008800"];
		dateColor			= [UIColor colorForHex:@"262626"];
		priority1Color		= [UIColor colorForHex:@"FF0000"];
		priority2Color		= [UIColor colorForHex:@"0079B5"];
		priority3Color		= [UIColor colorForHex:@"008800"];
		priority4Color		= [UIColor colorForHex:@"262626"];
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
	for (NSDictionary* item in [jsonData JSONValue]) {
		DMTaskItem* taskItem = [[DMTaskItem alloc] init];
		
		[taskItem setCompleted:NO];
		[taskItem setContent:[item objectForKey:@"content"]];
		[taskItem setIndent:[[item objectForKey:@"indent"] intValue]];
		NSMutableArray* labelArray = [NSMutableArray array];
		for (NSDecimalNumber* labelId in [item objectForKey:@"labels"]) {
			[labelArray addObject:[@"@" stringByAppendingString:[[labels objectForKey:labelId] name]]];
		}
		NSString* labelString = [labelArray componentsJoinedByString:@" "];
		DLog(@"labels:%@", labelString);
		[taskItem setLabels:labelString];
		
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
		NSMutableArray* labelArray = [NSMutableArray array];
		for (NSDecimalNumber* labelId in [item objectForKey:@"labels"]) {
			[labelArray addObject:[@"@" stringByAppendingString:[[labels objectForKey:labelId] name]]];
		}
		NSString* labelString = [labelArray componentsJoinedByString:@" "];
		DLog(@"labels:%@", labelString);
		[taskItem setLabels:labelString];
		
		[completeItems addObject:[taskItem retain]];
		[taskItem release];
	}
	
	[itemList replaceObjectAtIndex:1 withObject:completeItems];
	[[self tableView] reloadData];
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
	cell.cellDelegate = self;
	cell.details = [[itemList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"itemList";
    
    ItemListTableViewCell *cell = (ItemListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ItemListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.cellDelegate = self;
	cell.details = [[itemList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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


- (void)dealloc {
    [super dealloc];
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

