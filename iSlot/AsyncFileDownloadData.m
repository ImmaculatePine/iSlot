#import "AsyncFileDownloadData.h"

@implementation AsyncFileDownloadData
@synthesize url, localFile, spriteTag;
-(void) dealloc
{
    //CCLOG(@"dealloc %@", self);
    [url release];
    [localFile release];
    [super dealloc];
}
@end