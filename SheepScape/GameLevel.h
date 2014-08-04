//
//  Game.h
//  SheepScape
//
//  Created by KEVIN on 03/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
@import SpriteKit;

#import "Spawner.h"
#import <Foundation/Foundation.h>
@protocol WinDelegate;

@interface GameLevel : NSObject
@property (nonatomic,strong) SKShapeNode * startPointNode;
@property (nonatomic,strong) SKShapeNode * finalPointNode;
@property (nonatomic, strong) NSArray * arrayOfPlaygroundObjects;
@property (nonatomic, strong) NSArray * matrice;
@property (nonatomic, strong) SheepNode * sheep;
@property (nonatomic, strong) NSNumber * level;
@property (nonatomic, strong) NSNumber * win;
@property (weak,nonatomic) id<WinDelegate> delegate;



- (id)initWithPlistRepresentation:(id)plistRep;
- (void) initPlaygroundWithWidth: (CGFloat)width andHeigth:(CGFloat)height;
- (BOOL) addSupplementaryNode:(SKNode *)node ;



@end
@protocol WinDelegate <NSObject>
- (void)userFinishedLevel:(GameLevel *)sender ;

@end