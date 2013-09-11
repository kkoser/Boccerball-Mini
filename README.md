Boccerball-Mini
===============

An iOS game based off of "Boccerball" implemented in Cocos2d

This is an old project of mine that I decided to open source. It contains good examples of cocos2d/box2d, especially
filtering. It also has basic AI

Note that this project is old -- no ARC, runs on Cocos2d 1. It is also not iphone-5 optimized. 

GAMEPLAY:

The point of the game is to use the marbles to push the boccerball into the other person's goal

Each player gets 8 balls to start. 
You can only shoot up to 2 balls at once. After that, your ability to shoot regenerates on a timer 
(this is to simulate having to reach down and grab balls in the real game)

If a ball falls off the screen on your side, then it gets added to your ball repository, and vice versa. So, if you
are playing one player, balls off the top of the screen go to the computer, and balls off the bottom are yours.
The number of balls you have in your repository is listed in the corner of the screen. 

