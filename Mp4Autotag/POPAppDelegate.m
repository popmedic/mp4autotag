//
//  POPAppDelegate.m
//  Mp4Autotag
//
//  Created by Kevin Scardina on 9/27/12.
//  Copyright (c) 2012 The Popmedic. All rights reserved.
//

#import "POPAppDelegate.h"
#import "POPmp4v2dylibloader.h"
#import "POPMp4FileTagSearch.h"
#import "fixmoov.h"
#include <dlfcn.h>

@implementation POPAppDelegate
{
	POPMp4FileTagTable* mp4FileTagTable;
	POPMp4FileTagSearch* mp4SearchFileTagTable;
	NSArray* attags;
	int attags_idx;
}

@synthesize window = _window;
@synthesize loadWnd = _loadWnd;
@synthesize mp4FileTagTableView = _mp4FileTagTableView;
@synthesize mp4FileTagView = _mp4FileTagView;
@synthesize currentFilenameLabel = _currentFilenameLabel;
@synthesize mp4FileTagImage = _mp4FileTagImage;
@synthesize searchResultWindow = _searchResultWindow;
@synthesize customSearchWindow = _customSearchWindow;
@synthesize preferencesWindow = _preferencesWindow;
@synthesize automatedAutotagWindow = _automatedAutotagWindow;
@synthesize searchTableView = _searchTableView;
@synthesize seachFilenameLabel = _seachFilenameLabel;
@synthesize customSearchWindowTabView = _customSearchWindowTabView;
@synthesize customSearchWindowSeriesTextField = _customSearchWindowSeriesTextField;
@synthesize customSearchWindowSeasonNumberTextField = _customSearchWindowSeasonNumberTextField;
@synthesize customSearchWindowEpisodeNumberTextField = _customSearchWindowEpisodeNumberTextField;
@synthesize customSearchWindowMovieTextField = _customSearchWindowMovieTextField;
@synthesize customSearchWindowUseSameSeriesCheckBox = _customSearchWindowUseSameSeriesCheckBox;
@synthesize mp4AutotagWindowSplitViewHorizontal = _mp4AutotagWindowSplitViewHorizontal;
@synthesize mp4AutotagWindowSplitViewVertical = _mp4AutotagWindowSplitViewVertical;
@synthesize saveAllButton = _saveAllButton;
@synthesize automatedAutotagButton = _automatedAutotagButton;
@synthesize removeButton = _removeButton;
@synthesize saveButton = _saveButton;
@synthesize autotagButton = _autotagButton;
@synthesize preferencesButton = _preferencesButton;
@synthesize preferencesRenameCheckBox = _preferencesRenameCheckBox;
@synthesize preferencesEpisodeCoverArtMatrix = _preferencesEpisodeCoverArtMatrix;
@synthesize preferencesUseITunesCheckBox = _preferencesUseITunesCheckBox;
@synthesize dropFileHereImageWell = _dropFileHereImageWell;
@synthesize mp4FileTagsTableScrollView = _mp4FileTagsTableScrollView;
@synthesize preferencesFixForNetworkCheckBox = _preferencesFixForNetworkCheckBox;
@synthesize preferencesProxySearchCheckBox = _preferencesProxySearchCheckBox;
@synthesize preferencesAddWatermarkCheckBox = _preferencesAddWatermarkCheckBox;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	//[[self loadWnd] show:@"Initializing..."];
	mp4FileTagTable = [[POPMp4FileTagTable alloc] initWithParent:self];
	mp4SearchFileTagTable = nil;
	[[self mp4FileTagTableView] setDataSource:(id<NSTableViewDataSource>)mp4FileTagTable];
	[[self mp4FileTagTableView] setDelegate:(id<NSTableViewDelegate>)mp4FileTagTable];	
	//set up preferences
	NSInteger i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"renameFile"] intValue];
	[[self preferencesRenameCheckBox] setState:i];
	i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"episodeCoverArt"] intValue];
	[[self preferencesEpisodeCoverArtMatrix] setState:YES atRow:i column:0];
	i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"useITunes"] intValue];
	[[self preferencesUseITunesCheckBox] setState:i];
	i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"fixForNetwork"] intValue];
	[[self preferencesFixForNetworkCheckBox] setState:i];
	i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"usePopmedicProxy"] intValue];
	[[self preferencesProxySearchCheckBox] setState:i];
	i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"addWatermark"] intValue];
	[[self preferencesAddWatermarkCheckBox] setState:i];
	
	//setup the size of the splits
	CGFloat f = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hsplit1"] floatValue];	
	NSSize size;
	if(f != 0){
		size = [[[[self mp4AutotagWindowSplitViewHorizontal] subviews] objectAtIndex:0] frame].size;
		size.height = f;
		[[[[self mp4AutotagWindowSplitViewHorizontal] subviews] objectAtIndex:0] setFrameSize:size];
		f = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hsplit2"] floatValue];
		size = [[[[self mp4AutotagWindowSplitViewHorizontal] subviews] objectAtIndex:1] frame].size;
		size.height = f;
		[[[[self mp4AutotagWindowSplitViewHorizontal] subviews] objectAtIndex:1] setFrameSize:size];
	}
	f = [[[NSUserDefaults standardUserDefaults] valueForKey:@"vsplit1"] floatValue];
	if(f != 0){
		size = [[[[self mp4AutotagWindowSplitViewVertical] subviews] objectAtIndex:0] frame].size;
		size.width = f;
		[[[[self mp4AutotagWindowSplitViewVertical] subviews] objectAtIndex:0] setFrameSize:size];
		f = [[[NSUserDefaults standardUserDefaults] valueForKey:@"vsplit2"] floatValue];
		size = [[[[self mp4AutotagWindowSplitViewVertical] subviews] objectAtIndex:1] frame].size;
		size.width = f;
		[[[[self mp4AutotagWindowSplitViewVertical] subviews] objectAtIndex:1] setFrameSize:size];
	}
	f = [[[NSUserDefaults standardUserDefaults] valueForKey:@"vsplit3"] floatValue];
	if(f != 0){
		size = [[[[[self automatedAutotagWindow] vsplit] subviews] objectAtIndex:0] frame].size;
		size.width = f;
		[[[[[self automatedAutotagWindow] vsplit] subviews] objectAtIndex:0] setFrameSize:size];
		f = [[[NSUserDefaults standardUserDefaults] valueForKey:@"vsplit4"] floatValue];
		size = [[[[[self automatedAutotagWindow] vsplit] subviews] objectAtIndex:1] frame].size;
		size.width = f;
		[[[[[self automatedAutotagWindow] vsplit] subviews] objectAtIndex:1] setFrameSize:size];
	}
	//refresh properities
	[self refreshButtons];
	
	//[[self loadWnd] hide];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	//save out the userdefaults...
	[self hidePropPanel];
	CGFloat f = [[[[self mp4AutotagWindowSplitViewVertical] subviews] objectAtIndex:0] frame].size.width;
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:f] forKey:@"vsplit1"];
	f = [[[[self mp4AutotagWindowSplitViewVertical] subviews] objectAtIndex:1] frame].size.width;
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:f] forKey:@"vsplit2"];
	f = [[[[[self automatedAutotagWindow] vsplit] subviews] objectAtIndex:0] frame].size.width;
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:f] forKey:@"vsplit3"];
	f = [[[[[self automatedAutotagWindow] vsplit] subviews] objectAtIndex:1] frame].size.width;
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:f] forKey:@"vsplit4"];
}

