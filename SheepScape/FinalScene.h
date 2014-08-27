//
//  FinalScene.h
//  SheepScape
//
//  Created by KEVIN on 10/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Spawner.h"
#import "Colors.h"
@interface FinalScene : SKScene
@property (nonatomic, strong)SKLabelNode * label;
-(id)initWithSize:(CGSize)size andMessage:(NSString*) message;
@end
