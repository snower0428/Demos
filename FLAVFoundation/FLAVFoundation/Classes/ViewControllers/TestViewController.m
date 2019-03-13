//
//  TestViewController.m
//  FLAVFoundation
//
//  Created by leihui on 17/3/14.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "TestViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AVMetadataItem+THAdditions.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor orangeColor];
	
#if 0
	// iOS iPod 库
	MPMediaPropertyPredicate *artistPredicate = [MPMediaPropertyPredicate predicateWithValue:@"Foo Fighters" forProperty:MPMediaItemPropertyArtist];
	MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue:@"In Your Honor" forProperty:MPMediaItemPropertyAlbumTitle];
	MPMediaPropertyPredicate *songPredicate = [MPMediaPropertyPredicate predicateWithValue:@"Best of You" forProperty:MPMediaItemPropertyTitle];
	
	MPMediaQuery *query = [[MPMediaQuery alloc] init];
	[query addFilterPredicate:artistPredicate];
	[query addFilterPredicate:albumPredicate];
	[query addFilterPredicate:songPredicate];
	
	NSArray *results = [query items];
	if (results.count > 0) {
		MPMediaItem *item = results[0];
		NSURL *assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
		AVAsset *asset = [AVAsset assetWithURL:assetURL];
		NSLog(@"asset:%@", asset);
	}
#endif
	
#if 0
	NSURL *assetURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mov"];
	AVAsset *asset = [AVAsset assetWithURL:assetURL];
	
	NSArray *array = @[@"tracks"];
	[asset loadValuesAsynchronouslyForKeys:array completionHandler:^{
		NSError *error = nil;
		AVKeyValueStatus status = [asset statusOfValueForKey:@"tracks" error:&error];
		switch (status) {
			case AVKeyValueStatusLoading:
				NSLog(@"AVKeyValueStatusLoading");
				break;
			case AVKeyValueStatusLoaded:
				NSLog(@"AVKeyValueStatusLoaded");
				break;
			case AVKeyValueStatusFailed:
				NSLog(@"AVKeyValueStatusFailed");
				break;
			case AVKeyValueStatusCancelled:
				NSLog(@"AVKeyValueStatusCancelled");
				break;
			default:
				break;
		}
	}];
#endif
	
#if 0
	NSURL *url = nil;
	AVAsset *asset = [AVAsset assetWithURL:url];
	NSArray *keys = @[@"availableMetadataFormats"];
	[asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
		NSMutableArray *metadata = [NSMutableArray array];
		// Collect all metadata for the available formats
		for (NSString *format in asset.availableMetadataFormats) {
			[metadata addObjectsFromArray:[asset metadataForFormat:format]];
		}
		// Process AVMetadataItems
	}];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self metadataItemInfo];
}

#pragma mark - Private

- (void)metadataInfo
{
	// 获取一个M4A音频文件的演奏者和唱片的元数据
	NSArray *metadata = nil; // Collection of AVMetadataItems
	
	NSString *keySpace = AVMetadataKeySpaceiTunes;
	NSString *artistKey = AVMetadataiTunesMetadataKeyArtist;
	NSString *albumKey = AVMetadataiTunesMetadataKeyAlbum;
	
	NSArray *artistMetadata = [AVMetadataItem metadataItemsFromArray:metadata withKey:artistKey keySpace:keySpace];
	NSArray *albumMetadata = [AVMetadataItem metadataItemsFromArray:metadata withKey:albumKey keySpace:keySpace];
	
	AVMetadataItem *artistItem;
	AVMetadataItem *albumItem;
	if (artistMetadata.count > 0) {
		artistItem = artistMetadata[0];
	}
	if (albumMetadata.count > 0) {
		albumItem = albumMetadata[0];
	}
}

- (void)metadataItemInfo
{
	NSURL *url = [[NSBundle mainBundle] URLForResource:@"01 Demo AAC" withExtension:@"m4a"];
	AVAsset *asset = [AVAsset assetWithURL:url];
	
	NSArray *metadata = [asset metadataForFormat:AVMetadataFormatiTunesMetadata];
	for (AVMetadataItem *item in metadata) {
		NSLog(@"%@: %@", item.keyString, item.value);
	}
}

@end
