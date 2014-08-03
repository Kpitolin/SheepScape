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

+ (SheepNode *) sheepNode
{
    SheepNode * node = [[SheepNode alloc] init];
    node = [node create];
    [node addChild:node.emmiterNode];
    node.emmiterNode.position = CGPointMake(0, 0);
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:SHEEP_WIDTH/2];
    node.physicsBody.dynamic = YES;
    node.physicsBody.categoryBitMask = sheepCategory;
    node.physicsBody.contactTestBitMask = wallCategory;
    node.physicsBody.friction = 0.0f;
    node.physicsBody.restitution = 1.0f;
    node.physicsBody.linearDamping = 0.0f;
    node.physicsBody.allowsRotation = NO;
    return node;
}

static CGPoint startPoint;
static CGPoint finalPoint;
#define WALL_WIDTH 40
#define WALL_HEIGHT 40
+ (SKShapeNode *) wallNodeWithScreenWidth: (CGFloat)width andScreenHeigth:(CGFloat)height
{
    SKShapeNode * node = [[SKShapeNode alloc] init];
    UIBezierPath * pathOfNode = [[UIBezierPath alloc ]init];
     CGFloat widthOfRect;
     CGFloat heightOfRect;
    NSMutableArray * arrayOfPaths = [[NSMutableArray alloc ]init];
    NSArray * matrice =  @[
                           @[ @2, @1, @1, @1, @0, @1],
                           @[ @0, @0, @0, @1, @0, @1],
                           @[ @1, @1, @0, @1, @1, @1],
                           @[ @0, @0, @0, @0, @0, @1],
                           @[ @1, @1, @0, @1, @0, @1],
                           @[ @0, @0, @0, @0, @0, @1],
                           @[ @0, @1, @0, @1, @0, @1],
                           @[ @0, @1, @0, @1, @0, @1],
                           @[ @0, @1, @0, @1, @0, @1],
                           @[ @1, @1, @0, @1, @4, @1],
                           
                           
                           
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
                    startPoint = offsetPoint;
                    break;
                    
                    
                    
                case 4:
                    finalPoint = offsetPoint;
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








@end
