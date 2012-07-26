//
//  ResultLayer.m
//  iSlot
//
//  Created by Александр Боровых on 25.07.12.
//
//

#import "ResultLayer.h"
#import "SlotMachineLayer.h"

@implementation ResultLayer

@synthesize slotMachineLayer;
@synthesize resultLabel = _resultLabel;

// Initialization
- (ResultLayer *)initWithLayer:(SlotMachineLayer *)newLayer
{
    if ((self = [super initWithColor:ccc4(0, 0, 0, 150)]))
    {
        // Enable touches
        self.isTouchEnabled = YES;
        
        // Set parent layer
        slotMachineLayer = newLayer;
        
        // Set the size of layer to fullscreen
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        // Add label with text "Touch to roll"
        CCLabelTTF *touchToRollLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:32];        
        touchToRollLabel.color = ccc3(0,0,0);
        touchToRollLabel.position = ccp(winSize.width/2, winSize.height/2);
        touchToRollLabel.string = @"Touch to roll";
        [self addChild:touchToRollLabel];
    }
    return self;
}

- (void) dealloc
{
    [_resultLabel release];
    _resultLabel = nil;
    [super dealloc];
}

// Touch handler
- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Roll it!
    [slotMachineLayer roll];
    
    // Close this layer
    [slotMachineLayer removeChild:self cleanup:YES];
}

@end

