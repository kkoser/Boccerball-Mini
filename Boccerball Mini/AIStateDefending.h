//
//  AIStateDefending.h
//  Boccerball Mini
//
//  Created by Kyle Koser on 3/2/13.
//
//This state represents when the AI is close to losing the point -- i.e. the ball is close to the goal. This results in the AI launching as many balls as possible to knock it away.
//Note: it takes into account both x and y position, so if the ball is close to the end of the field but not not heading towards the goal, this state will NOT be entered

#import "AIState.h"

@interface AIStateDefending : AIState

@end
