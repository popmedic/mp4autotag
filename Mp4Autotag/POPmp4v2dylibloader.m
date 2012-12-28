//
//  POPmp4v2dylibloader.m
//  Mp4Autotag
//
//  Created by Kevin Scardina on 12/28/12.
//
//

#import "POPmp4v2dylibloader.h"
#include <dlfcn.h>
@implementation POPmp4v2dylibloader
+(void)loadMp4v2Lib:(NSString*)path
{
	void* mp4v2_lib_handle = dlopen([path cStringUsingEncoding:NSUTF8StringEncoding], RTLD_LOCAL|RTLD_LAZY);
	if(!mp4v2_lib_handle)
	{
		@throw [NSException exceptionWithName:@"FileNotFoundException"
									   reason:[NSString stringWithFormat:@"Unable to load %@", path]
									 userInfo:nil];
	}
	_MP4Modify = dlsym(mp4v2_lib_handle, "MP4Modify");
	_MP4TagsAlloc = dlsym(mp4v2_lib_handle, "MP4TagsAlloc");
	_MP4TagsStore = dlsym(mp4v2_lib_handle, "MP4TagsStore");
	_MP4TagsFetch = dlsym(mp4v2_lib_handle, "MP4TagsFetch");
	_MP4TagsFree = dlsym(mp4v2_lib_handle, "MP4TagsFree");
	_MP4Close = dlsym(mp4v2_lib_handle, "MP4Close");
	if(!_MP4Modify)
	{
		@throw [NSException exceptionWithName:@"FileNotFoundException"
									   reason:@"Unable to load function MP4Modify"
									 userInfo:nil];
	}
	if(!_MP4TagsAlloc)
	{
		@throw [NSException exceptionWithName:@"FileNotFoundException"
									   reason:@"Unable to load function MP4TagsAlloc"
									 userInfo:nil];
	}
	if(!_MP4TagsFetch)
	{
		@throw [NSException exceptionWithName:@"FileNotFoundException"
									   reason:@"Unable to load function MP4TagsFetch"
									 userInfo:nil];
	}
	if(!_MP4TagsFree)
	{
		@throw [NSException exceptionWithName:@"FileNotFoundException"
									   reason:@"Unable to load function MP4TagsFree"
									 userInfo:nil];
	}
	if(!_MP4Close)
	{
		@throw [NSException exceptionWithName:@"FileNotFoundException"
									   reason:@"Unable to load function MP4Close"
									 userInfo:nil];
	}
	_MP4TagsSetName              = dlsym(mp4v2_lib_handle, "MP4TagsSetName");
	_MP4TagsSetArtist            = dlsym(mp4v2_lib_handle, "MP4TagsSetArtist");
	_MP4TagsSetAlbumArtist       = dlsym(mp4v2_lib_handle, "MP4TagsSetAlbumArtist");
	_MP4TagsSetAlbum             = dlsym(mp4v2_lib_handle, "MP4TagsSetAlbum");
	_MP4TagsSetGrouping          = dlsym(mp4v2_lib_handle, "MP4TagsSetGrouping");
	_MP4TagsSetComposer          = dlsym(mp4v2_lib_handle, "MP4TagsSetComposer");
	_MP4TagsSetComments          = dlsym(mp4v2_lib_handle, "MP4TagsSetComments");
	_MP4TagsSetGenre             = dlsym(mp4v2_lib_handle, "MP4TagsSetGenre");
	_MP4TagsSetGenreType         = dlsym(mp4v2_lib_handle, "MP4TagsSetGenreType");
	_MP4TagsSetReleaseDate       = dlsym(mp4v2_lib_handle, "MP4TagsSetReleaseDate");
	_MP4TagsSetTrack             = dlsym(mp4v2_lib_handle, "MP4TagsSetTrack");
	_MP4TagsSetDisk              = dlsym(mp4v2_lib_handle, "MP4TagsSetDisk");
	_MP4TagsSetTempo             = dlsym(mp4v2_lib_handle, "MP4TagsSetTempo");
	_MP4TagsSetCompilation       = dlsym(mp4v2_lib_handle, "MP4TagsSetCompilation");
	_MP4TagsSetTVShow            = dlsym(mp4v2_lib_handle, "MP4TagsSetTVShow");
	_MP4TagsSetTVNetwork         = dlsym(mp4v2_lib_handle, "MP4TagsSetTVNetwork");
	_MP4TagsSetTVEpisodeID       = dlsym(mp4v2_lib_handle, "MP4TagsSetTVEpisodeID");
	_MP4TagsSetTVSeason          = dlsym(mp4v2_lib_handle, "MP4TagsSetTVSeason");
	_MP4TagsSetTVEpisode         = dlsym(mp4v2_lib_handle, "MP4TagsSetTVEpisode");
	_MP4TagsSetDescription       = dlsym(mp4v2_lib_handle, "MP4TagsSetDescription");
	_MP4TagsSetLongDescription   = dlsym(mp4v2_lib_handle, "MP4TagsSetLongDescription");
	_MP4TagsSetLyrics            = dlsym(mp4v2_lib_handle, "MP4TagsSetLyrics");
	_MP4TagsSetSortName          = dlsym(mp4v2_lib_handle, "MP4TagsSetSortName");
	_MP4TagsSetSortArtist        = dlsym(mp4v2_lib_handle, "MP4TagsSetSortArtist");
	_MP4TagsSetSortAlbumArtist   = dlsym(mp4v2_lib_handle, "MP4TagsSetSortAlbumArtist");
	_MP4TagsSetSortAlbum         = dlsym(mp4v2_lib_handle, "MP4TagsSetSortAlbum");
	_MP4TagsSetSortComposer      = dlsym(mp4v2_lib_handle, "MP4TagsSetSortComposer");
	_MP4TagsSetSortTVShow        = dlsym(mp4v2_lib_handle, "MP4TagsSetSortTVShow");
	_MP4TagsAddArtwork           = dlsym(mp4v2_lib_handle, "MP4TagsAddArtwork");
	_MP4TagsSetArtwork           = dlsym(mp4v2_lib_handle, "MP4TagsSetArtwork");
	_MP4TagsRemoveArtwork        = dlsym(mp4v2_lib_handle, "MP4TagsRemoveArtwork");
	_MP4TagsSetCopyright         = dlsym(mp4v2_lib_handle, "MP4TagsSetCopyright");
	_MP4TagsSetEncodingTool      = dlsym(mp4v2_lib_handle, "MP4TagsSetEncodingTool");
	_MP4TagsSetEncodedBy         = dlsym(mp4v2_lib_handle, "MP4TagsSetEncodedBy");
	_MP4TagsSetPurchaseDate      = dlsym(mp4v2_lib_handle, "MP4TagsSetPurchaseDate");
	_MP4TagsSetPodcast           = dlsym(mp4v2_lib_handle, "MP4TagsSetPodcast");
	_MP4TagsSetKeywords          = dlsym(mp4v2_lib_handle, "MP4TagsSetKeywords");
	_MP4TagsSetCategory          = dlsym(mp4v2_lib_handle, "MP4TagsSetCategory");
	_MP4TagsSetHDVideo           = dlsym(mp4v2_lib_handle, "MP4TagsSetHDVideo");
	_MP4TagsSetMediaType         = dlsym(mp4v2_lib_handle, "MP4TagsSetMediaType");
	_MP4TagsSetContentRating     = dlsym(mp4v2_lib_handle, "MP4TagsSetContentRating");
	_MP4TagsSetGapless           = dlsym(mp4v2_lib_handle, "MP4TagsSetGapless");
	_MP4TagsSetITunesAccount     = dlsym(mp4v2_lib_handle, "MP4TagsSetITunesAccount");
	_MP4TagsSetITunesAccountType = dlsym(mp4v2_lib_handle, "MP4TagsSetITunesAccountType");
	_MP4TagsSetITunesCountry     = dlsym(mp4v2_lib_handle, "MP4TagsSetITunesCountry");
	_MP4TagsSetContentID         = dlsym(mp4v2_lib_handle, "MP4TagsSetSetContentID");
	_MP4TagsSetArtistID          = dlsym(mp4v2_lib_handle, "MP4TagsSetSetArtistID");
	_MP4TagsSetPlaylistID        = dlsym(mp4v2_lib_handle, "MP4TagsSetSetPlaylistID");
	_MP4TagsSetGenreID           = dlsym(mp4v2_lib_handle, "MP4TagsSetGenreID");
	_MP4TagsSetComposerID        = dlsym(mp4v2_lib_handle, "MP4TagsSetComposerID");
	_MP4TagsSetXID               = dlsym(mp4v2_lib_handle, "MP4TagsSetXID");
}
@end
