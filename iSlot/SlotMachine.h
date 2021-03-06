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

// Slot machine layer that renders all the graphics
@property (strong, nonatomic) SlotMachineLayer *slotMachineLayer;

// Name of current slot machine
@property (strong, nonatomic) NSString *name;

// Array of current machine's reels
@property (strong, nonatomic) NSMutableArray *reels;

// Quantity of lines in current machine 
// (or quantity of concurrently visible icons in one reel)
@property (nonatomic) int lines_quantity;

// Icons size depends on lines quantity and window size
@property (nonatomic) int iconSize;

// Array of shifts of each reel
@property (strong, nonatomic) NSMutableArray *shifts;

// Value of win
@property (nonatomic) int win;

// To prevent reading shifts array when we haven't got JSON
// we should check this variable before
@property (nonatomic) BOOL canStop;

// Server address. It will be defined in initializer.
@property (readonly) NSString *server;


// Initialization
- (SlotMachine *) initWithLayer:(SlotMachineLayer *)newLayer name:(NSString *)newName;

// Request data from Rails app in JSON format
- (void) loadMachine;

// Request from server results of rolling
- (void) roll;
@end
