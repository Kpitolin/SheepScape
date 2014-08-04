//
//  CustomEmmiterNode.m
//  SheepScape
//
//  Created by KEVIN on 03/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "CustomEmmiterNode.h"

@implementation CustomEmmiterNode
- (id)init
{
    self = [super init];
    if (self) {
        
        [self addChild:self.physicNode];
    }
    return self;
}

@end
