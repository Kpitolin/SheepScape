//
//  MyScene.m
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import <CoreMotion/CoreMotion.h>
#import "MyGameScene.h"
#import "UIAlertView+BlockAddition.h"
#import "Spawner.h"
@interface MyGameScene()<SKPhysicsContactDelegate,UIAccelerometerDelegate>
{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    double currentMaxAccelX;
    double currentMaxAccelY;

}
@property (nonatomic, strong)SKLabelNode * label;
@property (nonatomic, strong) CMMotionManager * motionManager;
@end

@implementation MyGameScene

#define UPDATES_PER_SECOND 60
-(CMMotionManager *) motionManager
{
    if (!_motionManager)
    {
        CMMotionManager * motionManager = [[CMMotionManager alloc] init];
        motionManager.accelerometerUpdateInterval = 1/UPDATES_PER_SECOND;
        _motionManager = motionManager;
    }
    return _motionManager;
}
-(id)initWithSize:(CGSize)size andGameLevel:(Level*) game
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        _game = game;
        screenRect = [[UIScreen mainScreen] bounds];
//        UIDevice * device  = [UIDevice currentDevice];
        
//        
//        if (device.orientation == UIDeviceOrientationLandscapeRight)
//        {
//            screenHeight = screenRect.size.width;
//            screenWidth = screenRect.size.height;
//        } else if (device.orientation ==UIDeviceOrientationLandscapeLeft )
//        {
//            screenHeight = screenRect.size.width;
//            screenWidth = screenRect.size.height;
//        }else if (device.orientation == UIDeviceOrientationPortraitUpsideDown)
//        {
//            screenHeight = screenRect.size.height;
//            screenWidth = screenRect.size.width;
//        }else if ( device.orientation == UIDeviceOrientationPortrait )
//        {
            screenHeight = screenRect.size.height;
            screenWidth = screenRect.size.width;
            
       // }
        
        self.backgroundColor = [Colors sceneColor];
        [self.game initPlaygroundWithWidth:screenWidth andHeigth:screenHeight];
        SKCropNode * node = [Spawner rainWithHeight:screenHeight];
        [self.game addSupplementaryNode:node];
        //[rainArray objectAtIndex:0].position = CGPointMake(0, screenHeight);
       ((SKNode *)self.game.arrayOfPlaygroundObjects[0]).position = CGPointMake(0, 0);
        for (SKNode * node in self.game.arrayOfPlaygroundObjects) {
            if (node != nil) [self addChild:node];
        }
        self.game.sheep = [Spawner sheepNode];

        [self.game.sheep addChild:self.game.sheep.emmiterNode];

        [self addChild:self.game.sheep];
        

        self.label = [[SKLabelNode alloc ]init];
        self.label.fontColor = [SKColor whiteColor];
        self.label.fontSize  = 11;
        self.label.position = CGPointMake(120, 120);
        [self addChild:self.label];
        self.physicsWorld.speed = 1.0;
        self.physicsBody= [SKPhysicsBody bodyWithEdgeLoopFromRect:screenRect]; // physic body of the scene (the ball can't escape)
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsBody.usesPreciseCollisionDetection = YES;
        self.physicsBody.linearDamping= 0.0;
        self.physicsBody.friction= 0.0;
        self.physicsBody.restitution= 0.0;

        self.physicsWorld.contactDelegate = self; // if there's a collision, the scene receive the notification
        self.gameRunning = NO;

        [self resumeGame];
        
    }
    return self;
}
-(void) resumeGame
{
    self.paused  = NO;
    if (!self.gameRunning ) {
        self.game.sheep.position = self.game.startPointNode.position;
        [self.game.sheep resetColor];
        self.gameRunning = YES;
    }
    if ([self.motionManager isAccelerometerAvailable]) {
        if(!self.motionManager.isAccelerometerActive){
            
            [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                [self outputAccelertionData:accelerometerData.acceleration];
                
                
            }];
        }
    }else
    {
        [self alert:@"Your device doesn't have accelerometer"];
    }
    
}

-(void) pauseGame
{
    [self.motionManager stopAccelerometerUpdates ];

    self.paused = YES;
    
}
-(void)alert:(NSString *)msg
{
   
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil
      , nil] show];
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    //currentMaxAccelX = 0;
   // currentMaxAccelY = 0;
    
//    UIDevice * device  = [UIDevice currentDevice];
//
//
//    if (device.orientation == UIDeviceOrientationLandscapeRight)
//    {
//        currentMaxAccelX = -acceleration.y;
//        currentMaxAccelY = -acceleration.x;
//    } else if (device.orientation ==UIDeviceOrientationLandscapeLeft )
//    {
//        currentMaxAccelX = acceleration.y;
//        currentMaxAccelY = acceleration.x;
//    }else if (device.orientation == UIDeviceOrientationPortraitUpsideDown)
//    {
//        currentMaxAccelX = acceleration.x;
//        currentMaxAccelY = -acceleration.y;
//        
//    }else if ( device.orientation == UIDeviceOrientationPortrait )
//    {
        float newY = 0;
        float newX = 0;
    
    
       // currentMaxAccelX = acceleration.x;
        //currentMaxAccelY = acceleration.y;
      //  newX = currentMaxAccelX*4;
       // newY = currentMaxAccelY*4;
    
    
    
    self.physicsWorld.gravity= CGVectorMake(acceleration.x*4, acceleration.y*4);
    
  
}




