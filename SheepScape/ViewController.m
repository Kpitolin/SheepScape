//
//  ViewController.m
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//
#import "UIAlertView+BlockAddition.h"
#import "ViewController.h"
#import "MyGameScene.h"
#import "Spawner.h"
@interface ViewController()<levelDelegate>
@property (nonatomic, strong)MyGameScene * scene;
@property (nonatomic , strong)Level * currentGame;
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
    self.scene = [[MyGameScene alloc ]init];
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
    //[(SKView *)self.view presentScene:[Spawner finalSceneWithSize:self.view.bounds.size andMessage:@"Bravo, tu es arrivé au bout du chemin."] transition:[SKTransition doorsOpenHorizontalWithDuration:3.0]];
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
#define LEVEL_PLIST_PATH [[NSBundle mainBundle] pathForResource:@"game_easy" ofType:@"plist"]

- (Level *) currentGame
{
    Level * game;
    if (!_currentGame) {
         game = [[Level alloc ]init];
        _currentGame = game;
    }
    _currentGame = [_currentGame initWithPlistRepresentation: [NSDictionary dictionaryWithContentsOfFile:LEVEL_PLIST_PATH]];

    return _currentGame;
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


// Swift this and put it in game !!
#pragma mark - TO UPDATE 
- (void)userFinishedLevel:(Level *)sender
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
                                                   [(SKView *)self.view presentScene:[Spawner finalSceneWithSize:self.view.bounds.size andMessage:@"Bravo\nTu es arrivé au bout du chemin."] transition:[SKTransition doorsOpenHorizontalWithDuration:3.0]];
                                                   

                                                   
                                               }
                                           }
                                               break;
                                               
                                               
                                       }
                                   }];


}
- (void)userFailedLevel:(Level *)sender
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

- (void)userNeedSceneSwitchingForLevel:(Level *)sender withDirection:(Direction)direction currentSceneLateralPosition: (NSNumber *)lateral verticalPosition:(NSNumber *)vertical
{
    
    MyGameScene * gscene = nil;
    for (MyGameScene* scene in sender.scenes)
    {
        if ([scene.lateralPosition isEqualToNumber:lateral] && [scene.verticalPosition isEqualToNumber:vertical]) {
            gscene = scene;
        }
    }
    
    if(gscene!= nil)
    {
        switch (direction) {
            case Left:
                
                
                [(SKView *)self.view presentScene:gscene transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:3.0]];
                
                
                break;
            case Right:
                
                [(SKView *)self.view presentScene:gscene transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:3.0]];
                
                break;
            case Up:
                
                [(SKView *)self.view presentScene:gscene transition:[SKTransition pushWithDirection:SKTransitionDirectionDown duration:3.0]];
                
                break;
            case Down:
                
                [(SKView *)self.view presentScene:gscene transition:[SKTransition pushWithDirection:SKTransitionDirectionUp duration:3.0]];
                
                break;
                
            default:
                NSAssert(true, @"Gesture not recognized");
                break;
        }
    }

}
@end
