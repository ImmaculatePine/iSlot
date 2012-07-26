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
#import "SlotReel.h"
#import "SlotDisplay.h"
#import "ResultLayer.h"

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
        slotMachine = [[SlotMachine alloc] initWithLayer:self name:@"simple"];
        
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
    // Init coordinates' variables. We'll calculate them later
    int iconX = 0, iconY = 0;

    // Use this variables to make code shorter
    SlotReel *reel;
    SlotIcon *icon;
    
    for (int i=0; i<[slotMachine.reels count]; i++)
    {
        reel = [slotMachine.reels objectAtIndex:i];
        
        // Calculate X-coordinate to place next reel to the right
        iconX = i * slotMachine.iconSize;
        
        for (int j=0; j<[reel.icons count]; j++)
        {
            icon = [reel.icons objectAtIndex:j];
            
            // Calculate Y-coordinate
            // We also have to move invisible (out of bounds)
            // icons at the top
            if (j < slotMachine.lines_quantity)
            {
                iconY = slotMachine.iconSize * j;
            }
            else
            {
                iconY = slotMachine.iconSize * (j - [reel.icons count]);
            }
            iconY = slotMachine.iconSize * slotMachine.lines_quantity - iconY;
            
            // Position the icon
            // We should add/subtract half size of icon
            // because cocos2d sets objects by their centers.
            icon.position = ccp(iconX + slotMachine.iconSize/2, iconY - slotMachine.iconSize/2);
            
            // Add icon to layer
            [display addChild:icon];
            
            // Decrease Y-coordinate to place next icon below
            iconY -= slotMachine.iconSize;
        }
        

        //iconX += slotMachine.iconSize;
        // Reset Y-coordinate
        iconY = displaySize.height - slotMachine.iconSize/2;
    }
    
    // Show result layer with greetings
    ResultLayer *resultLayer = [[ResultLayer alloc] initWithLayer:self];
    [resultLayer showFirstTime];
    [self addChild: resultLayer];
}

// Roll the reels
- (void) roll
{
    // Roll every reel in slot machine in separate
    for (SlotReel * reel in slotMachine.reels)
    {
        [reel roll];
    }
 
    // Send request to server
    [slotMachine roll];
    
    // Create callback to check if all reels are stopped
    [[self scheduler] scheduleSelector:@selector(checkReelsState:) forTarget:self interval:1.0 paused:NO];
}

// Check if all reels stopeed
- (void) checkReelsState:(ccTime)dt
{
    if ([self reelsStopeed])
    {
        // Unschedule callback
        [[self scheduler] unscheduleSelector:@selector(checkReelsState:) forTarget:self];
        
        // Show result layer with game results
        ResultLayer *resultLayer = [[ResultLayer alloc] initWithLayer:self];
        [resultLayer showWin:slotMachine.win];
        [self addChild: resultLayer];
    }
}

// Returns true if every reel of this slot machine stopped
- (BOOL) reelsStopeed
{
    for (SlotReel *reel in slotMachine.reels)
        if (reel.isRolling) return false;
    
    return true;
}
@end
