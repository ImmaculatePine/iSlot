//
//  LGNetworkSprite.h
//
//  Created by Israel Roth on 5/12/12.
//  Based on Steffen Iterheim code:
//  http://www.learn-cocos2d.com/2012/02/cocos2d-webcam-viewer-part-2-asynchronous-texture-loading/
//  Copyright 2012 Labgoo LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LGNetworkSprite : CCSprite {
}

- (void) loadFromServerAddress: (NSString*) serverAddr fileName: (NSString *) fileName;
- (void) loadFromURLString: (NSString *) urlString withLocalFileName: (NSString *) fileName;

@end