//
//  HelloWorldScene.mm
//  Boccerball
//
//  Created by Kyle Koser on 11/12/10.
//  Copyright Dial 2010. All rights reserved.
//


// Import the interfaces
#import "HelloWorldScene.h"
#import "MainMenuScene.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags

// HelloWorld implementation
@implementation HelloWorld

@synthesize p1numBalls, p2numBalls, p1Score, p2Score, gameOver, scoreLabel, p1AvailableBalls, p2AvailableBalls, p1NumBallsLabel, p2NumBallsLabel, countdownLabel1, countdownLabel2, p1NumShots, p2NumShots, pauseScreenUp;

+(id) scene
{
	
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// initialize your instance here
-(id) init
{
	if( (self=[super init])) {
		self.isTouchEnabled = YES;
		
		p1Score = 0;
		p2Score = 0;
		
        // load background image
		CCSprite *bg = [CCSprite spriteWithFile:@"field.png"];
		bg.position = ccp(320/2, 480/2);
		[self addChild:bg];
		
		CGSize winSize = [CCDirector sharedDirector].winSize;
		
		// Create a world
		b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
		bool doSleep = true;
		_world = new b2World(gravity, doSleep);
		
		// Create edges around the entire screen
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0,0);
		_groundBody = _world->CreateBody(&groundBodyDef);
		b2PolygonShape groundBox;
		b2FixtureDef groundBoxDef;
		groundBoxDef.shape = &groundBox;
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
		//_bottomFixture = _groundBody->CreateFixture(&groundBoxDef);
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
		_groundBody->CreateFixture(&groundBoxDef);
		groundBox.SetAsEdge(b2Vec2(0, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, 
																		winSize.height/PTM_RATIO));
		//_groundBody->CreateFixture(&groundBoxDef);
		groundBox.SetAsEdge(b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO), 
							b2Vec2(winSize.width/PTM_RATIO, 0));
		_groundBody->CreateFixture(&groundBoxDef);
		
		
		
		
		// add in the barriers for the boccerball to bounce off
		b2BodyDef barrierBodyDef;
		barrierBodyDef.position.Set(0,0);
		_barrierBody = _world->CreateBody(&barrierBodyDef);
		b2PolygonShape barrierBox;
		b2FixtureDef barrierBoxDef;
		barrierBoxDef.shape = &barrierBox;
		barrierBoxDef.filter.maskBits = 0x0002;
		barrierBoxDef.density = 0.1;
		barrierBoxDef.friction = 0.8;
		barrierBoxDef.restitution = 0.1f;
		barrierBox.SetAsEdge(b2Vec2(0,40/PTM_RATIO), b2Vec2(103/PTM_RATIO, 0));
		_barrierBody->CreateFixture(&barrierBoxDef);
		barrierBox.SetAsEdge(b2Vec2(winSize.width/PTM_RATIO,80/PTM_RATIO), b2Vec2((winSize.width - 103)/PTM_RATIO, 0));
		_barrierBody->CreateFixture(&barrierBoxDef);
		barrierBox.SetAsEdge(b2Vec2(0,(winSize.height - 38)/PTM_RATIO), b2Vec2(101/PTM_RATIO, winSize.height/PTM_RATIO));
		_barrierBody->CreateFixture(&barrierBoxDef);
		barrierBox.SetAsEdge(b2Vec2(winSize.width/PTM_RATIO,(winSize.height - 38)/PTM_RATIO), b2Vec2((winSize.width - 103)/PTM_RATIO, winSize.height/PTM_RATIO));
		_barrierBody->CreateFixture(&barrierBoxDef);
		
		_barrierBody->CreateFixture(&barrierBoxDef);
		
        //setup intial counters
		p1numBalls = 8;
		p2numBalls = 8;
		self.p1AvailableBalls = 2;
		self.p2AvailableBalls = 2;
        
        self.p1NumShots = 0;
        self.p2NumShots = 0;
        
        //Set up the numBalls Labels for each player
        self.p1NumBallsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Balls: %d", self.p1numBalls] fontName:@"Arial" fontSize:20];
        self.p1NumBallsLabel.position = CGPointMake(275, 15);
        [self addChild:self.p1NumBallsLabel];
        
        self.p2NumBallsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Balls: %d", self.p2numBalls] fontName:@"Arial" fontSize:20];
        self.p2NumBallsLabel.position = CGPointMake(45, 465);
        [self.p2NumBallsLabel setRotation:180];
        [self addChild:self.p2NumBallsLabel];
        
        //set up the pause button
        CCMenuItem *pauseButtonMenuItem = [CCMenuItemImage itemFromNormalImage:@"pause1.jpg" selectedImage:@"pause1.jpg" disabledImage:@"pause1.jpg" target:self selector:@selector(pauseButtonPressed)];
        
        CCMenu *pauseButtonMenu = [CCMenu menuWithItems:pauseButtonMenuItem, nil];
        pauseButtonMenuItem.position = CGPointMake(0, 0);
        pauseButtonMenu.position = CGPointMake(18, 18);
        [self addChild:pauseButtonMenu];
        pauseScreenUp = NO;
		
        //Set up the countdown labels
        self.countdownLabel1 = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:25];
        self.countdownLabel1.position = CGPointMake(160, 180);
        self.countdownLabel1.visible = NO;
        [self addChild:self.countdownLabel1];
        
        self.countdownLabel2 = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:25];
        self.countdownLabel2.position = CGPointMake(160, 300);
        self.countdownLabel2.rotation = 180;
        self.countdownLabel2.visible = NO;
        [self addChild:self.countdownLabel2];
        
        //start the countdown
        [self schedule:@selector(countdown) interval:1];
        
        self.gameOver = YES;
        
        
		//this starts the random power-up generator
		//comment this out to turn off power ups
		//[self schedule:@selector(spawnPowerUp) interval:.5];
		
	}
	return self;
}






