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
#import "GameKitHelper.h"

#import "GADBannerView.h"
#import "GADRequest.h"

#define ADMOB_ID  @"ca-app-pub-5795175496660185/4979686959"


@implementation ViewController
{
    UIButton *restartButton;
    UIButton *continueButton;
    UIButton *startButton;
    
    UIButton *actionButton;
    UIButton *rateButton;
    
    UIButton *gameCenterButton;
    
    UILabel *gameOverLabel;
    BOOL isGameOver;
    SKView *gameView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    isGameOver = NO;
    // Configure the view.
    gameView = [[SKView alloc] initWithFrame:self.view.frame];
    
    SKScene * scene = [MyScene sceneWithSize:gameView.frame.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;

    // Present the scene.
    [gameView presentScene:scene];
    
    [self.view addSubview:gameView];
    
    [self addRestartButton];
    [self addContinueButton];
    [self addGameOverLabel];
    
    [self addActionButton];
    [self addRateButton];
    [self addGameCenterButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOver) name:@"gameOverNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:@"pauseNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticationViewController) name:PresentAuthenticationViewController object:nil];
    
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    
    // iAd
    self.canDisplayBannerAds = YES;
    
    // Admob
    [self addAdmob];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _adBanner.delegate = nil;
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

- (void)addGameCenterButton
{
    gameCenterButton = [[UIButton alloc]init];
    [gameCenterButton setFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100,self.view.frame.size.height/2 + 30,200,30)];
    [gameCenterButton setTitle:@"Game Center" forState:UIControlStateNormal];
    gameCenterButton.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:20];
    
    [gameCenterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gameCenterButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [gameCenterButton.layer setBorderWidth:2.0];
    [gameCenterButton.layer setCornerRadius:15.0];
    [gameCenterButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [gameCenterButton.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [gameCenterButton.layer setOpaque:YES];
    [gameCenterButton addTarget:self action:@selector(showGameCenter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gameCenterButton];
    
    gameCenterButton.hidden = YES;
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
    gameView.paused = YES;
    isGameOver = YES;
    restartButton.hidden = NO;
    actionButton.hidden = NO;
    rateButton.hidden = NO;
    gameCenterButton.hidden = NO;
}

- (void)pause{
    
    gameView.paused = YES;

    if (!isGameOver) {
        restartButton.hidden = NO;
        continueButton.hidden = NO;
        actionButton.hidden = YES;
        rateButton.hidden = YES;
        gameCenterButton.hidden = NO;

    }
    
    
}

- (void)restart:(UIButton *)button{
    
    isGameOver = NO;
    gameView.paused = NO;
    
    actionButton.hidden = YES;
    rateButton.hidden = YES;
    restartButton.hidden = YES;
    continueButton.hidden = YES;
    gameCenterButton.hidden = YES;

    [[NSNotificationCenter defaultCenter]postNotificationName:@"restartNotification" object:nil];
}

- (void)continueGame:(UIButton *)button{
    
    isGameOver = NO;
    gameView.paused = NO;

    actionButton.hidden = YES;
    rateButton.hidden = YES;
    continueButton.hidden = YES;
    restartButton.hidden = YES;
    gameCenterButton.hidden = YES;

}

- (BOOL)shouldAutorotate
{
    return NO;
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

- (void)addActionButton
{
    UIImage *image = [UIImage imageNamed:@"action"];
    actionButton = [[UIButton alloc]init];
    [actionButton setFrame:CGRectMake(self.view.frame.size.width/3 - 15, self.view.frame.size.height/2 + 65 , image.size.width/3*2,image.size.height/3*2)];
    [actionButton setBackgroundImage:image forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:actionButton];
    actionButton.hidden = YES;
    
}

- (void)addRateButton
{
    UIImage *image = [UIImage imageNamed:@"rate"];
    rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rateButton setFrame:CGRectMake(self.view.frame.size.width/3*2 - 25, self.view.frame.size.height/2 + 65 , image.size.width/3*2,image.size.height/3*2)];
    [rateButton setBackgroundImage:image forState:UIControlStateNormal];
    [rateButton addTarget:self action:@selector(rate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rateButton];
    rateButton.hidden = YES;
}

- (void)action
{
    NSString *initialString = @"Smash Bug! is a Great App! Have Fun with it!";
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/air-drum-*/id901397384?ls=1&mt=8"];
    //UIImage *showImage = [UIImage imageNamed:@"Default-568h@2x"];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[initialString,url] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];

}

- (void)rate
{
    //self.canDisplayBannerAds = NO;
    NSLog(@"rate");
    NSString *str = @"itms-apps://itunes.apple.com/app/id901397384";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark - Game Kit

- (void)showAuthenticationViewController
{
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    
    [self presentViewController:gameKitHelper.authenticationViewController animated:YES completion:nil];
}

- (void)showGameCenter
{
    [[GameKitHelper sharedGameKitHelper] showGKGameCenterViewController:self];
}

#pragma mark - Admob

- (void)addAdmob
{
    // Initialize the banner at the bottom of the screen.
    CGPoint origin = CGPointMake(0.0,
                                 self.view.frame.size.height -
                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID before compiling.
    self.adBanner.adUnitID = ADMOB_ID;
    self.adBanner.delegate = self;
    self.adBanner.rootViewController = self;
    [self.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[self request]];
}

#pragma mark GADRequest generation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            GAD_SIMULATOR_ID
                            ];
    return request;
}

#pragma mark GADBannerViewDelegate implementation

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}



@end
