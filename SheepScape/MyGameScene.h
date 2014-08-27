//
//  MyScene.h
//  SheepScape
//

//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "Level.h"


@interface MyGameScene : SKScene
@property BOOL gameRunning;
@property (nonatomic, strong)Level * game;
@property (nonatomic ,strong) NSNumber * lateralPosition;
@property (nonatomic ,strong) NSNumber * verticalPosition;
-(id)initWithSize:(CGSize)size andGameLevel:(Level*) game;
-(void) pauseGame;
-(void)resumeGame;

@end


