//
//  AIStateConserving.m
//  Boccerball Mini
//
//  Created by Kyle Koser on 3/2/13.
//
//

#import "AIStateConserving.h"
#import "AIStateAttacking.h"
#import "AIStateDefending.h"

@implementation AIStateConserving

- (void)execute:(AIPlayer *)player {
  
    CGPoint ballPos = [player getBallPosition];
    //check to see if we need to switch to defensive state
    //if the ball is on our side, within the box of the goal
    if (ballPos.y > 300 && (ballPos.x > 130 && ballPos.x < 280)) {
        [player changeState:[[[AIStateDefending alloc] init] autorelease]];
        return;
    }
    
    //check to see if we can attack again
    if ([player getNumBalls] >= 4) {
        [player changeState:[[[AIStateAttacking alloc] init] autorelease]];
        return;
    }
}

@end
