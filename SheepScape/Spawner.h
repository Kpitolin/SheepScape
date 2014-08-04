//
//  Spawner.h
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SheepNode.h"
#import "CustomEmmiterNode.h"

@import SpriteKit;
@interface Spawner : NSObject

+ (SheepNode *) sheepNode;
+(CustomEmmiterNode *)rainWithHeight:(CGFloat)height;
+(SKShapeNode *) rainAreaFromRainNode:(SKEmitterNode *)rain andHeight:(CGFloat)height;
+(SKShapeNode *)startPointNodeAtPoint:(CGPoint) point;
+(SKShapeNode *)finalPointNodeAtPoint:(CGPoint) point;
+ (NSMutableArray *) createPlaygroundWithWidth: (CGFloat)width andHeigth:(CGFloat)height andMatrice:(NSArray *) matrice;
@end