#pragma mark - SKPhysicsContactDelegate

-(void) didBeginContact:(SKPhysicsContact *)contact
{
    BOOL end = NO;
    BOOL win = NO;

    if ([contact.bodyB.node isEqual:self.game.sheep ] && [contact.bodyA.node isEqual:[self.game.arrayOfPlaygroundObjects objectAtIndex:0]])
    {
      end =   [self.game.sheep addDirt];
    }else if ([contact.bodyA.node isEqual:self.game.sheep ] && [contact.bodyB.node isEqual:[self.game.arrayOfPlaygroundObjects objectAtIndex:0]])
    {
     end =    [self.game.sheep addDirt];

    }
    
    if([self.game.arrayOfPlaygroundObjects count]>= 4)
    {
        if ([contact.bodyB.node isEqual:self.game.sheep ] && [contact.bodyA.node isEqual:[self.game.arrayOfPlaygroundObjects objectAtIndex:3]])
        {
            if([[self.game.arrayOfPlaygroundObjects objectAtIndex:3] isKindOfClass:[SKCropNode class]])
            {
                [self.game.sheep.physicsBody applyImpulse: CGVectorMake(0,-9.8)];
                [self.game.sheep cleanSheep];
                
            }
        }else if ([contact.bodyA.node isEqual:self.game.sheep ] && [contact.bodyB.node isEqual:[self.game.arrayOfPlaygroundObjects objectAtIndex:3]])
        {
            if([[self.game.arrayOfPlaygroundObjects objectAtIndex:3] isKindOfClass:[SKCropNode class]])
            {
                [self.game.sheep.physicsBody applyImpulse: CGVectorMake(0,-9.8)];
                [self.game.sheep cleanSheep];
                
            }
        }
    }

    
    if ([contact.bodyB.node isEqual:self.game.sheep ] && [contact.bodyA.node isEqual:self.game.finalPointNode])
    {
        win = YES;
    }else if ([contact.bodyA.node isEqual:self.game.sheep ] && [contact.bodyB.node isEqual:self.game.finalPointNode])
    {
        win = YES;

    }
    
    
    if (([contact.bodyB.node isEqual:self.game.sheep ] && [contact.bodyA.node isEqual:self.physicsBody])
        || ([contact.bodyA.node isEqual:self.game.sheep ] && [contact.bodyB.node isEqual:self.physicsBody]))
    {
        if(contact.contactPoint.x == self.scene.size.width )
        {
            if ([self.delegate respondsToSelector:@selector(userNeedSceneSwitchingForLevel:withDirection:currentSceneLateralPosition:verticalPosition:)]) {
                [self.game.delegate userNeedSceneSwitchingForLevel:self.game withDirection:Right currentSceneLateralPosition: self.lateralPosition verticalPosition: self.verticalPosition];
            }
        }
        if ( contact.contactPoint.y == self.scene.size.height)
        {
            if ([self.delegate respondsToSelector:@selector(userNeedSceneSwitchingForLevel:withDirection:currentSceneLateralPosition:verticalPosition:)]) {
                [self.game.delegate userNeedSceneSwitchingForLevel:self.game withDirection:Down currentSceneLateralPosition: self.lateralPosition verticalPosition: self.verticalPosition];
            }
        }
        if (contact.contactPoint.y  == 0)
        {
            if ([self.delegate respondsToSelector:@selector(userNeedSceneSwitchingForLevel:withDirection:currentSceneLateralPosition:verticalPosition:)]) {
                [self.game.delegate userNeedSceneSwitchingForLevel:self.game withDirection:Up currentSceneLateralPosition: self.lateralPosition verticalPosition: self.verticalPosition];
            }
        }
        if (contact.contactPoint.x  == 0)
        {
            if ([self.delegate respondsToSelector:@selector(userNeedSceneSwitchingForLevel:withDirection:currentSceneLateralPosition:verticalPosition:)]) {
                [self.game.delegate userNeedSceneSwitchingForLevel:self.game withDirection:Left currentSceneLateralPosition: self.lateralPosition verticalPosition: self.verticalPosition];
            }
        }
    }
    
  
        

    
    if (end && self.gameRunning) {
        
        [self pauseGame]  ;
        self.gameRunning = NO;
        self.game.passed = @(!end);




    }
    if (win && self.gameRunning) {
        
        [self pauseGame]  ;
        self.gameRunning = NO;
        self.game.passed = @(win);


    }
    
    
    
}
    
@end