- (void)spawnPowerUp {
	if ((arc4random() % 1000) == 0) {
		//spawn new powerup
		NSLog(@"power up!");
		CCSprite *ball = [CCSprite spriteWithFile:@"lightningPowerUp.png" rect:CGRectMake(0, 0, 30, 30)];
		//ball.position = ccp(100, 100);
		ball.tag = 3;
		[self addChild:ball]; 
		
		// Create ball body 
		b2BodyDef ballBodyDef;
		ballBodyDef.type = b2_dynamicBody;
		ballBodyDef.position.Set((arc4random() % 320)/PTM_RATIO, (arc4random() % 480)/PTM_RATIO);
		ballBodyDef.userData = ball;
		b2Body * ballBody = _world->CreateBody(&ballBodyDef);
		
		// Create circle shape
		b2CircleShape circle;
		circle.m_radius = 15/PTM_RATIO;
		
		// Create shape definition and add to body
		b2FixtureDef ballShapeDef;
		ballShapeDef.shape = &circle;
		ballShapeDef.density = 1.0f;
		ballShapeDef.friction = 0.3f; 
		ballShapeDef.restitution = 0.9f;
		ballShapeDef.filter.categoryBits = 0x0000;
		ballBody->CreateFixture(&ballShapeDef);
		
		//b2Vec2 force;
		//force = b2Vec2((arc4random() % 8) + 1, (arc4random() % 8) + 1);
		//ballBody->ApplyLinearImpulse(force, ballBodyDef.position);
	}
}

- (void)countdown {
    //display a countdown
    
    if ([self.countdownLabel1.string isEqualToString:@"0"]) {
        //reset it to 3, this is a new countdown
        self.countdownLabel1.string = @"3";
        self.countdownLabel2.string = @"3";
        self.countdownLabel1.visible = YES;
        self.countdownLabel2.visible = YES;
        return;
    }
    else {
        int currentCount = [self.countdownLabel1.string intValue];
        currentCount--;
        //no reset the values to change the labels
        NSString *newcount = [NSString stringWithFormat:@"%d", currentCount];
        self.countdownLabel1.string = newcount;
        self.countdownLabel2.string = newcount;
        
        //if the new count is 0, then we need to hide the countdown
        //this is when we also start the game
        if (currentCount == 0) {
            self.countdownLabel1.visible = NO;
            self.countdownLabel2.visible = NO;
            
            [self unschedule:@selector(countdown)];
            
            [self startGame];
        }
    }
}