-(void)awakeFromNib
{
	[POPmp4v2dylibloader loadMp4v2Lib:[[NSBundle mainBundle] pathForResource:@"libmp4v2.2.dylib" ofType:nil]];
	[[self mp4FileTagTableView] registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
	[[self dropFileHereImageWell] registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
}

-(void)hidePropPanel
{
	NSSize size = [[[[self mp4AutotagWindowSplitViewHorizontal] subviews] objectAtIndex:1] frame].size;
	//if the panel is not already hidden...
	if(size.height != 0)
	{
		//save the hsplit values
		[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:size.height] forKey:@"hsplit2"];
		NSInteger h = size.height;
		size = [[[[self mp4AutotagWindowSplitViewHorizontal] subviews] objectAtIndex:0] frame].size;
		[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:size.height] forKey:@"hsplit1"];
		
		//hide bottom panel
		h = h + size.height;
		size.height = h;
		[[[[self mp4AutotagWindowSplitViewHorizontal] subviews] objectAtIndex:0] setFrameSize:size];
		size.height = 0;
		[[[[self mp4AutotagWindowSplitViewHorizontal] subviews] objectAtIndex:1] setFrameSize:size];
	}
}
-(void)showPropPanel
{
	//show the bottom panel - but only if not already shown!
	if ([[[[self mp4AutotagWindowSplitViewHorizontal] subviews] objectAtIndex:1] frame].size.height == 0)
	{	
		CGFloat f = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hsplit2"] floatValue];
		NSSize size;
		if(f != 0){
			size = [[[[self mp4AutotagWindowSplitViewHorizontal] subviews] objectAtIndex:1] frame].size;
			size.height = f;
			[[[[self mp4AutotagWindowSplitViewHorizontal] subviews] objectAtIndex:1] setFrameSize:size];
			f = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hsplit1"] floatValue];
			size = [[[[self mp4AutotagWindowSplitViewHorizontal] subviews] objectAtIndex:0] frame].size;
			size.height = f;
			[[[[self mp4AutotagWindowSplitViewHorizontal] subviews] objectAtIndex:0] setFrameSize:size];
		}
	}
}

