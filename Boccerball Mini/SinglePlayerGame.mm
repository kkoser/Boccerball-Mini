//
//  SinglePlayerGame.m
//  Boccerball Mini
//
//  Created by Kyle Koser on 3/2/13.
//
//

#import "SinglePlayerGame.h"

@implementation SinglePlayerGame

@synthesize compPlayer;

+(id) scene {
    
    CCScene *scene = [CCScene node];
    
    SinglePlayerGame *layer = [SinglePlayerGame node];
    
    [scene addChild:layer];
    
    return  scene;
}

- (id)init {
    if (self=[super init]) {
        //load up the computer player
        self.compPlayer = [[[AIPlayer alloc] initWithGame:self] autorelease];
        
        //the game instance will call the update method on the computer player, because that will synchronize it with the frame rate
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)update:(ccTime)dt {
    if (!self.gameOver) {
        [self.compPlayer update:dt];
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (!self.gameOver) {
		UITouch *myTouch = [touches anyObject];
		CGPoint location = [myTouch locationInView:[myTouch view]];
		location = [[CCDirector sharedDirector] convertToGL:location];
        
        //single player, so only launch from bottom
		location.y = 5;
		
		
		[self addNewBallAtPos:location];
	}
	
}

- (void)dealloc {
    [super dealloc];
    [compPlayer release];
}


@end
