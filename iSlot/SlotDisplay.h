//
//  SlotDisplay.h
//  iSlot
//
//  Created by Александр Боровых on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"

@interface SlotDisplay : CCSprite
{
    // Width and height of slot display
    int width, height;
}

// Set size of slot display
- (void)setSize:(CGSize)newSize;
@end