-(void)refreshButtons {
	if([_mp4FileTagTableView numberOfRows] > 0)
	{
		//[[self dropFileHereImageWell] setHidden:YES];
		[[self mp4FileTagsTableScrollView] setAlphaValue:1.0];
		if([[_mp4FileTagTableView selectedRowIndexes] count] > 0)
		{
			[[self removeButton] setAction:@selector(removeMp4Click:)];
			[[self autotagButton] setAction:@selector(autotagClick:)];
			[[self saveButton] setAction:@selector(saveMp4Click:)];
			[[self automatedAutotagButton] setAction:@selector(automatedAutotagClick:)];
			if([[_mp4FileTagTableView selectedRowIndexes] count] == 1) [self showPropPanel];
			else [self hidePropPanel];
		}
		else {
			[[self removeButton] setAction:nil];
			[[self autotagButton] setAction:nil];
			[[self saveButton] setAction:nil];
			[[self automatedAutotagButton] setAction:nil];
			[self hidePropPanel];
		}
	}
	else {
		[[self automatedAutotagButton] setAction:nil];
		[[self saveAllButton] setAction:nil];
		[[self removeButton] setAction:nil];
		[[self autotagButton] setAction:nil];
		[[self saveButton] setAction:nil];
		//[[self dropFileHereImageWell] setHidden:NO];
		[[self mp4FileTagsTableScrollView] setAlphaValue:0.3];
		[self hidePropPanel];
	}
}

- (IBAction)addMp4Click:(id)sender {
	NSOpenPanel* oDlg = [NSOpenPanel openPanel];
    [oDlg setCanChooseFiles:YES];
	[oDlg setAllowsMultipleSelection:YES];
	[oDlg setCanChooseDirectories:NO];
    [oDlg setCanCreateDirectories:NO];
    [oDlg beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton)
        {
            NSArray* urls = [oDlg URLs];
			[mp4FileTagTable addMp4Files:urls atIndex:-1];
			urls = nil;
        }
    }];
}

- (IBAction)removeMp4Click:(id)sender {
	NSIndexSet *idxSet = [[self mp4FileTagTableView] selectedRowIndexes];
	if([idxSet count] > 0)
	{
		NSUInteger lastIndex = [idxSet lastIndex];
		while (lastIndex != NSNotFound)
		{
			[mp4FileTagTable removeMp4FileTagAt:(int)lastIndex];
			
			//increment
			lastIndex = [idxSet indexLessThanIndex: lastIndex];
		}
	}
	else
	{
		NSRunAlertPanel(@"Mp4Autotag",
						@"Please select a file first.",
						@"OK", nil, nil);
	}
}

- (IBAction)saveMp4Click:(id)sender {
	NSIndexSet *idxSet = [[self mp4FileTagTableView] selectedRowIndexes];
	if([idxSet count] > 0)
	{
		[idxSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
			[mp4FileTagTable saveMp4FileTagAt:(int)idx];
		}];
	}
	else
	{
		NSRunAlertPanel(@"Mp4Autotag",
						@"Please select a file first.",
						@"OK", nil, nil);
	}
}

- (IBAction)saveAllMp4Click:(id)sender {
	if([[mp4FileTagTable mp4tags] count] > 0)
		[mp4FileTagTable saveAllMp4FileTags];
	else
		NSRunAlertPanel(@"Mp4Autotag", 
						@"Please add a file first.",
						@"OK", nil, nil);
}

