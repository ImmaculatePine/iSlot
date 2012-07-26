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

@synthesize slotMachine, number, icons, isRolling;

// Initialize
- (SlotReel *) initWithMachine:(SlotMachine *)newSlotMachine number:(int)newNumber
{
    self = [super init];
    
    slotMachine = newSlotMachine;
    number = newNumber;
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
    [[self scheduler] scheduleSelector:@selector(moveIcons:) forTarget:self interval:0.01 paused:NO];
}

// Move icons in reel
- (void) moveIcons:(ccTime)dt
{
    for (SlotIcon *ico in icons)
    {
        
        // If icon moves out of bounds we should move it upwards
        if (ico.position.y == 0 - slotMachine.iconSize/2)
        {
            ico.position = ccp(ico.position.x, slotMachine.iconSize * [icons count] - slotMachine.iconSize/2);
        }
        
        ico.position = ccp(ico.position.x, ico.position.y - slotMachine.iconSize/4);
    }

    // Check if slot machine can stop it's reels
    if (slotMachine.canStop)
    {
        // Find icon that should be first visible in resulting combination
        int shift = [[slotMachine.shifts objectAtIndex:number] integerValue];
        SlotIcon *iconWithCorrectShift = [icons objectAtIndex:shift];
        
        // Check if it is in correct position (top of the screen)
        if (iconWithCorrectShift.position.y == slotMachine.iconSize * slotMachine.lines_quantity - slotMachine.iconSize/2)
        {
            // We'll stop rolling with N% probability when the reel in correct position
            int stopProbability = 30;
            // Generate random number in range 0..100
            int randomNumber = arc4random_uniform(101);
            
            if (randomNumber < stopProbability)
            {
                // Unschedule callback
                [[self scheduler] unscheduleSelector:@selector(moveIcons:) forTarget:self];

                // Say everyone that this reel doesn't roll anymore
                isRolling = NO;
            }
        }
    }
}

@end
