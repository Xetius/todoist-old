//
//  ItemListViewController.m
//  Todoist
//
//  Created by Chris Hudson on 15/08/2009.
//  Copyright 2009 Xetius Services Ltd.. All rights reserved.
//

#import "ItemListViewController.h"
#import "ItemListItemTableViewCell.h"
#import "TodoistAppDelegate.h"
#import "DMTaskItem.h"
#import "JSON/JSON.h"
#import "RegexKitLite.h"

@implementation ItemListViewController

#define CONTENT_FONT_SIZE 14

@synthesize projectId;
@synthesize itemList;
@synthesize activity;

@synthesize normalFont;
@synthesize boldFont;
@synthesize italicFont;
@synthesize boldItalicFont;

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
	
	TodoistAppDelegate* delegate = (TodoistAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(willLoadItems) object:nil];
	[[delegate operationQueue] addOperation:operation];
	[operation release];
}

-(void) willLoadItems
{
	DLog (@"Start ItemListViewController::willLoadItems");
	if (itemList)
	{
		[itemList release];
	}
	
	TodoistAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
	NSString* api_token = delegate.userDetails.api_token;
	
	NSURL* urlOfIncompleteItems = [NSURL URLWithString:[NSString stringWithFormat:@"http://todoist.com/API/getUncompletedItems?project_id=%ld&token=%@", self.projectId, api_token]];
	NSString* jsonDataForIncompleteItems = [NSString stringWithContentsOfURL:urlOfIncompleteItems encoding:NSUTF8StringEncoding error:nil];
	NSMutableArray* uncompleteItems = [[NSMutableArray alloc] initWithCapacity:1];
	
	// Iterate through each of the uncomplete items and build the list of data for each cell
	for (id item in [jsonDataForIncompleteItems JSONValue]) {
		DMTaskItem* taskItem = [[DMTaskItem alloc] init];
		
		[taskItem setCompleted:NO];
		[taskItem setContent:[item objectForKey:@"content"]];
		[taskItem setIndent:[[item objectForKey:@"indent"] intValue]];
		
		[uncompleteItems addObject:[taskItem retain]];
		[taskItem release];
	}
	
	NSURL* urlCompletedItems = [NSURL URLWithString:[NSString stringWithFormat:@"http://todoist.com/API/getCompletedItems?project_id=%ld&token=%@", self.projectId, api_token]];
	NSString* jsonDataCompletedItems = [NSString stringWithContentsOfURL:urlCompletedItems encoding:NSUTF8StringEncoding error:nil];
	NSMutableArray* completeItems = [[NSMutableArray alloc] initWithCapacity:1];

	for (id item in [jsonDataCompletedItems JSONValue]) {
		DMTaskItem* taskItem = [[DMTaskItem alloc] init];
		
		[taskItem setCompleted:YES];
		[taskItem setContent:[item objectForKey:@"content"]];
		[taskItem setIndent:[[item objectForKey:@"indent"] intValue]];
		
		[completeItems addObject:[taskItem retain]];
		[taskItem release];
	}
	
	itemList  = [[NSMutableArray alloc] initWithObjects:uncompleteItems, completeItems, nil];

	DLog (@"Finish ItemListViewController::willLoadItems");
	[self performSelectorOnMainThread:@selector(didFinishLoadingItems) withObject:nil waitUntilDone:NO];
}

-(void) didFinishLoadingItems
{
	DLog(@"Start ItemListViewController::didFinishLoadingItems");
	[[self tableView] reloadData];
	DLog(@"Finish ItemListViewController::didFinishLoadingItems");
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
    
    ItemListItemTableViewCell *cell = (ItemListItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ItemListItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.details = [[itemList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"itemList";
    
    ItemListItemTableViewCell *cell = (ItemListItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ItemListItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
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
	[normalFont release];
	[boldFont release];
	[italicFont release];
	[boldItalicFont release];
	
	// TODO: Release the taskList Array of Arrays
    [super dealloc];
}

-(UIFont*) fontForFormat:(DMTaskItemFormat) format{
	UIFont* font = nil;
	switch (format) {
		case DMTaskItemFormatNone:
		{
			font = normalFont;
		}
			break;
		case DMTaskItemFormatBold:
		{
			font = boldFont;
		}
			break;
		case DMTaskItemFormatItalic:
		{
			font = italicFont;
		}
			break;
		case DMTaskItemFormatBold | DMTaskItemFormatItalic:
		{
			font = boldItalicFont;
		}
			break;
		case DMTaskItemFormatUnderline:
		{
			font = normalFont;
		}
			break;
		case DMTaskItemFormatBold | DMTaskItemFormatUnderline:
		{
			font = boldFont;
		}
			break;
		case DMTaskItemFormatItalic | DMTaskItemFormatUnderline:
		{
			font = italicFont;
		}
			break;
		case DMTaskItemFormatBold | DMTaskItemFormatItalic | DMTaskItemFormatUnderline:
		{
			font = boldItalicFont;
		}
			break;
		case DMTaskItemFormatHighlight:
		{
			font = normalFont;
		}
			break;
		case DMTaskItemFormatBold | DMTaskItemFormatHighlight:
		{
			font = boldFont;
		}
			break;
		case DMTaskItemFormatItalic | DMTaskItemFormatHighlight:
		{
			font = italicFont;
		}
			break;
		case DMTaskItemFormatBold | DMTaskItemFormatItalic | DMTaskItemFormatHighlight:
		{
			font = boldItalicFont;
		}
			break;
		case DMTaskItemFormatUnderline | DMTaskItemFormatHighlight:
		{ 
			font = normalFont;
		}
			break;
		case DMTaskItemFormatBold | DMTaskItemFormatUnderline | DMTaskItemFormatHighlight:
		{
			font = boldFont;
		}
			break;
		case DMTaskItemFormatItalic | DMTaskItemFormatUnderline | DMTaskItemFormatHighlight:
		{
			font = italicFont;
		}
			break;
		case DMTaskItemFormatBold | DMTaskItemFormatItalic | DMTaskItemFormatUnderline | DMTaskItemFormatHighlight:
		{
			font = boldItalicFont;
		}
			break;
		default:
		{
			font = normalFont;
		}
			break;
	}
	
	return font;
}

-(CGSize) sizeForWord:(NSString*) word withFormat:(NSString*) format isSimple:(BOOL) simple {
	
	
	int wordLength = [word length];
	CGSize wordSize = CGSizeZero;
	for (int charIndex = 0; charIndex < wordLength; charIndex++) {
		NSString* c = [NSString stringWithFormat:@"%C", [word characterAtIndex:charIndex]];
		DMTaskItemFormat f = [format characterAtIndex:charIndex] - 'a';
		UIFont* thisFont = [self fontForFormat:f];
		CGSize charSize = [c sizeWithFont:thisFont];
		if (charSize.height > wordSize.height) {
			wordSize.height = charSize.height;
		}
		wordSize.width += charSize.width;
	}
	return wordSize;
}


@end

