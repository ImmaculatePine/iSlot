//
//  LGNetworkSprite.m
//
//  Created by Israel Roth on 5/12/12.
//  Based on Steffen Iterheim code:
//  http://www.learn-cocos2d.com/2012/02/cocos2d-webcam-viewer-part-2-asynchronous-texture-loading/
//  Copyright 2012 Labgoo LTD. All rights reserved.
//

#import "LGNetworkSprite.h"
#import "AsyncFileDownloadData.h"

@implementation LGNetworkSprite

-(NSString*) cacheDirectory
{
    NSString* cacheDirectory = nil;
    NSArray* pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                             NSUserDomainMask, YES);
    if ([pathArray count] > 0)
    {
        cacheDirectory = [pathArray objectAtIndex:0];
    }
    return cacheDirectory;
}

- (void) loadFromURLString: (NSString *) urlString withLocalFileName: (NSString *) fileName {
    NSString* localFile = [[self cacheDirectory] stringByAppendingPathComponent:fileName];
    AsyncFileDownloadData* afd = [[[AsyncFileDownloadData alloc] init] autorelease];
    afd.url = [NSURL URLWithString:urlString];
    afd.localFile = localFile;
    [self performSelectorInBackground:@selector(downloadFileFromServerInBackground:) withObject:afd];
}

-(void) logError:(NSError*)error {
    if (error) {
        CCLOG(@"%@: %@", error, [error localizedDescription]);
    }
}

-(void) downloadFileFromServerInBackground:(AsyncFileDownloadData*)afd
{
    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfURL:afd.url options:NSDataReadingMappedIfSafe error:&error];
    [self logError:error];
    
    [data writeToFile:afd.localFile options:NSDataWritingAtomic error:&error];
    [self logError:error];
    
    // wait until done in this case means that the background thread waits for completion of the task
    // manipulating or creating sprites must be done on the main thread
    [self performSelectorOnMainThread:@selector(updateTexturesWithAsyncData:) withObject:afd waitUntilDone:NO];
}

-(void) updateTexturesWithAsyncData:(AsyncFileDownloadData*)afd
{
    [self updateTexturesFromFile:afd.localFile];
}

-(void) updateTexturesFromFile:(NSString*)file
{
    CCTextureCache* texCache = [CCTextureCache sharedTextureCache];
    [texCache addImageAsync:file 
                     target:self
                   selector:@selector(asyncTextureLoadDidFinish:)];
}

-(void) asyncTextureLoadDidFinish:(CCTexture2D*)texture
{
    CCTextureCache* texCache = [CCTextureCache sharedTextureCache];
    [texCache removeTexture:self.texture];
    CGSize prevSize = [self contentSize];
    self.texture = texture;
    CGSize size = [texture contentSize];
    [self setTextureRect:CGRectMake(0.0f, 0.0f, size.width,size.height)];
    [self setScale:prevSize.width / size.width];
}

@end