//
//  SlotMachine.h
//  iSlot
//
//  Created by Александр Боровых on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SlotMachineLayer;

@interface SlotMachine : NSObject
{
    
}

@property (strong, nonatomic) SlotMachineLayer *slotMachineLayer;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *reels;
@property (nonatomic) int lines;

- (SlotMachine *) initWithName:(NSString *)newName layer:(SlotMachineLayer *)newLayer;
@end
