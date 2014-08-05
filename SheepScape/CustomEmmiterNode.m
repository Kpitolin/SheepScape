//
//  CustomEmmiterNode.m
//  SheepScape
//
//  Created by KEVIN on 03/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "CustomEmmiterNode.h"

@implementation CustomEmmiterNode

-(void)setPhysicEmmiterNode:(SKNode *)physicNode
{
    if(physicNode){
        [self addChild:self.physicEmmiterNode];

    }
    _physicEmmiterNode = physicNode;
    
}
@end
