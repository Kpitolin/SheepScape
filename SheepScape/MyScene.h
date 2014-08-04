//
//  MyScene.h
//  SheepScape
//

//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene
@property BOOL gameRunning;

-(void) pauseGame;
-(void)resumeGame;

@end
