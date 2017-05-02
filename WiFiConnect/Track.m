/* vim: set ft=objc fenc=utf-8 sw=2 ts=2 et: */
/*
 *  DOUAudioStreamer - A Core Audio based streaming audio player for iOS/Mac:
 *
 *      https://github.com/douban/DOUAudioStreamer
 *
 *  Copyright 2013-2016 Douban Inc.  All rights reserved.
 *
 *  Use and distribution licensed under the BSD license.  See
 *  the LICENSE file for full text.
 *
 *  Authors:
 *      Chongyu Zhu <i@lembacon.com>
 *
 */

#import "Track.h"

@implementation Track

@end

@implementation Track (Provider)

+ (NSArray *)musicLibraryTracks
{
    NSMutableArray *allTracks = [NSMutableArray array];
    
    Track *track = [[Track alloc] init];
    track.title = [Track localWithStr:@"LOC_Music_MusicConnoisseurship"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"12309111.mp3"
                                                     ofType:nil];
    track.audioFileURL = [NSURL fileURLWithPath:path];
    [allTracks addObject:track];
    
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDir error:nil];
    NSArray *onlyMusic = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.mp3'"]];
    
    for (NSString *contentStr in onlyMusic) {
        Track *track = [[Track alloc] init];
        track.title = [contentStr substringToIndex:contentStr.length - 4];
        NSString *path = [documentsDir stringByAppendingPathComponent:contentStr];
        track.audioFileURL = [NSURL fileURLWithPath:path];
        [allTracks addObject:track];
    }
    
    return allTracks;
}

+ (NSString *)localWithStr:(NSString *)str
{
    return NSLocalizedStringFromTable(str, @"MusicLocalizable", nil);
}

@end




