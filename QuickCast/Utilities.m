//
//  QuickCast
//
//  Copyright (c) 2013 Pete Nelson, Neil Kinnish, Dom Murphy
//

#import "Utilities.h"
#import <AVFoundation/AVFoundation.h>
#import <IOKit/graphics/IOGraphicsLib.h>
#import "ScreenDetails.h"

@implementation Utilities

+ (NSSize)resize:(NSSize)old withMax:(float)max{

    if(old.width < max && old.height < max)
        return old;
    
    int neww, newh = 0;
    float rw = old.width / max; 
    float rh = old.height / max;
    
    if (rw > rh)
    {
        newh = round(old.height / rw);
        neww = max;
    }
    else
    {
        neww = round(old.width / rh);
        newh = max;
    }
    
    return NSMakeSize(neww, newh);

}

+ (NSString *)minutesSeconds:(int)seconds{
    
    NSNumber *totalDays = [NSNumber numberWithDouble:
                           (seconds / 86400)];
    NSNumber *totalHours = [NSNumber numberWithDouble:
                            ((seconds / 3600) -
                             ([totalDays intValue] * 24))];
    NSNumber *totalMinutes = [NSNumber numberWithDouble:
                              ((seconds / 60) -
                               ([totalDays intValue] * 24 * 60) -
                               ([totalHours intValue] * 60))];
    NSNumber *totalSeconds = [NSNumber numberWithInt:
                              (seconds % 60)];
    
    //NSLog(@"min %@ sec %@",totalMinutes,totalSeconds);
    
    //NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"mm:ss"];
    
    //return [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    return [[NSString stringWithFormat:@"%02d:", totalMinutes.intValue] stringByAppendingString:[NSString stringWithFormat:@"%02d", totalSeconds.intValue]];
    
}

+ (NSImage *) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil] ;
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    NSImage *thumbnailImage = thumbnailImageRef ? [[NSImage alloc] initWithCGImage:thumbnailImageRef size:NSZeroSize] : nil;
    
    return thumbnailImage;
}

+ (NSArray *)getAudioInputs{
    
    NSArray *audioCaptureDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    
    return audioCaptureDevices;
}

+ (NSString *)defaultAudioInputName{
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    return audioDevice.localizedName;
}

+ (NSMutableArray *)getDisplays{
    
    NSMutableArray *displays = [NSMutableArray array];
    
    for(NSScreen *screen in [NSScreen screens]){
        
        [displays addObject:[Utilities getScreenDetails:screen]];
        
    }
    
    return displays;
}

+ (ScreenDetails *)getDisplayByName:(NSString *)name{
    
    for(ScreenDetails *screenDetails in [Utilities getDisplays])
    {
        if([screenDetails.screenName isEqualToString:name])
            return screenDetails;
    }
    
    return nil;
}

+ (ScreenDetails *)getMainDisplayDetails{
    
    for(NSScreen *screen in [NSScreen screens])
    {
        ScreenDetails *sd = [Utilities getScreenDetails:screen];
        if(sd.screenId == CGMainDisplayID()){
            return sd;
        }
    }
    
    return nil;
}

+ (ScreenDetails *)getScreenDetails:(NSScreen *)screen{
    
    NSDictionary *screenDescription = [screen deviceDescription];
    NSNumber *screenId = [screenDescription objectForKey:@"NSScreenNumber"];
    NSString *screenName = @"";
    NSDictionary *deviceInfo = (NSDictionary *)CFBridgingRelease(IODisplayCreateInfoDictionary(CGDisplayIOServicePort(screenId.unsignedIntValue), kIODisplayOnlyPreferredName));
    NSDictionary *localizedNames = [deviceInfo objectForKey:[NSString stringWithUTF8String:kDisplayProductName]];
    
    if ([localizedNames count] > 0) {
        screenName = [localizedNames objectForKey:[[localizedNames allKeys] objectAtIndex:0]];
    }
    
    ScreenDetails *screenDetails = [[ScreenDetails alloc] init];
    screenDetails.screenId = screenId.unsignedIntValue;
    screenDetails.screenName = screenName;
    screenDetails.retina = screen.backingScaleFactor == 2.0;
    screenDetails.screen = screen;
    
    return screenDetails;
}


@end
