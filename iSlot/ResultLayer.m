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

// Initialize and set slot machine layer
- (ResultLayer *)initWithLayer:(SlotMachineLayer *)newLayer
{
    if ((self = [super initWithColor:ccc4(0, 0, 0, 150)]))
    {
        // Enable touches
        self.isTouchEnabled = YES;
        
        // Set parent layer
        slotMachineLayer = newLayer;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

// Call this method if it is first launching of game
- (void)showFirstTime
{
    // Add label with text "Touch to roll"
    CCLabelTTF *touchToRollLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:32];
    touchToRollLabel.color = ccc3(255,0,0);
    touchToRollLabel.position = ccp(slotMachineLayer.winSize.width/2, slotMachineLayer.winSize.height/2);
    touchToRollLabel.string = @"Touch to roll";
    [self addChild:touchToRollLabel];
}

// Call this method to show game results
- (void)showWin:(int)win
{
    // Make the string to show result
    NSString *winResult;
    if (win > 0)
        winResult = [NSString stringWithFormat:@"You win $%d", win];
    else
        winResult = @"You win nothing. Try again";

    // Create label with this result
    CCLabelTTF *resultLabel = [CCLabelTTF labelWithString:winResult fontName:@"Arial" fontSize:32];
    resultLabel.color = ccc3(255,0,0);
    resultLabel.position = ccp(slotMachineLayer.winSize.width/2, slotMachineLayer.winSize.height/2 + 16);
    [self addChild:resultLabel];
    
    // Create label with text "Touch to roll"
    CCLabelTTF *touchToRollLabel = [CCLabelTTF labelWithString:@"(touch to roll)" fontName:@"Arial" fontSize:24];
    touchToRollLabel.color = ccc3(255,0,0);
    touchToRollLabel.position = ccp(slotMachineLayer.winSize.width/2, slotMachineLayer.winSize.height/2 - 12);
    touchToRollLabel.string = @"(touch to roll)";
    [self addChild:touchToRollLabel];
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

