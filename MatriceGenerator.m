//
//  MatriceGenerator.m
//  SheepScape
//
//  Created by KEVIN on 09/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "MatriceGenerator.h"

@implementation MatriceGenerator

+(NSArray *)principalPathWithLength:(int)length
{
    NSMutableArray* array = [[NSMutableArray alloc ] init];
    for (int i=1; i < length+1; i++)
    {
        switch (i) {

            case 1:
                [array addObject:@(4)];

                break;
                
            default:
                
                //i==length ?[array addObject:@(2)] :
                [array addObject:@(0)];

                break;
        }
    }
    return array;
}
+(NSArray *)pathWithLength:(int)length
{
    NSMutableArray* array = [[NSMutableArray alloc ]init];
    for (int i=1; i < length+1; i++)
    {
        [array addObject:@(0)];
    }
    return array;
}

#define ABOVE 0
#define BENEATH 1
#define RIGHT 2
#define LEFT 3

+(NSArray *)fillMatriceOfXdimension:(int)x andYdimension: (int)y withPaths:(NSArray *)paths
{
    NSMutableArray* array  = [[NSMutableArray alloc]init];
    NSMutableArray * positionArray = [[NSMutableArray alloc ]init];

// Fill in the matrice with walls
    for (int i = 0; i < y; i++) {
        NSMutableArray * subArray=[[NSMutableArray alloc]init];
        for (int j =0; j < x; j++) {
            [subArray addObject:@(1)];
        }
        [array addObject:subArray];
    }
    
    
    for (NSArray * path in paths)
    {
        NSNumber * previousX;
        NSNumber * previousY;
        for (NSNumber * number in path)
        {


            
            int xIndex=0;
            int yIndex=0;
            // choose random indexes
            if (!previousX && !previousY)
            {
              
                    xIndex  = arc4random()%x;
                    yIndex  = arc4random()%y;
                
            }
            else
            {
                BOOL present  = FALSE;

                
                do {
                    xIndex  =  [[MatriceGenerator chooseRandomIndexForPrevious:previousX min:@(0) andMax:@([[array objectAtIndex:0] count]-1 )] intValue];
                    
                    yIndex  = [[MatriceGenerator chooseRandomIndexForPrevious:previousY min:@(0) andMax:@([array count]-1)] intValue];
                    
                    for (NSArray * array in positionArray) {
                        if([[array objectAtIndex:0] intValue]== xIndex && [[array objectAtIndex:1] intValue]== yIndex)
                        {
                            present = TRUE;
                            break;
                        }
                    }
                } while (
                         (xIndex==[previousX intValue] && yIndex == [previousY intValue])||
                          (xIndex == [previousX intValue]-1 && yIndex== [previousY intValue]-1 )||
                          (xIndex == [previousX intValue]-1 && yIndex== [previousY intValue]+1)||
                          (xIndex == [previousX intValue]+1 && yIndex== [previousY intValue]-1)||
                          (xIndex == [previousX intValue]+1 && yIndex== [previousY intValue]+1)||
                         [[[array objectAtIndex:yIndex] objectAtIndex:xIndex]  isEqual: @(2)] ||
                          [[[array objectAtIndex:yIndex] objectAtIndex:xIndex]  isEqual: @(4)]
                          );


                
            }
            
            
            
            
            
                [[array objectAtIndex:yIndex] setObject:number atIndex:xIndex];
            [positionArray addObject:@[@(xIndex),@(yIndex)]];


       
            

            previousX = @(xIndex);
            previousY = @(yIndex);

            
        }
        
    }
    
    
    // Fill in the blanks with walls
    
    for ( NSMutableArray* subArray in array) {
        for (int i=0; i<[subArray count]; i++) {
            if (![subArray objectAtIndex:i]) {
                [subArray replaceObjectAtIndex:i withObject:@(1)];
            }
        }
    }

    
    return array;
}