- (void)startGame {
    
    //unschedule the event so that it only happens once
    [self unschedule:@selector(startGame)];
	
	if (self.scoreLabel == nil) {
		self.scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"P1: %d  P2: %d", p1Score, p2Score] fontName:@"Arial" fontSize:20];
		self.scoreLabel.position = ccp((320/2), 300);
		[self addChild:self.scoreLabel];
	}
	
	self.scoreLabel.visible = NO;
	
	self.gameOver = YES;
	
	
	// Create sprite and add it to the layer
	CCSprite *ball = [CCSprite spriteWithFile:@"BoccerBall.png"];
	ball.position = ccp(160, 480/2);
	ball.tag = 2;
	[self addChild:ball]; 
	
	// Create ball body 
	b2BodyDef ballBodyDef;
	ballBodyDef.type = b2_dynamicBody;
	ballBodyDef.position.Set((320/2)/PTM_RATIO, (480/2)/PTM_RATIO);
	ballBodyDef.userData = ball;
	
	b2Body * ballBody = _world->CreateBody(&ballBodyDef);
	
	// Create circle shape
	b2CircleShape circle;
	circle.m_radius = 43/PTM_RATIO;
	
	// Create shape definition and add to body
	b2FixtureDef ballShapeDef;
	ballShapeDef.shape = &circle;
	ballShapeDef.density = 0.75f;
	ballShapeDef.friction = 0.5f; 
	ballShapeDef.restitution = 0.95f;
	ballShapeDef.filter.categoryBits = 0x0002;
	
	_ballFixture = ballBody->CreateFixture(&ballShapeDef);
	
	// Give shape initial impulse...
	//b2Vec2 force = b2Vec2(10, 10);
	//ballBody->ApplyLinearImpulse(force, ballBodyDef.position);
	
	
	[self schedule:@selector(tick:)];
	
	
	self.gameOver = NO;
	
	
}

- (void)endGame {
    NSLog(@"P1 shots: %d", self.p1NumShots);
    NSLog(@"P2 shots: %d", self.p2NumShots);
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuScene scene] withColor:ccWHITE]];
}

- (void)pauseButtonPressed {
    //if the pause screen is already up, we dont want to make a second one
    if (pauseScreenUp) {
        [self resume];
        return;
    }
    
    self.pauseScreenUp = YES;
    
    //[[CCDirector sharedDirector] pause];
    //[self deactivateTimers];
    [self pauseSchedulerAndActions];
    
    //pop up a grey screen over game to indicate its paused
    CGSize s = [[CCDirector sharedDirector] winSize];
    CCLayer *pauseLayer = [CCLayerColor layerWithColor:ccc4(150, 150, 150, 125) width:s.width height:s.height];
    //give it tag 10 so it can be easily removed without requiring a reference in the resume method
    pauseLayer.tag = 10;
    [self addChild:pauseLayer];
    
    CCMenuItemFont *resumeButton = [CCMenuItemFont itemFromString:@"Resume" target:self selector:@selector(resume)];
    CCMenuItemFont *quitButton = [CCMenuItemFont itemFromString:@"Quit to Main Menu" target:self selector:@selector(endGame)];
    
    CCMenu *pauseMenu = [CCMenu menuWithItems:resumeButton, quitButton, nil];
    pauseMenu.position = CGPointMake(160, 240);
    [pauseMenu alignItemsVerticallyWithPadding:80];
    [pauseLayer addChild:pauseMenu];
    
}

- (void)resume {
    if (!self.pauseScreenUp) {
        return;
    }
    
    //remove the pause screen
    [self removeChildByTag:10 cleanup:YES];
    [self resumeSchedulerAndActions];
    self.pauseScreenUp = NO;
    
}

