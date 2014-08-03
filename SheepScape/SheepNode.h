//
//  SheepNode.h
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
@import SpriteKit;
#import <Foundation/Foundation.h>
#import "Colors.h"
#define SHEEP_WIDTH 10
#define SHEEP_GLOW_WIDTH 5
@interface SheepNode : SKShapeNode
@property (nonatomic, strong) SKEmitterNode * emmiterNode;
- (SheepNode *) create;
-(BOOL)addDirt;

@end
