//
//  CustomEmmiterNode.m
//  SheepScape
//
//  Created by KEVIN on 03/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "CustomEmmiterNode.h"

@implementation CustomEmmiterNode

-(void)setPhysicNode:(SKNode *)physicNode
{
    if(physicNode)
        [self addChild:self.physicNode];
    _physicNode = physicNode;
    
}
@end
