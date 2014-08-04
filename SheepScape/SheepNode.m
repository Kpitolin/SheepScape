//
//  SheepNode.m
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "SheepNode.h"

@implementation SheepNode
- (SheepNode *) create
{
    SheepNode * node = [[SheepNode alloc]  init];
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, SHEEP_WIDTH, SHEEP_WIDTH)];
    node.path = [path CGPath];
    node.fillColor = [Colors sheepColor];
    node.strokeColor = [Colors sheepColor];
    node.glowWidth = SHEEP_GLOW_WIDTH;

    return node;
}
-(void) resetColor
{
    self.fillColor = [Colors sheepColor];
    self.strokeColor = [Colors sheepColor];
    self.emmiterNode.particleColor = [Colors sheepColor];
}
-(SKEmitterNode *)emmiterNode
{
    if(!_emmiterNode)
    {
        SKEmitterNode * emmiterNode = [[SKEmitterNode alloc ] init];
        NSString * particulePath = [[NSBundle mainBundle] pathForResource:@"Cloudy" ofType:@"sks"];
        emmiterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:particulePath];
        emmiterNode.position = CGPointMake(0, 0);
        emmiterNode.particleColor = [SKColor whiteColor];
        emmiterNode.particleColorSequence = nil;

        _emmiterNode = emmiterNode;
    }
    
    return _emmiterNode;

}

-(BOOL)addDirt

{
    BOOL dirty = NO;
    
        self.fillColor = [Colors darkerColorForColor:self.fillColor];
        self.strokeColor = [Colors darkerColorForColor:self.strokeColor];
        self.emmiterNode.particleColor = [Colors darkerColorForColor:self.emmiterNode.particleColor];
    
        if([Colors isDark:self.fillColor ] || [Colors isDark:self.emmiterNode.particleColor ] || [Colors isDark:self.strokeColor ])
        {
            dirty = YES;
        }
    
    
    return dirty;
  
}
-(void)cleanSheep
{
    self.fillColor = [Colors brighterColorForColor:self.fillColor];
    self.strokeColor = [Colors brighterColorForColor:self.strokeColor];
    self.emmiterNode.particleColor = [Colors brighterColorForColor:self.emmiterNode.particleColor];
    
}

@end
