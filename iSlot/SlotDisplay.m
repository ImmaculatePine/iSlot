//
//  SlotDisplay.m
//  iSlot
//
//  Created by Александр Боровых on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SlotDisplay.h"

@implementation SlotDisplay

// Override this method to clip child sprites
- (void) visit
{
    if (!self.visible) {
        return;
    }
    
    glEnable(GL_SCISSOR_TEST);
    // Set coordinates and size of visible area
    // They look wierd because OpenGL starts axes in right-bottom corner of screen 
    glScissor(self.position.x-width/2, self.position.y-height/2, width, height);
    [super visit];
    glDisable(GL_SCISSOR_TEST);
}

// Set size of slot display
- (void)setSize:(CGSize)newSize
{
    // We have to set content size 
    // because we use it in positioning
    [self setContentSize:newSize];
    
    // Set width and height of slot display
    // This values are calculated in SlotMachineLayer
    // and depend on icon size, lines quantity and reels count
    width = newSize.width;
    height = newSize.height;
}
@end
