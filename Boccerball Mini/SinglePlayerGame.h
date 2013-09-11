//
//  SinglePlayerGame.h
//  Boccerball Mini
//
//  Created by Kyle Koser on 3/2/13.
//
//

#import "HelloWorldScene.h"
#import "AIPlayer.h"

@interface SinglePlayerGame : HelloWorld {
    AIPlayer *compPlayer;
}

@property (nonatomic, retain) AIPlayer *compPlayer;

@end
