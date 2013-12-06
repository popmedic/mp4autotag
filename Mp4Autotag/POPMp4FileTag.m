//
//  POPMp4FileTag.m
//  Mp4Autotag
//
//  Created by Kevin Scardina on 9/29/12.
//  Copyright (c) 2012 The Popmedic. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "iTunes.h"
#import "POPMp4FileTag.h"
#import "POPmp4v2dylibloader.h"
#import "POPFileMan.h"
#import "POPTask.h"
#import "POPImage.h"

@implementation POPMp4FileTag
{
	NSArray* keysOrder;
	NSArray* numFlags;
	NSArray* allowedMediaTypes;
	NSArray* doNotMerge;
}

@synthesize properties = _properties;
@synthesize filename = _filename;
@synthesize coverArtPieces = _coverArtPieces;
@synthesize image = _image;
@synthesize dbID = _dbID;
@synthesize customSeriesSearch = _customSeriesSearch;
@synthesize seriesImageUrl = _seriesImageUrl;
@synthesize imageUrl = _imageUrl;

-(id) init {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"dd-MM-yyyy"];
	_filename = @"";
	_coverArtPieces = 0;
	_image = nil;
	_dbID = 0;
	_customSeriesSearch = NO;
	_seriesImageUrl = nil;
	_imageUrl = nil;
	numFlags = [NSArray arrayWithObjects:@"-b", @"-d",@"-D",@"-H",@"-I",@"-L",@"-M",@"-n",@"-t",@"-T"/*,@"-y"*/, nil];
	allowedMediaTypes = [NSArray arrayWithObjects:@"tvshow", @"movie", @"music", nil];
	doNotMerge = [NSArray arrayWithObject:@"Purchase Date"];
	keysOrder = [NSArray arrayWithObjects:
				 @"Name",
				 @"Media Type",
				 @"TV Show",
				 @"Genre",
				 @"Grouping",
				 @"TV Episode",
				 @"TV Season",
				 @"TV Episode Number",
				 @"TV Network",
				 @"Short Description",
				 @"Long Description",
				 @"Album",
				 @"Artist",
				 @"Album Artist",
				 @"Composer",
				 @"cnID",
				 @"Category",
				 @"Release Date",
				 @"Purchase Date",
				 @"Copyright",
				 @"Track",
				 @"Tracks",
				 @"Disk",
				 @"Disks",
				 @"BPM",
				 @"Comments",
				 @"HD Video",
				 @"Encoded with",
				 @"Encoded by",
				 @"Lyrics",
				 nil];
	_properties = 
		[NSDictionary dictionaryWithObjects:
			[NSArray arrayWithObjects:
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-s", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-a", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-w", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-E", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-e", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-y", @"0", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-A", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-t", @"1", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-T", @"1", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-d", @"1", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-D", @"1", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-g", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-G", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-b", @"0", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-c", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-R", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-C", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-H", @"1", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-i", @"Movie", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-S", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-N", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-o", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-m", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-l", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-M", @"0", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-n", @"0", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-I", @"0", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-L", @"", nil]
										  forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-k", @"Movies", nil]
												   forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				 [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-K", [dateFormatter stringFromDate:[NSDate new]], nil]
													forKeys:[NSArray arrayWithObjects:@"flag", @"value", nil]],
				nil
			]
									forKeys:
			[NSArray arrayWithObjects:
				@"Name",
				@"Artist",
				@"Composer",
				@"Encoded with",
				@"Encoded by",
				@"Release Date",
				@"Album",
				@"Track",
				@"Tracks",
				@"Disk",
				@"Disks",
				@"Genre",
				@"Grouping",
				@"BPM",
				@"Comments",
				@"Album Artist",
				@"Copyright",
				@"HD Video",
				@"Media Type",
				@"TV Show",
				@"TV Network",
				@"TV Episode Number",
				@"Short Description",
				@"Long Description",
				@"TV Episode",
				@"TV Season",
				@"cnID",
				@"Lyrics",
				@"Category",
				@"Purchase Date",
				nil
			]
		];
	
	return [super init];
}