- (void)addP1AvailableBalls {
	self.p1AvailableBalls++;
	NSLog(@"p1 aVailable: %d balls", p1AvailableBalls);
	[self unschedule:@selector(addP1AvailableBalls)];
}

- (void)addP2AvailableBalls {
	self.p2AvailableBalls++;
	[self unschedule:@selector(addP2AvailableBalls)];
}

//override the setters for p1 and p2numBalls so that the label will update

- (void)setP1numBalls:(int)balls {
    p1numBalls = balls;
    [self.p1NumBallsLabel setString:[NSString stringWithFormat:@"Balls: %d", p1numBalls]];
}

- (void)setP2numBalls:(int)balls {
    p2numBalls = balls;
    [self.p2NumBallsLabel setString:[NSString stringWithFormat:@"Balls: %d", p2numBalls]];
}


- (void)tick:(ccTime) dt {
    _world->Step(dt, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {    
        if (b->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *)b->GetUserData();                        
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
								  b->GetPosition().y * PTM_RATIO);
			
			sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
			
			//NSLog(@"%f", sprite.tag);
			
			switch (sprite.tag) {
				case 0:
					break;
				case 1:
					if (sprite.position.y > 550) {
						NSLog(@"Sprite removed from Top");
						_world->DestroyBody(b);
						[self removeChild:sprite cleanup:YES];
						self.p1numBalls++;
					}
					else if (sprite.position.y < -100) {
						NSLog(@"Sprite removed from Bottom");
						_world->DestroyBody(b);
						[self removeChild:sprite cleanup:YES];
						self.p2numBalls++;
					}
					break;
				case 2:
					if (sprite.position.y > 550) {
						NSLog(@"P1Wins");
						self.p1Score++;
						_world->DestroyBody(b);
						[self removeChild:sprite cleanup:YES];
						//CCLabel *label = [CCLabel labelWithString:[NSString stringWithFormat:@"P1: %d  P2: %d", p1Score, p2Score] fontName:@"Arial" fontSize:20];
						//label.position = ccp((320/2), 300);
						//[self addChild:label];
						[self.scoreLabel setString:[NSString stringWithFormat:@"P1: %d  P2: %d", p1Score, p2Score]];
						self.scoreLabel.visible = YES;
						//[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(startGame) userInfo:nil repeats:NO];
                        [self schedule:@selector(startGame) interval:2.5];
					}
					else if (sprite.position.y < -100) {
						NSLog(@"P2Wins");
						self.p2Score++;
						_world->DestroyBody(b);
						[self removeChild:sprite cleanup:YES];
						//CCLabel *label = [CCLabel labelWithString:[NSString stringWithFormat:@"P1: %d  P2: %d", p1Score, p2Score] fontName:@"Arial" fontSize:20];
						//label.position = ccp((320/2), 200);
						//[self addChild:label];
						[self.scoreLabel setString:[NSString stringWithFormat:@"P1: %d  P2: %d", p1Score, p2Score]];
						self.scoreLabel.visible = YES;
						//[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(startGame) userInfo:nil repeats:NO];
                        [self schedule:@selector(startGame) interval:2.5];
					}
					
                    if (p1Score >=3 || p2Score>=3) {
                        //game is over
                        CCLabelTTF *gameOverLabel = [CCLabelTTF labelWithString:@"Game Over!" fontName:@"Arial" fontSize:24];
                        [gameOverLabel setPosition:CGPointMake(160, 180)];
                        [self addChild:gameOverLabel];
                        
                        //transition back to main menu
                        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(endGame) userInfo:nil repeats:NO];
                    }
					break;
					
				case 3:
					//this is the first power-up -- lightning;
					break;

					
				default:
					break;
			}
		}
		
	}
}



