//
//  MainMenuScene.h
//  Boccerball Mini
//
//  Created by Kyle Koser on 3/3/13.
//
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "HelloWorldScene.h"
#import "SinglePlayerGame.h"

@interface MainMenuScene : CCLayer

- (void)singlePlayer;
- (void)twoPlayer;

+ (id)scene;

@end
