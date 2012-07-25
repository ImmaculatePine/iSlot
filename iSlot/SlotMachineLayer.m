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
#import "SlotDisplay.h"

@implementation SlotMachineLayer

@synthesize winSize, slotMachine, display;

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

// On "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super initWithColor:ccc4(255,255,255,255)]) ) {
        
        // Ask director for the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        winSize = size;
        
        // Create display to load slots to
        display = [[SlotDisplay alloc] init];
        
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

// This metod is called when data from server was recieved 
// and JSON was parsed out
- (void) machineWasLoaded
{
    // Set display size
    CGSize displaySize = CGSizeMake(
        (float) [slotMachine.reels count] * slotMachine.iconSize,
        (float) slotMachine.lines_quantity * slotMachine.iconSize);
    [display setSize:displaySize];
    
    // Position display on the center of the screen
    display.position = ccp(winSize.width/2, winSize.height/2);
    
    // Add it to the layer
    [self addChild:display];
    
    // Add icons to layer
    // Set initial coordinates to top left corner
    // (by default they are at bottom left corner)
    // We should add/subtract half size of icon because
    // cocos2d sets objects by their centers.
    int iconX = 0 + slotMachine.iconSize/2, 
        iconY = displaySize.height - slotMachine.iconSize/2;
    for (id reel in slotMachine.reels)
    {
        for (SlotIcon *icon in reel)
        {
            // Set icon's position and add it to layer
            icon.position = ccp(iconX, iconY);
            [display addChild:icon];
            
            // Decrease Y-coordinate to place next icon below
            iconY -= slotMachine.iconSize;
        }
        
        // Increase X-coordinate to place next reel to the right
        iconX += slotMachine.iconSize;
        // Reset Y-coordinate
        iconY = displaySize.height - slotMachine.iconSize/2;
    }
}

@end
