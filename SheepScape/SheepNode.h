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
#import "AppConst.h"
@interface SheepNode : SKShapeNode
@property (nonatomic, strong) SKEmitterNode * emmiterNode;
- (SheepNode *) create;
-(BOOL)addDirt;
-(void)cleanSheep;
-(void)resetColor;
@end
