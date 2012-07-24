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

@interface SlotMachineLayer : CCLayer
{
}

@property (strong, nonatomic) SlotMachine *slotMachine;

// returns a CCScene that contains the SlotMachineLayer as the only child
+(CCScene *) scene;

- (void) machineWasLoaded;
@end
