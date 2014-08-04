//
//  Spawner.m
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import "AppConst.h"
#import "Spawner.h"
#import "Colors.h"


@implementation Spawner

//
//for (NSDictionary *conditionPlist in dic[@"Conditions"]) {
//    KTAchievementCondition *condition = [[KTAchievementCondition alloc] initWithPlistRepresentation:conditionPlist];

+(SKEmitterNode *)rain
{
    SKEmitterNode * emmiterNode = [[SKEmitterNode alloc ] init];
    NSString * particulePath = [[NSBundle mainBundle] pathForResource:@"Rain" ofType:@"sks"];

    emmiterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:particulePath];
    emmiterNode.particleColor = [Colors rainColor];
    emmiterNode.particleColorSequence = nil;

    return emmiterNode;
}
-(SKShapeNode *) rainAreaFromRainNode:(SKEmitterNode *)rain andHeight:(CGFloat)height
{
    SKShapeNode * node = [[SKShapeNode alloc] init];
    CGPoint origin =  rain.position;
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(origin.x, origin.y, rain.particlePositionRange.dx/2, height)];
    node.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:[path CGPath]];
    node.physicsBody.dynamic = NO;
    node.physicsBody.friction = 0.3f;
    node.physicsBody.restitution = 0.0f;
    node.physicsBody.linearDamping = 1.0f;
    node.physicsBody.categoryBitMask = rainAreaCategory;
    node.physicsBody.contactTestBitMask = sheepCategory;

    return node;
}
+ (SheepNode *) sheepNode
{
    SheepNode * node = [[SheepNode alloc] init];
    node = [node create];
    //[node addChild:node.emmiterNode];
    node.emmiterNode.position = CGPointMake(0, 0);
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:SHEEP_WIDTH/2+SHEEP_GLOW_WIDTH center:CGPointMake(SHEEP_WIDTH/2, SHEEP_WIDTH/2)];
    node.physicsBody.dynamic = YES;
    node.physicsBody.categoryBitMask = sheepCategory;
    node.physicsBody.contactTestBitMask = wallCategory;
    node.physicsBody.friction = 0.3f;
    node.physicsBody.restitution = 1.0f;
    node.physicsBody.linearDamping = 0.0f;
    node.physicsBody.allowsRotation = NO;
    return node;
}

CGFloat widthOfRect;
CGFloat heightOfRect;
#define WALL_WIDTH 40
#define WALL_HEIGHT 40
- (SKShapeNode *) wallNodeWithScreenWidth: (CGFloat)width andScreenHeigth:(CGFloat)height
{
    SKShapeNode * node = [[SKShapeNode alloc] init];
    UIBezierPath * pathOfNode = [[UIBezierPath alloc ]init];

    NSMutableArray * arrayOfPaths = [[NSMutableArray alloc ]init];
    NSArray * matrice =  @[
                           @[ @4, @1, @1, @1, @0, @1],
                           @[ @0, @0, @0, @1, @0, @1],
                           @[ @1, @1, @0, @1, @1, @1],
                           @[ @0, @0, @0, @0, @0, @1],
                           @[ @1, @1, @0, @1, @0, @1],
                           @[ @0, @0, @0, @0, @0, @1],
                           @[ @0, @1, @0, @1, @0, @1],
                           @[ @0, @1, @0, @1, @0, @1],
                           @[ @0, @1, @0, @1, @0, @1],
                           @[ @1, @1, @0, @1, @2, @1],
                           
                           
                           
                           ];
    CGFloat dimension = 0;
    CGPoint offsetPoint = CGPointMake(0, 0);
    for(NSArray * array in matrice)
    {
        if(dimension && dimension != [array count] )
        {
            NSLog(@"INCORRECT MATRICE");
            break;
        }
        dimension = [array count];
        
    }
    
    if(width && height)
    {
        widthOfRect = width/dimension;
        heightOfRect = height/[matrice count];
    }
    else
    {
        widthOfRect = WALL_WIDTH;
        heightOfRect = WALL_HEIGHT;

        
    }
    
    
    for(NSArray * array in matrice)
    {
        offsetPoint.x = 0;
        
        for(NSNumber * number in array)
        {
            
            switch ([number intValue]) {
                case 1:
                {
                    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(offsetPoint.x,offsetPoint.y,widthOfRect ,heightOfRect) ];
                    [arrayOfPaths addObject:path];
                }
                    
                    break;
                    
                case 2:
                    self.startPointNode = [self startPointNodeAtPoint:CGPointMake(offsetPoint.x+widthOfRect/2, offsetPoint.y+heightOfRect/2)];
                    break;
                    
                    
                    
                case 4:
                    self.finalPointNode = [self finalPointNodeAtPoint:CGPointMake(offsetPoint.x+widthOfRect/2, offsetPoint.y+heightOfRect/2)];
                    break;
            }
            
            
            
            offsetPoint.x += widthOfRect;
        }
        offsetPoint.y += heightOfRect;
        
    }
    
    for ( UIBezierPath * path in arrayOfPaths) {
        [pathOfNode appendPath:path ];
    }
    [pathOfNode closePath];
    node.path = [pathOfNode CGPath];
    node.fillColor = [Colors wallColor];
    node.strokeColor = [Colors wallColor];
    
    NSMutableArray * arrayOfBodies =  [NSMutableArray array];
    for (UIBezierPath * path in  arrayOfPaths) {
        SKPhysicsBody * body  = [SKPhysicsBody bodyWithPolygonFromPath:[path CGPath]];
        [arrayOfBodies addObject:body];
    }
    
    node.physicsBody = [SKPhysicsBody bodyWithBodies:arrayOfBodies];
    node.physicsBody.dynamic = NO;
    node.physicsBody.categoryBitMask = wallCategory;
    node.physicsBody.contactTestBitMask = sheepCategory;
    node.physicsBody.friction = 0.0f;

    return node;
    
}

-(SKShapeNode *)startPointNodeAtPoint:(CGPoint) point
{
    SKShapeNode * node = [[SKShapeNode alloc] init];
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, START_WIDTH, START_WIDTH)];
    node.path = [path CGPath];
    node.fillColor = [Colors start];
    node.strokeColor = [Colors start];
    node.glowWidth = START_GLOW_WIDTH;
    node.position = point;
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:START_WIDTH/2+START_GLOW_WIDTH center:CGPointMake(START_WIDTH/2, START_WIDTH/2)];
    node.physicsBody.dynamic = NO;
    node.physicsBody.density  = 0.0;
    node.physicsBody.mass  = 0.0;
    node.physicsBody.contactTestBitMask = sheepCategory;
    

    return node;
}
-(SKShapeNode *)finalPointNodeAtPoint:(CGPoint) point
{
    SKShapeNode * node = [[SKShapeNode alloc] init];
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, FINAL_WIDTH, FINAL_WIDTH)];
    node.path = [path CGPath];
    node.fillColor = [Colors final];
    node.strokeColor = [Colors final];
    node.glowWidth = FINAL_GLOW_WIDTH;
    node.position = point;
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:FINAL_WIDTH/2+FINAL_GLOW_WIDTH center:CGPointMake(FINAL_WIDTH/2, FINAL_WIDTH/2)];
    node.physicsBody.dynamic = NO;
    node.physicsBody.categoryBitMask = checkPointCategory;
    node.physicsBody.contactTestBitMask = sheepCategory;
    node.physicsBody.density  = 0.0;
    node.physicsBody.mass  = 0.0;
    return node;
}






@end
