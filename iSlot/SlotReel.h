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

@property (strong, nonatomic) SlotMachine *slotMachine;

// Array of slot icons
@property (strong, nonatomic) NSMutableArray *icons;

// Use it to check if this reel is animating at current moment
@property (nonatomic) BOOL isRolling;


- (SlotReel *) initWithMachine:(SlotMachine *)newSlotMachine;
- (void) roll;

@end
