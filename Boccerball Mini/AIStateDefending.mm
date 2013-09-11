//
//  AIStateDefending.m
//  Boccerball Mini
//
//  Created by Kyle Koser on 3/2/13.
//
//

#import "AIStateDefending.h"
#import "AIStateAttacking.h"

@implementation AIStateDefending

- (void)execute:(AIPlayer *)player {
    CGPoint ballPos = [player getBallPosition];
    
    //If the ball is no longer close to the goal, switch back to attacking
    if (ballPos.y < 240) {
        [player changeState:[[[AIStateAttacking alloc] init] autorelease]];
    }
    
    //protect by launching directly at the balls current position
    //can launch at the current position because if we're in defensive state, the ball is very close to our side, so it wont move much before it gets hit
    if ((arc4random() % 10) == 0) {
        [player launchBallAtPosition:ballPos.x];
    }
}

@end
