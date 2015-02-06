//
//  MediaPlayerViewController.m
//  tuangouproject
//
//  Created by stcui on 11/27/14.
//
//

#import "MediaPlayerViewController.h"
#import "GuideView.h"

@import MediaPlayer;

@interface MediaPlayerViewController () <GuideViewDelegate>
{
    MPMoviePlayerController *_player;
    GuideView *_guideView;
}
@end

@implementation MediaPlayerViewController
- (instancetype)initWithContentURL:(NSURL *)url
{
    self = [self init];
    if (self) {
        _player = [[MPMoviePlayerController alloc] initWithContentURL:url];
        _player.scalingMode = MPMovieScalingModeAspectFill;
        _player.controlStyle = MPMovieControlStyleNone;
        _player.repeatMode = MPMovieRepeatModeOne;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMovieEnd:) name:MPMoviePlayerPlaybackDidFinishNotification object:_player];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_guideView prepareForDealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = self.view.bounds;
    frame.size.height -= 44;
    GuideView *guideView = [[GuideView alloc] initWithFrame:frame];
    guideView.delegate = self;
    guideView.backgroundColor = [UIColor clearColor];
    guideView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:guideView];
    _guideView = guideView;
    
    CGFloat width = CGRectGetWidth(self.view.bounds) / 2;
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = [UIColor blackColor];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(0, 0, width, 44);

    UIButton *regButton = [UIButton buttonWithType:UIButtonTypeCustom];
    regButton.backgroundColor = [UIColor colorWithHue:0.57 saturation:1 brightness:0.73 alpha:1];
    [regButton setTitle:@"注册" forState:UIControlStateNormal];
    regButton.frame = CGRectMake(width, 0, width, 44);

    loginButton.bottom = CGRectGetMaxY(self.view.bounds);
    regButton.bottom = loginButton.bottom;
    
    [loginButton addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
    [regButton addTarget:self action:@selector(onReg:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginButton];
    [self.view addSubview:regButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)wantsFullScreenLayout
{
    return YES;
}

- (void)play
{
    _player.view.frame = self.view.bounds;
    _player.fullscreen = YES;
    [self.view insertSubview:_player.view belowSubview:_guideView];
//    [self.view addSubview:_player.view];
    [_player play];
}

- (void)onMovieEnd:(NSNotification *)notification
{
//    if(self.onFinish) {
//        self.onFinish(self);
//    }
}

- (void)onGuideGoPressed
{
    if (self.onFinish) {
        self.onFinish(self, MediaPlayerFinishTypeSkip);
    }
}

- (void)onLogin:(id)sender
{
    if (self.onFinish) {
        self.onFinish(self, MediaPlayerFinishTypeLogin);
    }
}

- (void)onReg:(id)sender
{
    if (self.onFinish) {
        self.onFinish(self, MediaPlayerFinishTypeRegister);
    }
}
@end
