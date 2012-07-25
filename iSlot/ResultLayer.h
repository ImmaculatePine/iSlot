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
{
    CCLabelTTF *_resultLabel;
}

@property (nonatomic, strong) SlotMachineLayer *slotMachineLayer;
@property (nonatomic, retain) CCLabelTTF *resultLabel;

- (ResultLayer *) initWithLayer:(SlotMachineLayer *)newLayer;

@end