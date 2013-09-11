//
//  AIPlayer.m
//  Boccerball Mini
//
//  Created by Kyle Koser on 3/2/13.
//
//

#import "AIPlayer.h"
#import "AIState.h"
#import "AIStateAttacking.h"
#import "AIStateDefending.h"
#import "AIStateConserving.h"

@implementation AIPlayer

@synthesize game, currentState;

- (id)initWithGame:(HelloWorld *)theGame {
    if (self = [super init]) {
        self.game = theGame;
        self.currentState = [[[AIStateAttacking alloc] init] autorelease];
    }
    return self;
}

- (void)update:(ccTime)dt {
    [currentState execute:self];
}

- (void)changeState:(AIState *)newState {
    self.currentState = newState;
}

//Returns the position of the boccerball in the current game
//If the ball does not exist, returns 0,0
- (CGPoint)getBallPosition {
    
    CCArray *children = [self.game children];
    
    for (CCSprite *sprite in children) {
        if (sprite.tag == 2)
            return sprite.position;
    }
    return CGPointMake(0, 0);
}

- (int)getNumBalls {
    return self.game.p2numBalls;
}

//adds a ball to the game at (pos, 495)
- (void)launchBallAtPosition:(float)pos {
    [self.game addNewBallAtPos:CGPointMake(pos, 495)];
}

- (void)dealloc {
    [super dealloc];
    [currentState release];
    [game release];
}

@end