- (IBAction)selectImageClick:(id)sender {
	int idx = (int)[[self mp4FileTagTableView] selectedRow];
	if(idx >= 0) {
		NSOpenPanel* oDlg = [NSOpenPanel openPanel];
		[oDlg setCanChooseFiles:YES];
		[oDlg setAllowsMultipleSelection:NO];
		[oDlg setCanChooseDirectories:NO];
		[oDlg setCanCreateDirectories:NO];
		[oDlg beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
			if (result == NSFileHandlingPanelOKButton)
			{
				NSArray* urls = [oDlg URLs];
				NSString* imgfn = [[urls objectAtIndex:0] path ];
				if([[imgfn pathExtension] compare:@"jpg" options:NSCaseInsensitiveSearch] == 0)
				{
					POPMp4FileTag* tag = [[mp4FileTagTable mp4tags] objectAtIndex:idx];
					[tag setImage:[[NSImage alloc] initWithContentsOfFile:imgfn]];
					[mp4FileTagTable reloadAll];
				}
			}
		}];
	}
	else 
		NSRunAlertPanel(@"Mp4Autotag", 
						@"Please select a file first.",
						@"OK", nil, nil);
}

- (IBAction)preferencesClick:(id)sender {
	NSInteger i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"renameFile"] intValue];
	[[self preferencesRenameCheckBox] setState:i];
	i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"episodeCoverArt"] intValue];
	[[self preferencesEpisodeCoverArtMatrix] setState:YES atRow:i column:0];
	i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"useITunes"] intValue];
	[[self preferencesUseITunesCheckBox] setState:i];
	i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"fixForNetwork"] intValue];
	[[self preferencesFixForNetworkCheckBox] setState:i];
	i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"usePopmedicProxy"] intValue];
	[[self preferencesProxySearchCheckBox] setState:i];
	i = [[[NSUserDefaults standardUserDefaults] valueForKey:@"addWatermark"] intValue];
	[[self preferencesAddWatermarkCheckBox] setState:i];
	[[NSApplication sharedApplication] beginSheet:[self preferencesWindow]
								   modalForWindow:[self window]
									modalDelegate:self
								   didEndSelector:@selector(preferencesWindowSheetEnded:returnCode:contextInfo:)
									  contextInfo:(void*)[self searchResultWindow]];
}

- (IBAction)helpClick:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/popmedic/mp4autotag#mp4autotag"]];
}

//autotaging functions.....
-(bool) autotagNext {
	if(attags_idx < [attags count]) {
		POPMp4FileTag* tag = [attags objectAtIndex:attags_idx];
		attags_idx = attags_idx + 1;
		[[self seachFilenameLabel] setStringValue:[[tag filename] lastPathComponent]];
		[[self searchTableView] setDataSource:nil];
		[[self searchTableView] reloadData];
		[_loadWnd show:[NSString stringWithFormat:@"Searching for %@...", [tag filename]]];
		if([[self customSearchWindowUseSameSeriesCheckBox] state])
		{
			[tag setProperty:@"TV Show" value:[[self customSearchWindowSeriesTextField] stringValue]];
			[tag setCustomSeriesSearch:YES];
		}
		mp4SearchFileTagTable = [[POPMp4FileTagSearch alloc] init];
		[[self searchTableView] setDataSource:(id<NSTableViewDataSource>)mp4SearchFileTagTable];
		[mp4SearchFileTagTable searchWithFileTag:tag];
		[[self searchTableView] reloadData];
		[[self searchTableView] selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
		[_loadWnd hide];
		
		if([[self searchTableView] numberOfRows] == 0)
		{
			NSInteger rtn =  NSRunAlertPanel(@"Mp4Autotag",
											 @"Unable to find movie/show in databases. Try a custom search, or skip this file?",
											 @"Custom Search", 
											 @"Skip File", 
											 nil);
			if(rtn == NSAlertDefaultReturn)
			{
				[self searchResultWindowSearchClick:self];
			}
			else if(rtn == NSAlertAlternateReturn)
			{
				[self autotagNext];
			}
		}
		
		return true;
	}
	[[NSApplication sharedApplication] endSheet:[self searchResultWindow] returnCode:0];
	return false;
}

-(void) autotag {
	[[self customSearchWindowUseSameSeriesCheckBox] setState:NO];
	[[NSApplication sharedApplication] beginSheet:[self searchResultWindow] 
								   modalForWindow:[self window]
									modalDelegate:self
								   didEndSelector:@selector(searchResultSheetEnded:returnCode:contextInfo:) 
									  contextInfo:(void*)[self searchResultWindow]];
	[self autotagNext];
}

- (IBAction)autotagClick:(id)sender {
	NSIndexSet *idxSet = [[self mp4FileTagTableView] selectedRowIndexes];
	if([idxSet count] > 0)
	{
		NSMutableArray* ma = [[NSMutableArray alloc] init];
		[idxSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
			POPMp4FileTag* tag = [[mp4FileTagTable mp4tags] objectAtIndex:idx];
			[ma addObject:tag];
		}];
		attags = ma;
		attags_idx = 0;
		[self autotag];
	}
	else
	{
		NSRunAlertPanel(@"Mp4Autotag",
						@"Please select a file first.",
						@"OK", nil, nil);
	}
}

