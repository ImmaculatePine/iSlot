//
//  ResultLayer.h
//  iSlot
//
//  Created by Александр Боровых on 25.07.12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class SlotMachineLayer;

@interface ResultLayer : CCLayerColor

@property (nonatomic, strong) SlotMachineLayer *slotMachineLayer;

// Initialize and set slot machine layer
- (ResultLayer *) initWithLayer:(SlotMachineLayer *)newLayer;

// Call this method if it is first launching of game
- (void) showFirstTime;

// Call this method to show game results
- (void) showWin:(int)win;
@end