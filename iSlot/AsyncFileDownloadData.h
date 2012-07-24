@interface AsyncFileDownloadData : NSObject
{
    NSURL* url;
    NSString* localFile;
    int spriteTag;
}
@property (copy) NSURL* url;
@property (copy) NSString* localFile;
@property int spriteTag;
@end
