//
//  AIStateAttacking.m
//  Boccerball Mini
//
//  Created by Kyle Koser on 3/2/13.
//
//

#import "AIStateAttacking.h"
#import "AIStateDefending.h"
#import "AIStateConserving.h"

@implementation AIStateAttacking

- (void)execute:(AIPlayer *)player {
    CGPoint ballPos = [player getBallPosition];
    
    //check to see if we need to switch to defensive state
    //if the ball is on our side, within the box of the goal
    if (ballPos.y > 300 && (ballPos.x > 130 && ballPos.x < 280)) {
        [player changeState:[[[AIStateDefending alloc] init] autorelease]];
        return;
    }
    
    //check to see if running low on balls --> conserving state
    if ([player getNumBalls] < 2) {
        [player changeState:[[[AIStateConserving alloc] init] autorelease]];
        return;
    }
    
    //otherwise, act
    if ((arc4random() %16) == 0) {
        //we want to push the ball towards the center (where the goal is), so choot a few points to the side of where the ball is
        if (ballPos.x > 180) {
            [player launchBallAtPosition:(ballPos.x+3+(arc4random()%2))];
        }
        else {
            [player launchBallAtPosition:(ballPos.x-3-(arc4random()%2))];
        }
    }
}

@end
