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
@property (nonatomic,strong) SKShapeNode * startPointNode;
@property (nonatomic,strong) SKShapeNode * finalPointNode;



+ (SheepNode *) sheepNode;
- (SKShapeNode *) wallNodeWithScreenWidth: (CGFloat)width andScreenHeigth:(CGFloat)height;
+(SKEmitterNode *)rain;
-(SKShapeNode *) rainAreaFromRainNode:(SKEmitterNode *)rain andHeight:(CGFloat)height;

@end
