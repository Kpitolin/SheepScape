//
//  FinalScene.m
//  SheepScape
//
//  Created by KEVIN on 10/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "FinalScene.h"
@interface FinalScene ()
{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
}
@end
@implementation FinalScene
-(id)initWithSize:(CGSize)size andMessage:(NSString*) message
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        screenRect = [[UIScreen mainScreen] bounds];

        screenHeight = screenRect.size.height;
        screenWidth = screenRect.size.width;
        
        //self.anchorPoint = CGPointMake(CGRectGetMidX(screenRect), CGRectGetMidY(screenRect));
        self.backgroundColor = [Colors sceneColor];
        SKCropNode * node = [Spawner rainWithHeight:screenHeight];
        self.label = [[SKLabelNode alloc ]init];
        self.label.color = [Colors rainColor];
        self.label.fontColor = [SKColor redColor];
        self.label.fontSize  = 20;
        self.label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.label.horizontalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.label.position = CGPointMake(CGRectGetMidX(screenRect), CGRectGetMidY(screenRect));
        self.label.text = message;
        [self addChild:self.label];
        [self addChild:node];


        
    }
    return self;
}

@end
