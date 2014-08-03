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
@property (nonatomic, strong)SheepNode * sheep;
@property (nonatomic, strong)SKShapeNode * walls;
@property (nonatomic, strong) CMMotionManager * motionManager;
@property BOOL endAlreadyReached;
@end

@implementation MyScene

#define UPDATES_PER_SECOND 100
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
        screenHeight = screenRect.size.height;
        screenWidth = screenRect.size.width;
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:0];
       // self.anchorPoint = CGPointMake(0, 0);
        self.sheep =  [Spawner sheepNode];
        self.walls =  [Spawner wallNodeWithScreenWidth:screenWidth andScreenHeigth:screenHeight];

        self.sheep.position = CGPointMake(CGRectGetMidX(self.frame)-10,
                                       CGRectGetMidY(self.frame));
        self.walls.position = CGPointMake (0,0);
        
        SKNode *node = [[SKNode alloc ]init];
        node.physicsBody= [SKPhysicsBody bodyWithEdgeLoopFromRect:screenRect];
        [self addChild:node];
        [self addChild:self.walls];
        [self addChild:self.sheep];
        
       // self.myHero.physicsBody.affectedByGravity = NO;
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsBody.usesPreciseCollisionDetection = YES;
        
        self.physicsWorld.contactDelegate = self; // if there's a collision, the scene receive the notification
        
        
        
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
    return self;
}
-(void) pauseGame
{
    [self.motionManager stopAccelerometerUpdates ];
    self.physicsWorld.gravity = CGVectorMake(0, 0);  // at start we have no gravity going on
    self.sheep.physicsBody.velocity = CGVectorMake(0, 0);;

    
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
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    
    UIDevice * device  = [UIDevice currentDevice];


    if (device.orientation == UIDeviceOrientationLandscapeRight)
    {
        currentMaxAccelX = -acceleration.y;
        currentMaxAccelY = -acceleration.x;
    } else if (device.orientation ==UIDeviceOrientationLandscapeLeft )
    {
        currentMaxAccelX = acceleration.y;
        currentMaxAccelY = acceleration.x;
    }else if (device.orientation == UIDeviceOrientationPortraitUpsideDown)
    {
        currentMaxAccelX = acceleration.x;
        currentMaxAccelY = -acceleration.y;
        
    }else if ( device.orientation ==UIDeviceOrientationPortrait )
    {
        currentMaxAccelX = acceleration.x;
        currentMaxAccelY = acceleration.y;
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    
    float newY = 0;
    float newX = 0;
    
   
        newX = currentMaxAccelX*2;
        newY = currentMaxAccelY*2;

    

    self.physicsWorld.gravity= CGVectorMake(newX, newY);

    
}


#pragma mark - SKPhysicsContactDelegate

-(void) didBeginContact:(SKPhysicsContact *)contact
{
    BOOL end;
    if ([contact.bodyB.node isEqual:self.sheep ])
    {
      end =   [self.sheep addDirt];
    }else if ([contact.bodyA.node isEqual:self.sheep ])
    {
     end =    [self.sheep addDirt];

    }
    if (end && !self.endAlreadyReached) {
        
        [self pauseGame]  ;
        [self alert:@"GAME OVER"];
        self.endAlreadyReached = YES;

    }
}
@end