+(NSNumber *) chooseRandomIndexForPrevious:(NSNumber *)previous min:(NSNumber *)min andMax:(NSNumber *)max
{
    
    NSNumber * index ;
    if([previous isEqualToNumber: min])
    {
        unsigned choice  = arc4random()%2;
        
        switch (choice) {
            case 0:
                index = previous;
                
                break;
            case 1:
                index = @([previous intValue]+1);
                break;
                
        }
    }
    else if([previous isEqualToNumber: max])
    {
        int choice  = arc4random()%2;
        
        switch (choice) {
            case 0:
                index = previous;
                
                break;
            case 1:
                index = @([previous intValue]-1);
                break;
                
        }
    }
    else
    {
        int choice  = arc4random()%3;
        
        switch (choice) {
            case 0:
                index = previous;
                
                break;
            case 1:
                index = @([previous intValue]+1);
                break;
            case 2:
                index = @([previous intValue]-1);
                break;
                
        }
    }

    return  index;
}

/*
 


 
 break;
 case BENEATH:
 xIndex = [previousX intValue];
 yIndex = [previousY intValue]+1;
 break;
 case RIGHT:
 xIndex = [previousX intValue]+1;
 yIndex = [previousY intValue];
 break;
 case LEFT:
 xIndex = [previousX intValue]-1;
 yIndex = [previousY intValue];
 break;

 */

+(BOOL) validPathOfMatrice :(NSArray *)matrice withMinLength:(NSNumber *)min
{
    // Shortest  path to find here : it must have min lenght or +
    int duration = 0;
    NSNumber * previousX;
    NSNumber * previousY;
    
    int xIndex=0;
    int yIndex=0;
    NSMutableArray * positionArray = [[NSMutableArray alloc ]init];
    for (int i = 0;  i <[matrice count]-1 ; i ++) {
        for (int j = 0;  j <[[matrice objectAtIndex:0] count]-1 ; j ++) {
            if([[[matrice objectAtIndex:i] objectAtIndex:j]  isEqual: @(4)])
            {
                xIndex  = j;
                yIndex  = i;
                NSLog(@"%i/%i",j,i);
                
                break;
            }
            
            
        }
    }
    

    
    do {


        // choose random indexes
        BOOL present  = FALSE;

            do {
                
                if(duration != 0)
                {
                    
                    xIndex  =  [[MatriceGenerator chooseRandomIndexForPrevious:previousX min:@(0) andMax:@([[matrice objectAtIndex:0] count]-1 )] intValue];
                    
                    yIndex  = [[MatriceGenerator chooseRandomIndexForPrevious:previousY min:@(0) andMax:@([matrice count]-1)] intValue];
                }
                
                for (NSArray * array in positionArray) {
                    if([[array objectAtIndex:0] intValue]== xIndex && [[array objectAtIndex:1] intValue]== yIndex)
                    {
                        present = TRUE;
                        break;
                    }
                }

            } while (present ||
                     (xIndex==[previousX intValue] && yIndex == [previousY intValue])||
                     (xIndex == [previousX intValue]-1 && yIndex== [previousY intValue]-1 )||
                     (xIndex == [previousX intValue]-1 && yIndex== [previousY intValue]+1)||
                     (xIndex == [previousX intValue]+1 && yIndex== [previousY intValue]-1)||
                     (xIndex == [previousX intValue]+1 && yIndex== [previousY intValue]+1)||
                     [[[matrice objectAtIndex:yIndex] objectAtIndex:xIndex]  intValue] == 1 ||
                     ([[[matrice objectAtIndex:yIndex] objectAtIndex:xIndex]  intValue] == 4 && duration !=0)
                     );

        
         NSLog(@"%@",[[matrice objectAtIndex:yIndex] objectAtIndex:xIndex]);
        duration++;
        
        [positionArray addObject:@[@(xIndex),@(yIndex)]];
        
        previousX = @(xIndex);
        previousY = @(yIndex);
    
    } while ([[[matrice objectAtIndex:yIndex] objectAtIndex:xIndex]  intValue] != 2);
    BOOL result = FALSE;
    duration-1 >=[min intValue]?(result = TRUE) :(result = FALSE) ;
    NSLog(@"Steps : %i",duration);
    NSLog(@"S %i", [[[matrice objectAtIndex:yIndex] objectAtIndex:xIndex]  intValue]);
 
    return result;
}
@end
