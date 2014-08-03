//
//  Colors.m
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "Colors.h"

@implementation Colors
+(SKColor *) sheepColor{
    return [SKColor colorWithWhite:1.0 alpha:1.0];
}
+(SKColor *) wallColor{
    return [SKColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
}
+ (SKColor *)darkerColorForColor:(SKColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [SKColor colorWithRed:MAX(r - 0.05, 0.0)
                               green:MAX(g - 0.05, 0.0)
                                blue:MAX(b - 0.05, 0.0)
                               alpha:a];
    NSLog(@"DIDN'T WORK");
    return nil;
}
+ ( BOOL)isDark:(SKColor *)c
{
    CGFloat r, g, b, a;
    BOOL isDark = NO;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
    {
        if (r==0 && g==0 && b==0)
        {
            isDark = YES;
        }
    }
    return isDark;
    
}
@end