-(id) initWithDictionary:(NSDictionary*)dic {
	POPMp4FileTag* rtn = [self init];
	for(int i = 0; i < [[_properties allKeys] count]; i++) {
		NSString* key = [[_properties allKeys] objectAtIndex:i];
		NSDictionary* d = [dic objectForKey:key];
		NSString* val = [d objectForKey:@"value"]; 
		[rtn setProperty:key value:val];
	}
	[rtn setDbID:[[dic objectForKey:@"dbid"] intValue]];
	[rtn setSeriesImageUrl:[dic objectForKey:@"Series Image Path"]];
	[rtn setImageUrl:[dic objectForKey:@"Image Path"]];
	if([rtn imageUrl] != nil)
	{
		[rtn setImage:[[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[rtn imageUrl]]]]; 
	}
	return rtn;
}

-(id) initWithFile:(NSString*)filename {
	if(![[NSFileManager defaultManager] fileExistsAtPath:filename])
	{
		@throw [NSException exceptionWithName:@"FileNotFoundException"
									   reason:[NSString stringWithFormat: @"File \"%@\" Not Found on System", filename]
									 userInfo:nil];
	}
	
	POPMp4FileTag* rtn = [self init];
	_filename = filename;
	/*NSString* mp4info_path = [[NSBundle mainBundle] pathForResource:@"mp4info" ofType:nil];
	NSLog(@"mp4info path: %@", mp4info_path);
	NSError *error;
	NSString *info = [POPTask launchedWithLaunchPathAndWaitReturnStdio:mp4info_path options:[NSArray arrayWithObjects: filename, nil]];
	NSLog(@"%@",info);
	NSRegularExpression *rgx = [NSRegularExpression regularExpressionWithPattern:@"can\\\'t open" options:NSRegularExpressionCaseInsensitive error:&error];
	if([rgx numberOfMatchesInString:info options:0 range:NSMakeRange(0, [info length])]) {
		NSString* reason = [NSString stringWithFormat: @"Unable to open file: \"%@\"", _filename];
		@throw [NSException exceptionWithName:@"FileNotMp4"
									   reason:reason
									 userInfo:nil];
	*/	
	MP4FileHandle v2file = _MP4Modify([_filename cStringUsingEncoding:NSUTF8StringEncoding], 0);
    if(v2file == MP4_INVALID_FILE_HANDLE) {
        @throw [NSException exceptionWithName:@"FileNotFoundException"
									   reason:@"MP4Modify failed."
									 userInfo:nil];
    }
	const MP4Tags* v2tags = _MP4TagsAlloc();
	_MP4TagsFetch(v2tags, v2file);
	if(v2tags->name)[rtn setProperty: @"Name" value:[NSString stringWithCString: v2tags->name encoding:NSUTF8StringEncoding]];
	if(v2tags->album)[rtn setProperty: @"Album" value:[NSString stringWithCString: v2tags->album encoding:NSUTF8StringEncoding]];
	if(v2tags->artist)[rtn setProperty: @"Artist" value:[NSString stringWithCString: v2tags->artist encoding:NSUTF8StringEncoding]];
	if(v2tags->albumArtist)[rtn setProperty: @"Album Artist" value:[NSString stringWithCString: v2tags->albumArtist encoding:NSUTF8StringEncoding]];
	if(v2tags->grouping)[rtn setProperty: @"Grouping" value:[NSString stringWithCString: v2tags->grouping encoding:NSUTF8StringEncoding]];
	if(v2tags->composer)[rtn setProperty: @"Composer" value:[NSString stringWithCString: v2tags->composer encoding:NSUTF8StringEncoding]];
	if(v2tags->comments)[rtn setProperty: @"Comments" value:[NSString stringWithCString: v2tags->comments encoding:NSUTF8StringEncoding]];
	if(v2tags->genre)[rtn setProperty: @"Genre" value:[NSString stringWithCString: v2tags->genre encoding:NSUTF8StringEncoding]];
	if(v2tags->releaseDate)[rtn setProperty: @"Release Date" value:[NSString stringWithCString: v2tags->releaseDate encoding:NSUTF8StringEncoding]];
	if(v2tags->track)[rtn setProperty: @"Track" value:[NSString stringWithFormat:@"%u", v2tags->track->index]];
	if(v2tags->track)[rtn setProperty: @"Tracks" value:[NSString stringWithFormat:@"%u", v2tags->track->total]];
	if(v2tags->disk)[rtn setProperty: @"Disk" value:[NSString stringWithFormat:@"%u", v2tags->disk->index]];
	if(v2tags->disk)[rtn setProperty: @"Disks" value:[NSString stringWithFormat:@"%u", v2tags->disk->total]];
	if(v2tags->tempo)[rtn setProperty: @"BPM" value:[NSString stringWithFormat:@"%u", *v2tags->tempo]];
	if(v2tags->tvShow)[rtn setProperty: @"TV Show" value:[NSString stringWithCString: v2tags->tvShow encoding:NSUTF8StringEncoding]];
	if(v2tags->tvEpisodeID)[rtn setProperty: @"TV Episode Number" value:[NSString stringWithCString: v2tags->tvEpisodeID encoding:NSUTF8StringEncoding]];
	if(v2tags->tvNetwork)[rtn setProperty: @"TV Network" value:[NSString stringWithCString: v2tags->tvNetwork encoding:NSUTF8StringEncoding]];
	if(v2tags->tvEpisode)[rtn setProperty: @"TV Episode" value:[NSString stringWithFormat:@"%u", *v2tags->tvEpisode]];
	if(v2tags->tvSeason)[rtn setProperty: @"TV Season" value:[NSString stringWithFormat:@"%u", *v2tags->tvSeason]];
	if(v2tags->description)[rtn setProperty: @"Short Description" value:[NSString stringWithCString: v2tags->description encoding:NSUTF8StringEncoding]];
	if(v2tags->longDescription)[rtn setProperty: @"Long Description" value:[NSString stringWithCString: v2tags->longDescription encoding:NSUTF8StringEncoding]];
	if(v2tags->category)[rtn setProperty: @"Category" value:[NSString stringWithCString: v2tags->category encoding:NSUTF8StringEncoding]];
	if(v2tags->lyrics)[rtn setProperty: @"Lyrics" value:[NSString stringWithCString: v2tags->lyrics encoding:NSUTF8StringEncoding]];
	if(v2tags->copyright)[rtn setProperty: @"Copyright" value:[NSString stringWithCString: v2tags->copyright encoding:NSUTF8StringEncoding]];
	if(v2tags->purchaseDate)[rtn setProperty: @"Purchase Date" value:[NSString stringWithCString: v2tags->purchaseDate encoding:NSUTF8StringEncoding]];
	if(v2tags->encodingTool)[rtn setProperty: @"Encoded with" value:[NSString stringWithCString: v2tags->encodingTool encoding:NSUTF8StringEncoding]];
	if(v2tags->encodedBy)[rtn setProperty: @"Encoded by" value:[NSString stringWithCString: v2tags->encodedBy encoding:NSUTF8StringEncoding]];
	if(v2tags->hdVideo)[rtn setProperty: @"HD Video" value:[NSString stringWithFormat:@"%u", *v2tags->hdVideo]];
	if(v2tags->mediaType){
		if(*v2tags->mediaType == 10) [rtn setProperty: @"Media Type" value:@"tvshow"];
		else if(*v2tags->mediaType == 6) [rtn setProperty: @"Media Type" value:@"music"];
		else [rtn setProperty: @"Media Type" value:@"movie"];

	}
	if(v2tags->artworkCount){
		[rtn setCoverArtPieces: v2tags->artworkCount];
		NSData* artData = [NSData dataWithBytes:v2tags->artwork->data length:v2tags->artwork->size];
		[rtn setImage:[[NSImage alloc] initWithData:artData]];
	}

	_MP4TagsFree(v2tags);
	_MP4Close(v2file, 0);
	return rtn;

/*
	[info enumerateLinesUsingBlock: ^(NSString *line, BOOL *stop) {
		if(line != nil && [line compare:@""] != 0) {
			if([line characterAtIndex:0] == ' ')
			{
				NSArray* kvpair = [[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@":"];
				if([kvpair count] == 2) {
					NSString* key = [[kvpair objectAtIndex:0]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					NSString* value = [[kvpair objectAtIndex:1]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					
					NSMutableDictionary* prop = [[rtn properties] valueForKey:key];
					
					if(prop != nil) {
						[self setProperty:key value:value];
						[prop setObject:value forKey:@"value"];
					}
					else {
						NSLog(@"No property with key: %@",key);
					}
					
					if([key compare:@"Cover Art pieces"] == 0)
					{
						[rtn setCoverArtPieces:[value intValue]];
					}
					else if ([key compare:@"HD Video"] == 0) {
						if([value compare:@"yes" options:NSCaseInsensitiveSearch] == 0) {
							[[[rtn properties] valueForKey:key] setObject:@"1" forKey:@"value"];
						}
						else {
							[[[rtn properties] valueForKey:key] setObject:@"0" forKey:@"value"];
						}
					}
					else if ([key compare:@"Track"] == 0 || [key compare:@"Disk"] == 0) {
						NSArray* pair = [value componentsSeparatedByString:@" of "];
						if([pair count] == 2) {
							NSString* a = [pair objectAtIndex:0];
							NSString* b = [pair objectAtIndex:1];
							NSString* s = [NSString stringWithFormat:@"%@s", key];
							[[[rtn properties] valueForKey:key] setObject:a forKey:@"value"];
							[[[rtn properties] valueForKey:s] setObject:b forKey:@"value"];
						}
					}else if ([key compare:@"Lyrics"] == 0) {
						[[[rtn properties] valueForKey:key] setObject:@"0" forKey:@"value"];
					}
					else if ([key compare:@"Media Type"] == 0) {
						if([value compare:@"TV Show"] == 0)
							[[[rtn properties] valueForKey:key] setObject:@"tvshow" forKey:@"value"];
						else if ([value compare:@"Movie"] == 0)
							[[[rtn properties] valueForKey:key] setObject:@"movie" forKey:@"value"];
						else if ([value compare:@"Music"] == 0)
							[[[rtn properties] valueForKey:key] setObject:@"music" forKey:@"value"];
						else
							[[[rtn properties] valueForKey:key] setObject:@"" forKey:@"value"];
					}
				}
				else {
					NSLog(@"Not a valid property string: %@", line);
				}
			}
		}
	}];
	
	if([rtn coverArtPieces] > 0)
	{

		info = [POPTask launchedWithLaunchPathAndWaitReturnStdio:[[NSBundle mainBundle] pathForResource:@"mp4art" ofType:nil] options:[NSArray arrayWithObjects: @"--extract", filename, nil]];
		NSString* imgfn = nil;
		if([[NSFileManager defaultManager] fileExistsAtPath:[[filename stringByDeletingPathExtension] stringByAppendingString:@".art[0].jpg"]])
		{
			imgfn = [[filename stringByDeletingPathExtension] stringByAppendingString:@".art[0].jpg"];
		}
		else if ([[NSFileManager defaultManager] fileExistsAtPath:[[filename stringByDeletingPathExtension] stringByAppendingString:@".art[0].png"]])
		{
			imgfn = [[filename stringByDeletingPathExtension] stringByAppendingString:@".art[0].png"];
		}
		if(imgfn != nil) {
			NSError *error;
			[rtn setImage:[[NSImage alloc] initWithContentsOfFile:imgfn]];
			[[NSFileManager defaultManager] removeItemAtPath:imgfn error:&error];
		}
	}

	*/	
		
}

