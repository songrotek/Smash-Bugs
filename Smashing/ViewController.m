//
//  ViewController.m
//  Smashing
//
//  Created by FloodSurge on 7/21/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import <QuartzCore/QuartzCore.h>


@implementation ViewController
{
    UIButton *restartButton;
    UIButton *continueButton;
    UIButton *startButton;
    UILabel *gameOverLabel;
    BOOL isGameOver;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    isGameOver = NO;
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    //SKScene * scene = [MyScene sceneWithSize:CGSizeMake(320, 420)];
    SKScene * scene = [MyScene sceneWithSize:skView.frame.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    //skView.paused = YES;
    
    //[self addStartButton];
    [self addRestartButton];
    [self addContinueButton];
    [self addGameOverLabel];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOver) name:@"gameOverNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:@"pauseNotification" object:nil];
}

- (void)addGameOverLabel
{
    gameOverLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100,self.view.frame.size.height/2 - 60,200,30)];
    gameOverLabel.text = @"Game Over";
    
}

- (void)addRestartButton
{
    restartButton = [[UIButton alloc]init];
    [restartButton setBounds:CGRectMake(0,0,200,30)];
    [restartButton setCenter:self.view.center];
    [restartButton setTitle:@"Restart" forState:UIControlStateNormal];
    restartButton.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:20];
    
    [restartButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [restartButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [restartButton.layer setBorderWidth:2.0];
    [restartButton.layer setCornerRadius:15.0];
    [restartButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [restartButton.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [restartButton.layer setOpaque:YES];
    [restartButton addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:restartButton];
    
    restartButton.hidden = YES;

}

- (void)addContinueButton
{
    continueButton = [[UIButton alloc]init];
    [continueButton setFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100,self.view.frame.size.height/2 - 60,200,30)];
    [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    continueButton.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:20];
    
    [continueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [continueButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [continueButton.layer setBorderWidth:2.0];
    [continueButton.layer setCornerRadius:15.0];
    [continueButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [continueButton.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [continueButton addTarget:self action:@selector(continueGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueButton];
    
    continueButton.hidden = YES;

}

- (void)gameOver{
    NSLog(@"game over");
    ((SKView *)self.view).paused = YES;
    isGameOver = YES;
    restartButton.hidden = NO;
}

- (void)pause{
    ((SKView *)self.view).paused = YES;

    if (!isGameOver) {
        
        restartButton.hidden = NO;
        continueButton.hidden = NO;
        //startButton.hidden = YES;

    }
    
    
}

- (void)restart:(UIButton *)button{
    
    isGameOver = NO;
    ((SKView *)self.view).paused = NO;
    restartButton.hidden = YES;
    continueButton.hidden = YES;
    //startButton.hidden = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"restartNotification" object:nil];
}

- (void)continueGame:(UIButton *)button{
    
    isGameOver = NO;
    continueButton.hidden = YES;
    restartButton.hidden = YES;
    ((SKView *)self.view).paused = NO;
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
