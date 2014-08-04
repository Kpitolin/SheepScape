//
//  ViewController.m
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
@interface ViewController()
@property (nonatomic, strong)MyScene * scene;

@end
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = YES;
    skView.showsPhysics = YES;
    // Create and configure the scene.
    self.scene = [MyScene sceneWithSize:skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * note){
                                                      [self.scene pauseGame];
                                                  }];
    

    // Present the scene.
    [skView presentScene:self.scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)tap{
    if ([self.scene isPaused] && self.scene.gameRunning) {
        [self.scene resumeGame];
        
    } else if([self.scene isPaused] && !self.scene.gameRunning){
        self.scene = [MyScene sceneWithSize:self.view.bounds.size];
        [(SKView *)self.view presentScene:self.scene transition:[SKTransition pushWithDirection:SKTransitionDirectionUp duration:2.0]];

        
    }
    else
    {
        [self.scene pauseGame];

    }
    


}
@end
