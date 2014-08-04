//
//  Game.h
//  SheepScape
//
//  Created by KEVIN on 03/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
@import SpriteKit;
#import "SheepNode.h"
#import <Foundation/Foundation.h>

@interface GameLevel : NSObject
@property (nonatomic,strong) SKShapeNode * startPointNode;
@property (nonatomic,strong) SKShapeNode * finalPointNode;
@property (nonatomic, strong) NSArray * arrayOfPlaygroundObjects;
@property (nonatomic, strong)SheepNode * sheep;



@end
