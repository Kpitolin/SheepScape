//
//  Spawner.h
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SheepNode.h"

@import SpriteKit;
@interface Spawner : NSObject

+ (SheepNode *) sheepNode;
+ (SKShapeNode *) wallNodeWithScreenWidth: (CGFloat)width andScreenHeigth:(CGFloat)height;
@end
