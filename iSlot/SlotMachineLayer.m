//
//  SlotMachineLayer.m
//  iSlot
//
//  Created by Александр Боровых on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// Import the interfaces
#import "SlotMachineLayer.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

// Import game objects
#import "SlotMachine.h"
#import "SlotIcon.h"

@implementation SlotMachineLayer

@synthesize winSize, slotMachine;

// Helper class method that creates a Scene with the SlotMachineLayer as the only child
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SlotMachineLayer *layer = [SlotMachineLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        // Ask director for the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        winSize = size;
        
        // Create new slot machine object
        slotMachine = [[SlotMachine alloc] initWithLayer:self];
        
        // Ask for loading data from server
        [slotMachine loadMachine];
    }
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void) machineWasLoaded
{
    // Add icons to layer
    // Set initial coordinates to top left corner
    // (by default they are at bottom left corner)
    // We should add/subtract half size of icon because
    // cocos2d sets objects by their centers.
    int iconX = 0 + slotMachine.iconSize/2 , iconY = winSize.height - slotMachine.iconSize/2;
    
    for (id reel in slotMachine.reels)
    {
        for (SlotIcon *icon in reel)
        {
            // Set icon's position and add it to layer
            icon.position = ccp(iconX, iconY);
            [self addChild:icon];
            
            // Decrease Y-coordinate to place next icon below
            iconY -= slotMachine.iconSize;
        }
        
        // Increase X-coordinate to place next reel to the right
        iconX += slotMachine.iconSize;
        // Reset Y-coordinate
        iconY = winSize.height - slotMachine.iconSize/2;
    }
}

@end
