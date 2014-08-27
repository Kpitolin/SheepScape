//
//  Game.m
//  SheepScape
//
//  Created by KEVIN on 03/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import "Spawner.h"
#import "MyGameScene.h"
#import "Level.h"
@interface Level ()
{
    NSArray * _scenes;
}

@end

@implementation Level

- (id)initWithPlistRepresentation:(id)plistRep
{
    self = [super init];
    
    if (self)
        
    {
        
        NSDictionary *levelRep = plistRep[[NSString stringWithFormat:@"Level %i",[self.level intValue]>0? [self.level intValue]:1]];
        NSArray *matrice = levelRep[@"Matrice"];
        _matrice = [matrice copy];
        [self.sheep removeAllChildren];

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
        NSLog(@"Playground Creation Error : no matrice defined");
    }
    
}

-(void) initLevel
{
   int nb_scenes  = [[self computeNumberOfNecessaryScenes] intValue];
    switch (nb_scenes) {
            
        case 1:
            
            break;
            
        default:
            
            NSAssert(nb_scenes!=0, @"Number of scenes can't be 0");
            
            
            break;
    
        
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

-(void) setPassed:(NSNumber *)win
{
    _passed = win;
    if ([win boolValue] && [self.delegate respondsToSelector:@selector(userFinishedLevel:)]) {
        [self.delegate userFinishedLevel:self];
    }
    else if (![win boolValue] && [self.delegate respondsToSelector:@selector(userFailedLevel:)])
    {
        [self.delegate userFailedLevel:self];

    }
}

-(NSNumber *)computeNumberOfNecessaryScenes
{
    return [Level computeNumberOfNecessaryMatricesForInitialMatrice:self.matrice];
}





+ (NSNumber *) computeNumberOfNecessaryMatricesForInitialMatrice:(NSArray *)matrice;
{
    NSUInteger nbLines = [matrice count];
    NSUInteger nbRows = [[matrice objectAtIndex:0] count];
    
    NSAssert(nbLines%REGULAR_LINE_COUNT==0, @"matrice does not have correct line count") ;
    NSAssert(nbRows%REGULAR_ROW_COUNT==0, @"matrice does not have correct row count") ;

    double multipleLines = nbLines/REGULAR_LINE_COUNT;
    double multipleRows = nbRows/REGULAR_ROW_COUNT;
    
    
    
    return @(multipleLines*multipleRows);
}

+ (NSArray *) splitMatrice: (NSArray *) matrice 
{
    int pieces = [[Level computeNumberOfNecessaryMatricesForInitialMatrice:matrice] intValue];
    NSMutableArray * arrayOfMatrices = [NSMutableArray array];
    NSMutableArray * newMatrice = [NSMutableArray array];
    int offsetRow = 0;

    for(int i = 0; i < [matrice count]; i++ )
    {
        
        NSMutableArray * newLine = [NSMutableArray array];

        for (int j = offsetRow; j < [[matrice objectAtIndex:i] count]; j++ ) {
            NSNumber * value = [[matrice objectAtIndex:i] objectAtIndex:j];
            if ([newLine count] == REGULAR_ROW_COUNT)
            {
                [newMatrice addObject:newLine];
                
                break;
            }
            else
            {
                [newLine addObject:value];

            }
            
            
        }
        
        if ([newMatrice count] == REGULAR_LINE_COUNT)
        {
            [arrayOfMatrices addObject:newMatrice];
            newMatrice = [NSMutableArray array];
            
            if (pieces -[arrayOfMatrices count] > 0)
            {
                i = 0;
                offsetRow += REGULAR_ROW_COUNT;
            }
        }
    }
    

    return arrayOfMatrices;
}



@end
