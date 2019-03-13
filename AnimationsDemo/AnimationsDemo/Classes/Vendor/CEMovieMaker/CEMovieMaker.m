//
//  CEMovieMaker.m
//  CEMovieMaker
//
//  Created by Cameron Ehrlich on 9/17/14.
//  Copyright (c) 2014 Cameron Ehrlich. All rights reserved.
//

#import "CEMovieMaker.h"

typedef UIImage*(^CEMovieMakerUIImageExtractor)(NSObject* inputObject);

@implementation CEMovieMaker

- (instancetype)initWithSettings:(NSDictionary *)videoSettings;
{
    self = [self init];
    if (self) {
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths firstObject];
        NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/export.mov"];
        
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
            if (error) {
                NSLog(@"Error: %@", error.debugDescription);
            }
        }
        
        _fileURL = [NSURL fileURLWithPath:tempPath];
        _assetWriter = [[AVAssetWriter alloc] initWithURL:self.fileURL
                                                 fileType:AVFileTypeQuickTimeMovie error:&error];
        if (error) {
            NSLog(@"Error: %@", error.debugDescription);
        }
        NSParameterAssert(self.assetWriter);
        
        _videoSettings = videoSettings;
        _writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                          outputSettings:videoSettings];
        NSParameterAssert(self.writerInput);
        NSParameterAssert([self.assetWriter canAddInput:self.writerInput]);
        
        [self.assetWriter addInput:self.writerInput];
        
        NSDictionary *bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
        
        _bufferAdapter = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:self.writerInput sourcePixelBufferAttributes:bufferAttributes];
        _frameTime = CMTimeMake(1, 10);
    }
    return self;
}

- (void) createMovieFromImageURLs:(NSArray CE_GENERIC_URL*)urls withCompletion:(CEMovieMakerCompletion)completion;
{
    [self createMovieFromSource:urls extractor:^UIImage *(NSObject *inputObject) {
        return [UIImage imageWithData: [NSData dataWithContentsOfURL:((NSURL*)inputObject)]];
    } withCompletion:completion];
}

- (void) createMovieFromImages:(NSArray CE_GENERIC_IMAGE *)images withCompletion:(CEMovieMakerCompletion)completion;
{
    [self createMovieFromSource:images extractor:^UIImage *(NSObject *inputObject) {
        return (UIImage*)inputObject;
    } withCompletion:completion];
}

- (void) createMovieFromSource:(NSArray *)images extractor:(CEMovieMakerUIImageExtractor)extractor withCompletion:(CEMovieMakerCompletion)completion;
{
    self.completionBlock = completion;
    
    [self.assetWriter startWriting];
    [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    
    __block NSInteger i = 0;
    
    NSInteger frameNumber = [images count];
    
    [self.writerInput requestMediaDataWhenReadyOnQueue:mediaInputQueue usingBlock:^{
        while (YES){
            if (i >= frameNumber) {
                break;
            }
            if ([self.writerInput isReadyForMoreMediaData]) {

                CVPixelBufferRef sampleBuffer;
                @autoreleasepool {
                    UIImage* img = extractor([images objectAtIndex:i]);
                    if (img == nil) {
                        i++;
                        NSLog(@"Warning: could not extract one of the frames");
                        continue;
                    }
                    sampleBuffer = [self newPixelBufferFromCGImage:[img CGImage]];
                }
                if (sampleBuffer) {
                    if (i == 0) {
                        [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:kCMTimeZero];
                    }else{
                        CMTime lastTime = CMTimeMake(i-1, self.frameTime.timescale);
                        CMTime presentTime = CMTimeAdd(lastTime, self.frameTime);
                        [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:presentTime];
                    }
                    CFRelease(sampleBuffer);
                    i++;
                }
            }
        }
        
        [self.writerInput markAsFinished];
        [self.assetWriter finishWritingWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
				[self addAudio];
                //self.completionBlock(self.fileURL);
            });
        }];
        
        CVPixelBufferPoolRelease(self.bufferAdapter.pixelBufferPool);
    }];
}

- (void)addAudio
{
	////////////////////////////////////////////////////////////////////////////
	//////////////  OK now add an audio file to move file  /////////////////////
	AVMutableComposition* mixComposition = [AVMutableComposition composition];
	
	NSString *bundleDirectory = [[NSBundle mainBundle] bundlePath];
	// audio input file...
	NSString *audio_inputFilePath = [bundleDirectory stringByAppendingPathComponent:@"test.mp3"];
	NSURL    *audio_inputFileUrl = [NSURL fileURLWithPath:audio_inputFilePath];
	
	// this is the video file that was just written above, full path to file is in --> videoOutputPath
	NSURL    *video_inputFileUrl = _fileURL;//[NSURL fileURLWithPath:videoOutputPath];
	
	// create the final video output file as MOV file - may need to be MP4, but this works so far...
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths firstObject];
	NSString *outputFilePath = [documentsDirectory stringByAppendingPathComponent:@"final_video.mp4"];
	NSURL    *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
		[[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
	
	CMTime nextClipStartTime = kCMTimeZero;
	
	AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
	CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
	
	AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audio_inputFileUrl options:nil];
	CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
	
	CMTimeRange intersectionRange = CMTimeRangeGetIntersection(video_timeRange, audio_timeRange);
	
	AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
	[a_compositionVideoTrack insertTimeRange:intersectionRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:nextClipStartTime error:nil];
	
	AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
	[b_compositionAudioTrack insertTimeRange:intersectionRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:nextClipStartTime error:nil];
	
	AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
	//_assetExport.outputFileType = @"com.apple.quicktime-movie";
	_assetExport.outputFileType = @"public.mpeg-4";
	//NSLog(@"support file types= %@", [_assetExport supportedFileTypes]);
	_assetExport.outputURL = outputFileUrl;
	
	[_assetExport exportAsynchronouslyWithCompletionHandler:
	 ^(void ) {
		 //[self saveVideoToAlbum:outputFilePath];
		 
		 self.completionBlock([NSURL fileURLWithPath:outputFilePath]);
	 }
	 ];
	
	///// THAT IS IT DONE... the final video file will be written here...
	NSLog(@"DONE.....outputFilePath--->%@", outputFilePath);
}


- (CVPixelBufferRef)newPixelBufferFromCGImage:(CGImageRef)image
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    
    CGFloat frameWidth = [[self.videoSettings objectForKey:AVVideoWidthKey] floatValue];
    CGFloat frameHeight = [[self.videoSettings objectForKey:AVVideoHeightKey] floatValue];
    
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 4 * frameWidth,
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0,
                                           0,
                                           CGImageGetWidth(image),
                                           CGImageGetHeight(image)),
                       image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

+ (NSDictionary *)videoSettingsWithCodec:(NSString *)codec withWidth:(CGFloat)width andHeight:(CGFloat)height
{
    
    if ((int)width % 16 != 0 ) {
        NSLog(@"Warning: video settings width must be divisible by 16.");
    }
    
    NSDictionary *videoSettings = @{AVVideoCodecKey : AVVideoCodecH264,
                                    AVVideoWidthKey : [NSNumber numberWithInt:(int)width],
                                    AVVideoHeightKey : [NSNumber numberWithInt:(int)height]};
    
    return videoSettings;
}

@end