- (void)addNewBallAtPos:(CGPoint)position {
	
	if (position.y < 240 && self.p1numBalls >0 && p1AvailableBalls > 0) {
		// Create sprite and add it to the layer
		CCSprite *ball = [CCSprite spriteWithFile:@"ball.png" rect:CGRectMake(0, 0, 22, 22)];
		ball.position = ccp(100, 100);
		ball.tag = 1;
		[self addChild:ball]; 
		
		// Create ball body 
		b2BodyDef ballBodyDef;
		ballBodyDef.type = b2_dynamicBody;
		ballBodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
		ballBodyDef.userData = ball;
		b2Body * ballBody = _world->CreateBody(&ballBodyDef);
		
		// Create circle shape
		b2CircleShape circle;
		circle.m_radius = 11.5/PTM_RATIO;
		
		// Create shape definition and add to body
		b2FixtureDef ballShapeDef;
		ballShapeDef.shape = &circle;
		ballShapeDef.density = 1.0f;
		ballShapeDef.friction = 0.3f; // We don't want the ball to have friction!
		ballShapeDef.restitution = 0.9f;
		ballShapeDef.filter.categoryBits = 0x0004;
		ballBody->CreateFixture(&ballShapeDef);
		
		b2Vec2 force;
		// Give ball initial impulse...
		if (position.y < 640) {
			force = b2Vec2(0, 7);
		}
		ballBody->ApplyLinearImpulse(force, ballBodyDef.position);
		self.p1numBalls--;
		NSLog(@"%d", p1AvailableBalls);
		self.p1AvailableBalls--;
		//[self schedule:@selector(addP1AvailableBalls) interval:.5];
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(addP1AvailableBalls) userInfo:nil repeats:NO];
        
        //Record for statistics
        self.p1NumShots++;
		
		
	}
	if (position.y > 240 && self.p2numBalls > 0 && p2AvailableBalls > 0) {
		CCSprite *ball = [CCSprite spriteWithFile:@"ball.png" rect:CGRectMake(0, 0, 22, 22)];
		ball.position = ccp(100, 100);
		ball.tag = 1;
		[self addChild:ball]; 
		
		// Create ball body 
		b2BodyDef ballBodyDef;
		ballBodyDef.type = b2_dynamicBody;
		ballBodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
		ballBodyDef.userData = ball;
		b2Body * ballBody = _world->CreateBody(&ballBodyDef);
		
		// Create circle shape
		b2CircleShape circle;
		circle.m_radius = 11.5/PTM_RATIO;
		
		
		// Create shape definition and add to body
		b2FixtureDef ballShapeDef;
		ballShapeDef.shape = &circle;
		ballShapeDef.density = 1.0f;
		ballShapeDef.friction = 0.3f; 
		ballShapeDef.restitution = 0.9f;
		ballShapeDef.filter.categoryBits = 0x0004;
		ballBody->CreateFixture(&ballShapeDef);
		
		
		b2Vec2 force = b2Vec2(0, -7);
		
		ballBody->ApplyLinearImpulse(force, ballBodyDef.position);
		
		self.p2numBalls--;
		self.p2AvailableBalls--;
		//[self schedule:@selector(addP2AvailableBalls) interval:.5];
		[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(addP2AvailableBalls) userInfo:nil repeats:NO];
        
        //Record for statistics
        self.p2NumShots++;
	}
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (!self.gameOver && !pauseScreenUp) {
		UITouch *myTouch = [touches anyObject];
		CGPoint location = [myTouch locationInView:[myTouch view]];
		location = [[CCDirector sharedDirector] convertToGL:location];
		//b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
		NSLog(@"TOUCH");
		NSLog(@"%f", location.x);
		
		if (location.y > (480/2)) {
			location.y = (475);
		}
		else {
			location.y = 5;
		}
		
		
		[self addNewBallAtPos:location];
	}
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)InterfaceOrientation {
	
	
	return (InterfaceOrientation == UIInterfaceOrientationPortrait);
}




- (void)dealloc {
	
    delete _world;
    _groundBody = NULL;
	_barrierBody = NULL;
	p1numBalls = NULL;
	p2numBalls = NULL;
	p1Score = NULL;
	p2Score = NULL;
	p1AvailableBalls = NULL;
	p2AvailableBalls = NULL;
	[scoreLabel release];
    [p1NumBallsLabel release];
    [p2NumBallsLabel release];
    [countdownLabel1 release];
    [countdownLabel2 release];
    [super dealloc];
	
}@end
