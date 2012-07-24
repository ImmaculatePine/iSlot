//
//  SlotMachineLayer.m
//  iSlot
//
//  Created by Александр Боровых on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// Import the interfaces
#import "SlotMachineLayer.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

// Import game objects
#import "SlotIcon.h"

@implementation SlotMachineLayer

// Helper class method that creates a Scene with the SlotMachineLayer as the only child
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SlotMachineLayer *layer = [SlotMachineLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Slot machines will be here" fontName:@"Marker Felt" fontSize:32];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        // Add test icon on screen
        SlotIcon *slotIcon = [SlotIcon spriteWithFile:@"image-loading.png"];
        slotIcon.position = ccp(size.width * 0.75, size.height * 0.6);
        
        // Try to load image from URL now
        [slotIcon 
            loadFromURLString:@"http://blooming-warrior-6049.herokuapp.com/assets/icons/ubuntu.png"
            withLocalFileName:@"ubuntu.png"];
        
        // Add this icon on screen
        [self addChild:slotIcon];
    }
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
