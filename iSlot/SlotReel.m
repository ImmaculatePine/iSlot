//
//  SlotReel.m
//  iSlot
//
//  Created by Александр Боровых on 26.07.12.
//
//

#import "SlotReel.h"
#import "SlotIcon.h"
#import "SlotMachine.h"
#import "SlotMachineLayer.h"

@implementation SlotReel

@synthesize slotMachine, icons, isRolling;

// Initialize
- (SlotReel *) initWithMachine:(SlotMachine *)newSlotMachine
{
    self = [super init];
    
    slotMachine = newSlotMachine;
    icons = [[NSMutableArray alloc] init];
    isRolling = NO;
    
    return self;
}

- (void) dealloc
{
    // Stop timers
    [[self scheduler] unscheduleSelector:@selector(moveIcons:) forTarget:self];
    [super dealloc];
}

// Roll the reel
- (void) roll
{
    // Note that this reel is rolling now
    isRolling = YES;
    
    // Start timer
    [[self scheduler] scheduleSelector:@selector(moveIcons:) forTarget:self interval:0.03 paused:NO];
}

// Move icons in reel
- (void) moveIcons:(ccTime)dt
{
    NSLog(@"ROLL THE REEL");
    for (SlotIcon *ico in icons)
    {
        
        // If icon moves out of bounds we should move it upwards
        if (ico.position.y == 0 - slotMachine.iconSize/2)
        {
            ico.position = ccp(ico.position.x, slotMachine.slotMachineLayer.winSize.height + ([icons count]-slotMachine.lines_quantity)*slotMachine.iconSize + slotMachine.iconSize/2);
        }
        
        ico.position = ccp(ico.position.x, ico.position.y - 32);
    }
    
    // Unschedule callback
    //[[self scheduler] unscheduleSelector:@selector(moveIcons:) forTarget:self];
}

@end