- (IBAction)automatedAutotagClick:(id)sender {
	NSIndexSet *idxSet = [[self mp4FileTagTableView] selectedRowIndexes];
	if([idxSet count] > 0)
	{
		NSMutableArray* ma = [[NSMutableArray alloc] init];
		[idxSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
			POPMp4FileTag* tag = [[mp4FileTagTable mp4tags] objectAtIndex:idx];
			[ma addObject:tag];
		}];
		attags = ma;
		attags_idx = 0;
		[[self automatedAutotagWindow] clearResults];
		[[NSApplication sharedApplication] beginSheet:[self automatedAutotagWindow]
									   modalForWindow:[self window]
										modalDelegate:self//[self automatedAutotagWindow]
									   didEndSelector:@selector(automatedAutotagWindowSheetEnded:returnCode:contextInfo:)
										  contextInfo:(void*)[self automatedAutotagWindow]];
		[[self automatedAutotagWindow] autotagQueue:attags];
	}
	else
	{
		NSRunAlertPanel(@"Mp4Autotag",
						@"Please select a file first.",
						@"OK", nil, nil);
	}
}
//end autotaging functions.....


//SearchResultWindow-------------
- (IBAction)searchResultWindowSearchClick:(id)sender {
	if(mp4SearchFileTagTable != nil)
	{
		if([mp4SearchFileTagTable isMovie]) {
			[[self customSearchWindowTabView] selectTabViewItemAtIndex:1];
			[[self customSearchWindowMovieTextField] setStringValue:[mp4SearchFileTagTable searchString]];
		}
		else {
			[[self customSearchWindowTabView] selectTabViewItemAtIndex:0];
			[[self customSearchWindowSeriesTextField] setStringValue:[mp4SearchFileTagTable seriesString]];
			[[self customSearchWindowSeasonNumberTextField] setStringValue:[mp4SearchFileTagTable seasonString]];
			[[self customSearchWindowEpisodeNumberTextField] setStringValue:[mp4SearchFileTagTable episodeString]];
		}
		
	}
	[[NSApplication sharedApplication] beginSheet:[self customSearchWindow] 
								   modalForWindow:[self searchResultWindow]
									modalDelegate:self
								   didEndSelector:@selector(customSearchSheetEnded:returnCode:contextInfo:) 
									  contextInfo:(void*)[self customSearchWindow]];
}

- (IBAction)searchDoneClick:(id)sender {
	[[NSApplication sharedApplication] endSheet:[self searchResultWindow] returnCode:0];
}

- (IBAction)searchTagClick:(id)sender {
	long idx = [[self searchTableView] selectedRow];
	if(idx >= 0){
		POPMp4FileTag* otag = [attags objectAtIndex:attags_idx-1];
		POPMp4FileTag* ntag = [mp4SearchFileTagTable chooseResult:(int)idx];
		if(ntag != nil)
		{
			[_loadWnd show:[NSString stringWithFormat:@"Merging tag and saving ...\"%@\"\nRename to...\"%@\"", [otag filename], [NSString stringWithFormat:@"%@.mp4", [ntag property:@"Name"]]]];
			[otag mergeData:ntag];
			[otag save];
			if([[[NSUserDefaults standardUserDefaults] valueForKey:@"fixForNetwork"] intValue]) {
				fixMOOV((char*)[[otag filename] cStringUsingEncoding:NSASCIIStringEncoding]);
			}
			if([[[NSUserDefaults standardUserDefaults] valueForKey:@"renameFile"] intValue]) {
				[otag rename];
			}
			[_loadWnd hide];
		}
		[self autotagNext];
	}
	else 
		NSRunAlertPanel(@"Mp4Autotag", 
						@"Please select a result first.",
						@"OK", nil, nil);
}

- (void)searchResultSheetEnded:(NSNotification *)notification 
					returnCode:(NSInteger)rtnCode 
				   contextInfo:(NSObject*)cInfo
{
	[mp4FileTagTable reloadAll];
	[[self searchTableView] setDataSource:nil];
	[[self searchTableView] reloadData];
	[[self searchResultWindow] close];
}

