//
//  ResultLayer.h
//  iSlot
//
//  Created by Александр Боровых on 25.07.12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ResultLayer : CCLayerColor
{
    CCLabelTTF *_resultLabel;
}

@property (nonatomic, retain) CCLabelTTF *resultLabel;

@end