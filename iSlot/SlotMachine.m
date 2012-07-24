//
//  SlotMachine.m
//  iSlot
//
//  Created by Александр Боровых on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "SlotMachine.h"
#import "SlotMachineLayer.h"

@implementation SlotMachine
@synthesize slotMachineLayer, reels, name, lines_quantity, iconSize;

- (SlotMachine *) initWithLayer:(SlotMachineLayer *)newLayer
{
    self = [super init];
    slotMachineLayer = newLayer;
    return self;
}

// Request data from Rails app in JSON format
- (void) loadMachine
{
    NSString *server = @"http://blooming-warrior-6049.herokuapp.com";
    NSString *loadPath = [NSString stringWithFormat:@"%@%@", server, @"/machines/load"];
    NSURL *loadURL = [NSURL URLWithString: loadPath];
    
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:loadURL];
        [self performSelectorOnMainThread:@selector(machineWasLoaded:) withObject:data waitUntilDone:YES];
    });
}

// This method is called when we get JSON data from server
// with description of new slot machine 
// (such as reels icons and count of lines).
- (void)machineWasLoaded:(NSData *)responseData
{
    // Parse out JSON data
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    // Get array of reels from JSON
    reels = [json objectForKey:@"reels"];
    
    // Get lines quantity from JSON
    lines_quantity = [[json objectForKey:@"lines_quantity"] intValue];
    
    // Calculate icon size
    // We will calculate width and height first.
    // But because of the fact that icons are square
    // we will select the minimal value.
    
    // Calculate width
    // We should divide window's width by quantity of reels
    int reels_quantity = [reels count];
    float iconWidth = slotMachineLayer.winSize.width / reels_quantity;
    // We don't stretch icons, so we won't
    // (128 if hardcoded size of images on the server now)
    if (iconWidth > 128) iconWidth = 128;
    
    // Calculate height
    float iconHeight = slotMachineLayer.winSize.height / lines_quantity;
    // The same logic with stretching as was above
    if (iconHeight > 128) iconHeight = 128;
    
    
    // This is stub for testing that JSON works (%
    name = [json objectForKey:@"lines_quantity"];
    
    // Call layer's method to start game
    [slotMachineLayer machineWasLoaded];
}
@end