-(bool) save {
	MP4FileHandle v2file = _MP4Modify([_filename cStringUsingEncoding:NSUTF8StringEncoding], 0);
    if(v2file == MP4_INVALID_FILE_HANDLE) {
		NSLog(@"MP4Modify failed.");
		return false;
    }
	
	const MP4Tags* old_v2tags = _MP4TagsAlloc();
	_MP4TagsFetch(old_v2tags, v2file);
	
	const MP4Tags* v2tags = _MP4TagsAlloc();
	
	_MP4TagsSetName(v2tags, [[self property:@"Name"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetArtist(v2tags, [[self property:@"Artist"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetComposer(v2tags, [[self property:@"Composer"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetEncodingTool(v2tags, [[self property:@"Encoded with"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetEncodedBy(v2tags, [[self property:@"Encoded by"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetReleaseDate(v2tags, [[self property:@"Release Date"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetAlbum(v2tags, [[self property:@"Album"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetGenre(v2tags, [[self property:@"Genre"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetGrouping(v2tags, [[self property:@"Grouping"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetComments(v2tags, [[self property:@"Comments"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetAlbumArtist(v2tags, [[self property:@"Album Artist"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetCopyright(v2tags, [[self property:@"Copyright"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetPurchaseDate(v2tags, [[self property:@"Purchase Date"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetTVShow(v2tags, [[self property:@"TV Show"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetTVNetwork(v2tags, [[self property:@"TV Network"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetTVEpisodeID(v2tags, [[self property:@"TV Episode Number"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetDescription(v2tags, [[self property:@"Short Description"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetLongDescription(v2tags, [[self property:@"Long Description"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetXID(v2tags, [[self property:@"cnID"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetLyrics(v2tags, [[self property:@"Lyrics"] cStringUsingEncoding:NSUTF8StringEncoding]);
	_MP4TagsSetCategory(v2tags, [[self property:@"Category"] cStringUsingEncoding:NSUTF8StringEncoding]);
	
	uint8_t n8;
	n8 = [[self property:@"HD Video"] intValue];
	_MP4TagsSetHDVideo(v2tags, &n8);
	
	uint16_t n16;
	n16 = [[self property:@"BPM"] intValue];
	_MP4TagsSetTempo(v2tags, &n16);
	
	uint32_t n32;
	n32 = [[self property:@"TV Episode"] intValue];
	_MP4TagsSetTVEpisode(v2tags, &n32);
	n32 = [[self property:@"TV Season"] intValue];
	_MP4TagsSetTVSeason(v2tags, &n32);
	
	MP4TagTrack track;
	track.index = [[self property:@"Track"] intValue];
	track.total = [[self property:@"Tracks"] intValue];
	_MP4TagsSetTrack(v2tags, &track);
	MP4TagDisk disk;
	disk.index = [[self property:@"Disk"] intValue];
	disk.total = [[self property:@"Disks"] intValue];
	_MP4TagsSetDisk(v2tags, &disk);
	
	MP4TagArtwork artwork;
	NSData* artworkData = [[self image] TIFFRepresentation];
	NSBitmapImageRep *artworkRep = [NSBitmapImageRep imageRepWithData:artworkData];
    NSDictionary *artworkProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    artworkData = [artworkRep representationUsingType:NSJPEGFileType properties:artworkProps];
	artwork.type = 0x13;
	artwork.size = (unsigned int)[artworkData length];
	artwork.data = (void*)[artworkData bytes];
	_MP4TagsAddArtwork(v2tags, &artwork);
	
	if([[self property:@"Media Type"] compare:@"tvshow"] == 0)
	{
		n8 = 10;
	}
	else if([[self property:@"Media Type"] compare:@"music"] == 0)
	{
		n8 = 6;
	}
	else
	{
		n8 = 9;
	}
	_MP4TagsSetMediaType(v2tags, &n8);
	
    _MP4TagsStore(v2tags, v2file);
	
    _MP4TagsFree(v2tags);
	
	/*iTunesApplication* itunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	if([itunes isRunning])
	{
		//[itunes activate];
		NSLog(@"Using iTunes Version %@", [itunes version]);
		NSArray *sources = [[itunes sources] get];
		iTunesLibraryPlaylist* pl = [[(iTunesSource*)[sources objectAtIndex:0] libraryPlaylists] objectAtIndex:0];
		NSString *ot_search = [[NSString alloc] initWithCString:old_v2tags->name encoding:NSUTF8StringEncoding];
		SBElementArray* items = (SBElementArray*)[pl searchFor:ot_search only:iTunesESrASongs];
		//SBElementArray* items = [pl fileTracks];
		for (iTunesFileTrack *item in items) {
			NSString *locp = [[item location] path];
			//NSLog(@"%@.location = %@", [item name], locp);
			if([_filename compare:locp] == 0)
			{
				//sleep(1);
				[item refresh];
				break;
			}
		}
	}*/
	_MP4TagsFree(old_v2tags);
    _MP4Close(v2file, 0);
	
	return true;
}

-(NSString*) property:(NSString*)prop {
	return [[_properties valueForKey:prop] valueForKey:@"value"];
}

-(bool) setProperty:(NSString*)prop value:(NSString*)val {
	if(val != nil && [val isKindOfClass:[NSString class]]){
		NSString* flag = [[_properties valueForKey:prop] valueForKey:@"flag"];
		if([numFlags containsObject:flag]){
			val = [NSString stringWithFormat:@"%i", [val intValue]];
		}
		if([prop compare:@"Media Type"] == 0){
			if(![allowedMediaTypes containsObject:val]){
				val = @"movie";
			}
		}
		[[_properties valueForKey:prop] setValue:[val stringByReplacingOccurrencesOfString:@":" withString:@"-"] forKey:@"value"];
		return true;
	}
	return false;
}

-(bool) rename {
	NSString* nn;
	if([self filename] != @"")
	{
		if([self property:@"Name"] != @"")
		{
			nn = [NSString stringWithFormat:@"%@/%@.mp4", [[self filename] stringByDeletingLastPathComponent], [self property:@"Name"]];
			return [self renameTo:nn];
		}
	}
	return false;
}

-(bool) renameTo:(NSString*)to {
	NSError *error;
	if([self filename] != @"")
	{
		if([self property:@"Name"] != @"" && [[self filename] compare:to] != 0)
		{
			if([[NSFileManager defaultManager] fileExistsAtPath:to])
			{
				if(![[NSFileManager defaultManager] removeItemAtPath:to error:&error])
				{
					NSLog(@"ERROR*** %@", [error description]);
				}
			}
			if([[NSFileManager defaultManager] moveItemAtPath:[self filename] toPath:to error:&error]){
				//special for me...
				NSString* obf = [[[self filename] stringByDeletingPathExtension] stringByAppendingString:@"-SD.bif"];
				NSString* nbf = [NSString stringWithFormat:@"%@/%@-SD.bif", [[self filename] stringByDeletingLastPathComponent], [self property:@"Name"]];
				if([[NSFileManager defaultManager] fileExistsAtPath:obf])
					[[NSFileManager defaultManager] moveItemAtPath:obf toPath:nbf error:&error];
				NSString* ojf = [[[self filename] stringByDeletingPathExtension] stringByAppendingString:@"-SD.jpg"];
				NSString* njf = [NSString stringWithFormat:@"%@/%@-SD.jpg", [[self filename] stringByDeletingLastPathComponent], [self property:@"Name"]];
				if([[NSFileManager defaultManager] fileExistsAtPath:ojf])
					[[NSFileManager defaultManager] moveItemAtPath:ojf toPath:njf error:&error];
				_filename = to;
				return true;
			}
			else {
				NSLog(@"ERROR*** %@", [error description]);
			}
		}
	}
	return false;
}

-(bool) mergeData:(POPMp4FileTag*)data {
	if([data filename] != @"")
		_filename = [data filename];
	
	_coverArtPieces = [data coverArtPieces];
	[self setImage:[data image]];
	_dbID = [data dbID];
	for(int i = 0; i < [[_properties allKeys] count]; i++) {
		NSString *prop = [[_properties allKeys] objectAtIndex:i];
		if(![doNotMerge containsObject:prop])
		{
			[self setProperty:prop value:[data property:[[_properties allKeys] objectAtIndex:i]]];
		}
	}
	return true;
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return (int)[[_properties allKeys] count] + 1;
}

- (id)tableView:(NSTableView*)aTableView 
objectValueForTableColumn:(NSTableColumn*)aTableColumn 
			row:(NSInteger)rowIndex
{
	if(rowIndex < [[_properties allKeys] count])
	{
		if([[[aTableColumn headerCell] stringValue] compare:@"Tag"] == 0)
		{
			return [keysOrder objectAtIndex:rowIndex];
		}
		else {
			return [[_properties valueForKey:[keysOrder objectAtIndex:rowIndex]] valueForKey:@"value"];
		}
	}
	if([[[aTableColumn headerCell] stringValue] compare:@"Tag"] == 0)
	{
		return @"Filename";
	}
	else {
		return [self filename];
	}
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(NSInteger)rowIndex
{
	if(rowIndex < [[_properties allKeys] count])
	{
		if([[[aTableColumn headerCell] stringValue] compare:@"Tag"] != 0)
		{
			//[[_properties valueForKey:[keysOrder objectAtIndex:rowIndex]] setValue:anObject forKey:@"value"];
			[self setProperty:[keysOrder objectAtIndex:rowIndex] value:anObject];
		}
	}
	else {
		_filename = anObject;
	}
}
@end
