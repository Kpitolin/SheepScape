//
//  Colors.h
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SpriteKit;
@interface Colors : NSObject
+(SKColor *) start;
+(SKColor *) final;
+(SKColor *) sheepColor;
+(SKColor *) wallColor;
+(SKColor *) sceneColor;
+(SKColor *) rainColor;
+ (SKColor *)darkerColorForColor:(SKColor *)c;
+ (SKColor *)brighterColorForColor:(SKColor *)c;
+ (BOOL)isDark:(SKColor *)c;

@end
