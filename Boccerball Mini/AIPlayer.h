//
//  AIPlayer.h
//  Boccerball Mini
//
//  Created by Kyle Koser on 3/2/13.
//
//

#import <Foundation/Foundation.h>
#import "HelloWorldScene.h"

@class AIState;

@interface AIPlayer : NSObject {
    
    HelloWorld *game;
    
    AIState *currentState;
    
}

@property (nonatomic, retain) HelloWorld *game;

@property (nonatomic, retain) AIState *currentState;


- (id)initWithGame:(HelloWorld *)game;

- (void)update:(ccTime)dt;

- (void)changeState:(AIState *)newState;

- (CGPoint)getBallPosition;

- (int)getNumBalls;

- (void)launchBallAtPosition:(float)pos;

@end
