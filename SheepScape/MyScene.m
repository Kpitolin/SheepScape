//
//  MyScene.m
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import <CoreMotion/CoreMotion.h>
#import "MyScene.h"
#import "Spawner.h"
@interface MyScene()<SKPhysicsContactDelegate,UIAccelerometerDelegate>
{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    double currentMaxAccelX;
    double currentMaxAccelY;

}
@property (nonatomic, strong)Spawner * game;
@property (nonatomic, strong)SheepNode * sheep;
@property (nonatomic, strong)SKShapeNode * walls;
@property (nonatomic, strong)SKEmitterNode * rain;
@property (nonatomic, strong)SKNode * rainArea;
@property (nonatomic, strong)SKLabelNode * label;
@property (nonatomic, strong) CMMotionManager * motionManager;
@end

@implementation MyScene

#define UPDATES_PER_SECOND 1000
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
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
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
        self.game = [[Spawner alloc ]init];
        
        self.sheep =  [Spawner sheepNode];
        self.walls =  [self.game wallNodeWithScreenWidth:screenWidth andScreenHeigth:screenHeight];
        self.rain = [Spawner rain];
        self.rainArea = [self.game rainAreaFromRainNode:self.rain andHeight:screenHeight];
        
        self.walls.position = CGPointMake (0,0);
        
        self.rain.position = CGPointMake(0, screenHeight);

        
        self.physicsBody= [SKPhysicsBody bodyWithEdgeLoopFromRect:screenRect]; // physic body of the scene (the ball can't escape)
        //[self addChild:self.walls];
        [self addChild:self.sheep];
        [self addChild:self.rain];
        [self addChild:self.rainArea];
        [self addChild:self.game.startPointNode];
        [self addChild:self.game.finalPointNode];
        self.label = [[SKLabelNode alloc ]init];
        self.label.fontColor = [SKColor blackColor];
        self.label.fontSize  = 11;
        self.label.position = CGPointMake(120, 120);
        [self addChild:self.label];
        
        
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
        self.sheep.position = self.game.startPointNode.position;
        [self.sheep resetColor];
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
    //self.physicsWorld.gravity = CGVectorMake(0, 0);  // at start we have no gravity going on
    //self.sheep.physicsBody.velocity = CGVectorMake(0, 0);;
    self.paused = YES;
    
}
-(void)alert:(NSString *)msg
{
   
    [[[UIAlertView alloc] initWithTitle:@"Erreur"
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
    
        currentMaxAccelX = acceleration.x;
        currentMaxAccelY = acceleration.y;
        
    //}
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    
    float newY = 0;
    float newX = 0;
    
   
        newX = currentMaxAccelX*4;
        newY = currentMaxAccelY*4;

    

    self.physicsWorld.gravity= CGVectorMake(newX, newY);

    self.label.text = [NSString stringWithFormat:@"%f,%f|| %f,%f ",self.physicsWorld.gravity.dx,self.physicsWorld.gravity.dx, self.motionManager.accelerometerData.acceleration.x, self.motionManager.accelerometerData.acceleration.y];
}


#pragma mark - SKPhysicsContactDelegate

-(void) didBeginContact:(SKPhysicsContact *)contact
{
    BOOL end = NO;
    BOOL win;

    if ([contact.bodyB.node isEqual:self.sheep ] && [contact.bodyA.node isEqual:self.walls])
    {
      end =   [self.sheep addDirt];
    }else if ([contact.bodyA.node isEqual:self.sheep ] && [contact.bodyB.node isEqual:self.walls])
    {
     end =    [self.sheep addDirt];

    }
    if ([contact.bodyB.node isEqual:self.sheep ] && [contact.bodyA.node isEqual:self.rainArea])
    {
          [self.sheep cleanSheep];
    }else if ([contact.bodyA.node isEqual:self.sheep ] && [contact.bodyB.node isEqual:self.rainArea])
    {
           [self.sheep cleanSheep];
        
    }
    
    if ([contact.bodyB.node isEqual:self.sheep ] && [contact.bodyA.node isEqual:self.game.finalPointNode])
    {
        win = YES;
    }else if ([contact.bodyA.node isEqual:self.sheep ] && [contact.bodyB.node isEqual:self.game.finalPointNode])
    {
        win = YES;

    }
    
    if (end && self.gameRunning) {
        
        [self pauseGame]  ;
        [self alert:@"GAME OVER"];
        self.gameRunning = NO;

    }
    if (win && self.gameRunning) {
        
        [self pauseGame]  ;
        [self alert:@"YOU WIN !!"];
        self.gameRunning = NO;
        
    }
    
    
    
}
    
@end
