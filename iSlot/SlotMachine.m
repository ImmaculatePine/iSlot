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
#import "SlotIcon.h"
#import "SlotReel.h"

@implementation SlotMachine
@synthesize slotMachineLayer, reels, shifts, win, canStop, name, lines_quantity, iconSize;
@synthesize server;

// Initialization
- (SlotMachine *) initWithLayer:(SlotMachineLayer *)newLayer
{
    self = [super init];
    
    // Set slot machine layer to work with
    slotMachineLayer = newLayer;
    
    // Initialize reels array
    reels = [[NSMutableArray alloc] init];
    
    // Initialize shifts array
    shifts = [[NSMutableArray alloc] init];
    
    // Define server where our Rails app is running
    server = @"http://blooming-warrior-6049.herokuapp.com";
    
    return self;
}

// Request data from Rails app in JSON format
- (void) loadMachine
{
    // Get URL of JSON to request new slot machine data
    NSString *loadPath = [NSString stringWithFormat:@"%@%@", server, @"/machines/load"];
    NSURL *loadURL = [NSURL URLWithString: loadPath];
    
    // Send request
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
    // We will use it while calculating icon's size
    // and while adding reels to slot machine
    NSArray *jsonReels = [json objectForKey:@"reels"];
    
    // Calculate icon size
    // We will calculate width and height first.
    // But because of the fact that icons are square
    // we will select the minimal value.
    
    // Calculate width
    // We should divide window's width by quantity of reels
    int reels_quantity = [jsonReels count];
    float iconWidth = slotMachineLayer.winSize.width / reels_quantity;
    // We don't stretch icons, so we won't
    // (128 if hardcoded size of images on the server now)
    if (iconWidth > 128) iconWidth = 128;
    
    // Calculate height
    float iconHeight = slotMachineLayer.winSize.height / lines_quantity;
    // The same logic with stretching as was above
    if (iconHeight > 128) iconHeight = 128;
    
    // Find min(iconHeight, iconWidth) to define icon size
    if (iconHeight > iconWidth)
        iconSize = (int) iconWidth;
    else
        iconSize = (int) iconHeight;
    
    
    // Add reels to slot machine.
    // self.reels contains SlotIcons objects
    // with images from server
    
    // Some temporary variables
    SlotReel *newReel;
    SlotIcon *newIcon;
    NSString *imageURL;
    
    // Transform JSON data to NSMutableArray
    for (id reel in jsonReels)
    {
        // Init new reel
        newReel = [[SlotReel alloc] initWithMachine:self];
        
        // and add icons to it
        for (id icon in reel)
        {
            // Create new SlotIcon with temp image from local storage
            newIcon = [SlotIcon spriteWithFile:@"image-loading.png"];
            
            // Define URL of image to download
            imageURL = [NSString stringWithFormat:@"%@/assets/icons/%@", server, [icon objectForKey:@"image"]];
            
            // Load image from this URL
            [newIcon loadFromURLString:imageURL withLocalFileName: [icon objectForKey:@"image"]];            
            
            // Scale the image
            newIcon.scale = (float) iconSize / 128;
            
            // Add slot icon to new reel
            [newReel.icons addObject:newIcon];
        }
        
        // Add new reel to slot machine
        [reels addObject:newReel];
    }
    // Get lines quantity from JSON
    lines_quantity = [[json objectForKey:@"lines_quantity"] intValue];
        
    // Call layer's method to start game
    [slotMachineLayer machineWasLoaded];
}

- (void) roll
{
    // Say to layer that it should animate rolling and can't stop it
    canStop = NO;
    
    // Get URL of JSON to request results of rolling
    NSString *loadPath = [NSString stringWithFormat:@"%@%@", server, @"/machines/press_button"];
    NSURL *loadURL = [NSURL URLWithString: loadPath];
    
    // Send request
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:loadURL];
        [self performSelectorOnMainThread:@selector(rollResultsWereLoaded:) withObject:data waitUntilDone:YES];
    });
}

// This method is called when we get JSON data from server
// with results of rolling the slots
- (void)rollResultsWereLoaded:(NSData *)responseData
{
    // Parse out JSON data
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    // Get array of shifts from JSON
    shifts = [json objectForKey:@"reels"];
    
    // Get win value from JSON
    win = (int) [json objectForKey:@"win"];
    
    // Say to layer that animation can be stopped
    // It doesn't mean that layer will stop animation momentally.
    // It will continue to roll and stop every reel in random moment of time.
    canStop = YES;
}
@end
