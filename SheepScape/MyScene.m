//
//  MyScene.m
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import <CoreMotion/CoreMotion.h>
#import "MyScene.h"
#import "UIAlertView+BlockAddition.h"

@interface MyScene()<SKPhysicsContactDelegate,UIAccelerometerDelegate>
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

@implementation MyScene

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
-(id)initWithSize:(CGSize)size andGameLevel:(GameLevel*) game
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
        self.physicsWorld.speed = 2.0;
        self.physicsBody= [SKPhysicsBody bodyWithEdgeLoopFromRect:screenRect]; // physic body of the scene (the ball can't escape)
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsBody.usesPreciseCollisionDetection = YES;
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
    
    
    
    self.physicsWorld.gravity= CGVectorMake(acceleration.x, acceleration.y);
    
    //    self.label.text = [NSString stringWithFormat:@"%f,%f || %f,%f ",self.physicsWorld.gravity.dx,self.physicsWorld.gravity.dy, self.motionManager.accelerometerData.acceleration.x, self.motionManager.accelerometerData.acceleration.y];
    //}
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
   
    
   
    

    
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
                [self.game.sheep cleanSheep];
                
            }
        }else if ([contact.bodyA.node isEqual:self.game.sheep ] && [contact.bodyB.node isEqual:[self.game.arrayOfPlaygroundObjects objectAtIndex:3]])
        {
            if([[self.game.arrayOfPlaygroundObjects objectAtIndex:3] isKindOfClass:[SKCropNode class]])
            {
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
    
    if (end && self.gameRunning) {
        
        [self pauseGame]  ;
        self.gameRunning = NO;
        self.game.win = @(!end);




    }
    if (win && self.gameRunning) {
        
        [self pauseGame]  ;
        self.gameRunning = NO;
        self.game.win = @(win);


    }
    
    
    
}
    
@end
