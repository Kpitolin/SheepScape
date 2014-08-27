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

#define REGULAR_LINE_COUNT 10
#define REGULAR_ROW_COUNT 5

typedef NS_ENUM(NSUInteger, Direction) {
    Left = 0,
    Right = 1,
    Up = 2,
    Down = 3
};
@protocol levelDelegate;

@interface Level : NSObject
@property (nonatomic, strong) NSArray * arrayOfPlaygroundObjects;
@property (nonatomic,strong) SKShapeNode * startPointNode;
@property (nonatomic,strong) SKShapeNode * finalPointNode;
@property (nonatomic, strong) NSArray * matrice;
@property (nonatomic, strong) SheepNode * sheep;
@property (nonatomic, strong) NSNumber * level;
@property (nonatomic, strong) NSNumber * passed;
@property (weak,nonatomic) id<levelDelegate> delegate;



- (id)initWithPlistRepresentation:(id)plistRep;
- (void) initPlaygroundWithWidth: (CGFloat)width andHeigth:(CGFloat)height;
- (BOOL) addSupplementaryNode:(SKNode *)node ;
-(NSNumber *)computeNumberOfNecessaryScenes;
+ (NSNumber *) computeNumberOfNecessaryMatricesForInitialMatrice:(NSArray *)matrice;
+ (NSArray *) splitMatrice: (NSArray *) matrice;


@end
@protocol levelDelegate <NSObject>
- (void)userFinishedLevel:(Level *)sender ;
- (void)userFailedLevel:(Level *)sender ;
- (void)userNeedSceneSwitching:(Level *)sender withDirection:(Direction)direction;

@end