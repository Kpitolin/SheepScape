//
//  Game.m
//  SheepScape
//
//  Created by KEVIN on 03/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "GameLevel.h"
@interface GameLevel ()


@end

@implementation GameLevel

- (id)initWithPlistRepresentation:(id)plistRep
{
    self = [super init];
    
    if (self)
        
    {

        NSDictionary *levelRep = plistRep[[NSString stringWithFormat:@"Level %i",[self.level intValue]>0? [self.level intValue]:1]];
        NSArray *matrice = levelRep[@"Matrice"];
        _matrice = [matrice copy];
        _sheep = [Spawner sheepNode];
    }
    
    return self;
}
-(void)setArrayOfPlaygroundObjects:(NSArray *)arrayOfPlaygroundObjects
{
    _arrayOfPlaygroundObjects = arrayOfPlaygroundObjects;
    self.startPointNode= _arrayOfPlaygroundObjects[1];
    self.finalPointNode = _arrayOfPlaygroundObjects[2];
}

- (SKShapeNode *) startPointNode
{
    if (_arrayOfPlaygroundObjects) {
      return   _arrayOfPlaygroundObjects[1];
    }
    else
    {
        NSLog(@"Playground Creation Error : no start point");

    }
    
    return nil;
}
- (SKShapeNode *) finalPointNode
{
    if (_arrayOfPlaygroundObjects) {
        return   _arrayOfPlaygroundObjects[2];
    }
    else
    {
        NSLog(@"Playground Creation Error : no final point");
   
    }
    
    return nil;
}

- (void) initPlaygroundWithWidth: (CGFloat)width andHeigth:(CGFloat)height
{
    if(_matrice)
    {
        _arrayOfPlaygroundObjects =  [Spawner createPlaygroundWithWidth:width andHeigth:height andMatrice:self.matrice];
    }
    else
    {
        NSLog(@"Playground Creation Error");
    }
    
}


- (BOOL) addSupplementaryNode:(SKNode *)node
{
    BOOL success  = NO;
    if(_arrayOfPlaygroundObjects && ![_arrayOfPlaygroundObjects containsObject:node])
    {
        NSMutableArray *array =  [self.arrayOfPlaygroundObjects mutableCopy];
        [array addObject:node];
        self.arrayOfPlaygroundObjects = array;
        success  = YES;
        
    }
  
    
    
    return success;
}

-(void) setWin:(NSNumber *)win
{
    _win = win;

    if ([win boolValue] && [self.delegate respondsToSelector:@selector(userFinishedLevel:)]) {
        [self.delegate userFinishedLevel:self];
    }
}

@end
