//
//  MainMenuScene.m
//  Boccerball Mini
//
//  Created by Kyle Koser on 3/3/13.
//
//

#import "MainMenuScene.h"

@implementation MainMenuScene

+(id) scene
{
	
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuScene *layer = [MainMenuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init {
    if (self = [super init]) {
        
        self.isTouchEnabled = YES;
        
        // load background image
		CCSprite *bg = [CCSprite spriteWithFile:@"field.png"];
		bg.position = ccp(320/2, 480/2);
		[self addChild:bg];
        
        CCMenuItemFont *singlePlayerButton = [CCMenuItemFont itemFromString:@"Single Player" target:self selector:@selector(singlePlayer)];
        CCMenuItemFont *twoPlayerButton = [CCMenuItemFont itemFromString:@"Two Player" target:self selector:@selector(twoPlayer)];
        
        CCMenu *menu = [CCMenu menuWithItems:singlePlayerButton, twoPlayerButton, nil];
        [menu setPosition:CGPointMake(160, 240)];
        [menu alignItemsVerticallyWithPadding:80];
        
        [self addChild:menu];
    }
    return self;
}

- (void)singlePlayer {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[SinglePlayerGame scene] withColor:ccWHITE]];
}

- (void)twoPlayer {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorld scene] withColor:ccWHITE]];
}

- (void)dealloc {
    [super dealloc];
}

@end
