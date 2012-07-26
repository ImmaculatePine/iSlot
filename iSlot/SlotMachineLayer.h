//
//  SlotMachineLayer.h
//  iSlot
//
//  Created by Александр Боровых on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "cocos2d.h"

@class SlotMachine;
@class SlotDisplay;

@interface SlotMachineLayer : CCLayerColor
{
}

// The size of device's window
@property (nonatomic) CGSize winSize;
// Slot machine model to work with
@property (strong, nonatomic) SlotMachine *slotMachine;
// Display is a parent sprite for slot icons
// It clips them to show only lines quantity icons in reel concurrently
@property (strong, nonatomic) SlotDisplay *display;

// Returns a CCScene that contains the SlotMachineLayer as the only child
+(CCScene *) scene;
// This metod is called when data from server was recieved 
// and JSON was parsed out
- (void) machineWasLoaded;
// Roll the reels
- (void) roll;
@end
