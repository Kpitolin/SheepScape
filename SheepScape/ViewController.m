//
//  ViewController.m
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import "UIAlertView+BlockAddition.h"
#import "ViewController.h"
#import "MyScene.h"
@interface ViewController()<WinDelegate>
@property (nonatomic, strong)MyScene * scene;
@property (nonatomic , strong)GameLevel * currentGame;
@end
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
   // skView.showsNodeCount = YES;
   // skView.showsPhysics = YES;
    // Create and configure the scene.
    self.currentGame.delegate = self;
    self.scene = [[MyScene alloc ]init];
    self.scene = [self.scene initWithSize:self.view.bounds.size andGameLevel:self.currentGame];
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


// Find a system to pass to next level
#define LEVEL_PLIST_PATH [[NSBundle mainBundle] pathForResource:@"LevelsConfig" ofType:@"plist"]

- (GameLevel *) currentGame
{
    GameLevel * game;
    if (!_currentGame) {
         game = [[GameLevel alloc ]init];
        _currentGame = game;
    }
    _currentGame = [_currentGame initWithPlistRepresentation: [NSDictionary dictionaryWithContentsOfFile:LEVEL_PLIST_PATH]];

    return _currentGame;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)tap{
    if ([self.scene isPaused] && self.scene.gameRunning) {
        [self.scene resumeGame];
        
    }
    else
    {
        [self.scene pauseGame];

    }
    


}


- (void)userFinishedLevel:(GameLevel *)sender
{
    [UIAlertView presentAlertViewWithTitle:@"Tu as gagné"
                                   message:@"Un petit pas de plus vers l'au-delà..." cancelButtonTitle:nil otherButtonTitles:@[@"Continuer"] completionHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                       
                                       switch (buttonIndex) {
                                               
                                           case 0:
                                           {
                                               NSDictionary *levelRep = [NSDictionary dictionaryWithContentsOfFile:LEVEL_PLIST_PATH][[NSString stringWithFormat:@"Level %i",[self.currentGame.level intValue]+1]];
                                               if (levelRep) {
                                                   self.currentGame.level =  @([self.currentGame.level intValue]+1);

                                                   self.scene = [self.scene initWithSize:self.view.bounds.size andGameLevel:self.currentGame];
                                                   
                                                   [(SKView *)self.view presentScene:self.scene transition:[SKTransition pushWithDirection:SKTransitionDirectionUp duration:3.0]];
                                               }
                                               else
                                               {
                                                   [(SKView *)self.view presentScene:nil transition:[SKTransition doorsOpenHorizontalWithDuration:3.0]];
                                                   
                                                   [[[UIAlertView alloc] initWithTitle:@"Fin du jeu"
                                                                               message:@"Tu es arrivé au bout du chemin"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"Ok"
                                                                     otherButtonTitles:nil
                                                     , nil] show];
                                                   
                                               }
                                           }
                                               break;
                                               
                                               
                                       }
                                   }];


}
- (void)userFailedLevel:(GameLevel *)sender
{
    [UIAlertView presentAlertViewWithTitle:@"Game Over"
                                   message:@"Le chemin vers la pureté est encore long..." cancelButtonTitle:nil otherButtonTitles:@[@"Recommencer le niveau",@"Recommencer le jeu"] completionHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                       
                                       switch (buttonIndex) {
                                               
                                           case 0:
                                               
                                               self.scene = [self.scene initWithSize:self.view.bounds.size andGameLevel:self.currentGame];
                                               [(SKView *)self.view presentScene:self.scene transition:[SKTransition fadeWithColor:[SKColor whiteColor]  duration:3.0]];
                                               

                                               break;
                                           case 1:
                                               self.currentGame.level = @(1);
                                               self.scene = [self.scene initWithSize:self.view.bounds.size andGameLevel:self.currentGame];
                                               
                                               [(SKView *)self.view presentScene:self.scene transition:[SKTransition revealWithDirection:SKTransitionDirectionDown duration:3.0]];

                                               break;
                                               
                                               
                                       }
                                   }];
   }


@end
