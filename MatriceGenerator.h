//
//  MatriceGenerator.h
//  SheepScape
//
//  Created by KEVIN on 09/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatriceGenerator : NSObject

+(NSArray *)principalPathWithLength:(int)length;
+(NSArray *)pathWithLength:(int)length;
+(NSArray *)fillMatriceOfXdimension:(int)x andYdimension: (int)y withPaths:(NSArray *)paths;
+(NSNumber *) chooseRandomIndexForPrevious:(NSNumber *)previous min:(NSNumber *)min andMax:(NSNumber *)max;
+(BOOL) validPathOfMatrice :(NSArray *)matrice withMinLength:(NSNumber *)min;
@end
