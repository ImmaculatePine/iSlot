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
@synthesize slotMachineLayer, reels, name, lines;

- (SlotMachine *) initWithName:(NSString *)newName layer:(SlotMachineLayer *)newLayer
{
    NSString *server = @"http://blooming-warrior-6049.herokuapp.com";
    NSString *loadPath = [NSString stringWithFormat:@"%@%@", server, @"/machines/load"];
    NSURL *loadURL = [NSURL URLWithString: loadPath];
    
    self = [super init];
    
    slotMachineLayer = newLayer;
    name = newName;
    
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:loadURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
    return self;
}

- (void)fetchedData:(NSData *)responseData
{
    // Parse out JSON data
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    //reels = [json objectForKey:@"reels"];
    lines = [[json objectForKey:@"lines_quantity"] intValue];
    name = [json objectForKey:@"lines_quantity"];
    
    [slotMachineLayer machineDidLoad];
}
@end