//CustomSearchWindow--------------------------
- (IBAction)customSearchWindowSearchClick:(id)sender {
	if(mp4SearchFileTagTable != nil) {
		mp4SearchFileTagTable = nil;
	}
	mp4SearchFileTagTable = [[POPMp4FileTagSearch alloc] init];
	
	POPMp4FileTag* tag = [[POPMp4FileTag alloc] init];
	if([[[[self customSearchWindowTabView] selectedTabViewItem] label] compare:@"TV Search"] == 0) {
		[tag setProperty:@"Media Type" value:@"tvshow"];
		[tag setProperty:@"TV Show" value:[[self customSearchWindowSeriesTextField] stringValue]];
		[tag setProperty:@"TV Season" value:[[self customSearchWindowSeasonNumberTextField] stringValue]];
		[tag setProperty:@"TV Episode" value:[[self customSearchWindowEpisodeNumberTextField] stringValue]];
		[tag setCustomSeriesSearch:YES];
		[_loadWnd show:[NSString stringWithFormat:@"Searching for TV Show: %@\nSeason: %@\nEpisode: %@", [tag property:@"TV Show"], [tag property:@"TV Season"], [tag property:@"TV Episode"]]];
	}
	else {
		[tag setProperty:@"Media Type" value:@"movie"];
		[tag setProperty:@"Name" value:[[self customSearchWindowMovieTextField] stringValue]];
		[_loadWnd show:[NSString stringWithFormat:@"Searching for Movie: %@", [tag property:@"Name"]]];
	}
	
	[[self searchTableView] setDataSource:(id<NSTableViewDataSource>)mp4SearchFileTagTable];
	[mp4SearchFileTagTable searchWithFileTag:tag /*tableView:[self searchTableView]*/];
	[[self searchTableView] reloadData];
	[[self searchTableView] selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
	/*[mp4SearchFileTagTable searchWithFileTag:tag
								   tableView:[self searchTableView]];*/
	[_loadWnd hide];
	
	if([[self searchTableView] numberOfRows] == 0)
	{
		NSInteger rtn =  NSRunAlertPanel(@"Mp4Autotag", 
										 @"Unable to find movie/show in databases. Try a custom search, or skip this file?",
										 @"Custom Search", 
										 @"Skip File", 
										 nil);
		if(rtn == NSAlertDefaultReturn)
		{
			return;
		}
		else if(rtn == NSAlertAlternateReturn)
		{
			[[NSApplication sharedApplication] endSheet:[self customSearchWindow] returnCode:0];
			[self autotagNext];
		}
	}
	else {
		[[NSApplication sharedApplication] endSheet:[self customSearchWindow] returnCode:0];
	}
}

- (IBAction)customSearchWindowCloseClick:(id)sender {
	[[NSApplication sharedApplication] endSheet:[self customSearchWindow] returnCode:0];
}

- (void)customSearchSheetEnded:(NSNotification *)notification 
					returnCode:(NSInteger)rtnCode 
				   contextInfo:(NSObject*)cInfo
{
	[[self customSearchWindow] close];
}

//PreferencesWindow---------------------------
- (IBAction)preferencesWindowCloseClick:(id)sender {
	[[NSApplication sharedApplication] endSheet:[self preferencesWindow] returnCode:0];
}

- (void)preferencesWindowSheetEnded:(NSNotification *)notification 
						 returnCode:(NSInteger)rtnCode 
						contextInfo:(NSObject*)cInfo
{
	[[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%li", [[self preferencesRenameCheckBox] state]] forKey:@"renameFile"];
	[[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%li", [[self preferencesEpisodeCoverArtMatrix] selectedRow]] forKey:@"episodeCoverArt"];
	[[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%li", [[self preferencesUseITunesCheckBox] state]] forKey:@"useITunes"];
	[[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%li", [[self preferencesFixForNetworkCheckBox] state]] forKey:@"fixForNetwork"];
	[[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%li", [[self preferencesProxySearchCheckBox] state]] forKey:@"usePopmedicProxy"];
	[[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%li", [[self preferencesAddWatermarkCheckBox] state]] forKey:@"addWatermark"];
	[[self preferencesWindow] close];
}

- (void)automatedAutotagWindowSheetEnded:(NSNotification *)notification 
							  returnCode:(NSInteger)rtnCode 
							 contextInfo:(NSObject*)cInfo
{
	[mp4FileTagTable reloadAll];
}
@end