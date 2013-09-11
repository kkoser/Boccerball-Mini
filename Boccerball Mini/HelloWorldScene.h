//
//  HelloWorldScene.h
//  Boccerball
//
//  Created by Kyle Koser on 11/12/10.
//  Copyright Dial 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
	b2World *_world;
	b2Body *_groundBody;
	b2Fixture *_bottomFixture;
	b2Fixture *_ballFixture;
	b2Body *_barrierBody;
	
	int p1numBalls;
	int p2numBalls;
	
	int p1Score;
	int p2Score;
	int p1AvailableBalls;
	int p2AvailableBalls;
    
    int p1NumShots;
    int p2NumShots;
	
	BOOL gameOver;

	CCLabelTTF *scoreLabel;
    CCLabelTTF *p1NumBallsLabel;
    CCLabelTTF *p2NumBallsLabel;
    
    CCLabelTTF *countdownLabel1;
    CCLabelTTF *countdownLabel2;
    
    BOOL pauseScreenUp;
    
}


@property (nonatomic) int p1numBalls;
@property (nonatomic) int p2numBalls;
@property (nonatomic) int p1AvailableBalls;
@property (nonatomic) int p2AvailableBalls;

@property (nonatomic) int p1Score;
@property (nonatomic) int p2Score;

@property (nonatomic, assign) int p1NumShots;
@property (nonatomic, assign) int p2NumShots;

@property (nonatomic) BOOL gameOver;

@property (nonatomic, retain) CCLabelTTF *scoreLabel;
@property (nonatomic, retain) CCLabelTTF *p1NumBallsLabel;
@property (nonatomic, retain) CCLabelTTF *p2NumBallsLabel;

@property (nonatomic, retain) CCLabelTTF *countdownLabel1;
@property (nonatomic, retain) CCLabelTTF *countdownLabel2;

@property (nonatomic) BOOL pauseScreenUp;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

- (void)addNewBallAtPos:(CGPoint)position;

- (void)addP1AvailableBalls;
- (void)addP2AvailableBalls;

- (void)startGame;
- (void)endGame;



@end
