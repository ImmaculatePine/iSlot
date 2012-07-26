//
//  SlotReel.h
//  iSlot
//
//  Created by Александр Боровых on 26.07.12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class SlotMachine;

@interface SlotReel : CCNode

// Slot machine that this reel belongs to
@property (strong, nonatomic) SlotMachine *slotMachine;

// Nubmer of this reel in slot machine
@property (nonatomic) int number;

// Array of slot icons
@property (strong, nonatomic) NSMutableArray *icons;

// Use it to check if this reel is animating at current moment
@property (nonatomic) BOOL isRolling;


- (SlotReel *) initWithMachine:(SlotMachine *)newSlotMachine number:(int)newNumber;
- (void) roll;

@end
