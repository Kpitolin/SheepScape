//
//  MyScene.h
//  SheepScape
//

//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "GameLevel.h"


@interface MyScene : SKScene
@property BOOL gameRunning;

-(id)initWithSize:(CGSize)size andGameLevel:(GameLevel*) game;
-(void) pauseGame;
-(void)resumeGame;

@end


