//
//  SoundHelper.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 8/31/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "SoundHelper.h"

@implementation SoundHelper

+ (instancetype)sharedSoundInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)startSoundSession
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [audioSession setActive:YES error:nil];
    
    NSURL *soundUrl = [[NSBundle mainBundle] URLForResource:@"knockknock" withExtension:@"wav"];
    NSError* error = nil;
    _puertaSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (!_puertaSound) {
        NSLog(@"Error creating player(puerta): %@",error);
    }
    soundUrl = [[NSBundle mainBundle] URLForResource:@"contractSound" withExtension:@"wav"];
    error = nil;
    _contractsSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (!_contractsSound) {
        NSLog(@"Error creating player(contract): %@",error);
    }
    
    soundUrl = [[NSBundle mainBundle] URLForResource:@"freezerSound" withExtension:@"wav"];
    error = nil;
    _freezerSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (!_freezerSound) {
        NSLog(@"Error creating player(freezer): %@",error);
    }
    
    soundUrl = [[NSBundle mainBundle] URLForResource:@"shopSound" withExtension:@"wav"];
    error = nil;
    _shopSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (!_shopSound) {
        NSLog(@"Error creating player(shop): %@",error);
    }
    
    soundUrl = [[NSBundle mainBundle] URLForResource:@"moneySound" withExtension:@"wav"];
    error = nil;
    _moneySound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (!_moneySound) {
        NSLog(@"Error creating player(money): %@",error);
    }
    
    soundUrl = [[NSBundle mainBundle] URLForResource:@"labSound" withExtension:@"wav"];
    error = nil;
    _labSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (!_labSound) {
        NSLog(@"Error creating player(lab): %@",error);
    }
    
    soundUrl = [[NSBundle mainBundle] URLForResource:@"dangerBeep" withExtension:@"wav"];
    error = nil;
    _dangerSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (!_dangerSound) {
        NSLog(@"Error creating player(danger): %@",error);
    }
    
    soundUrl = [[NSBundle mainBundle] URLForResource:@"sirenSound" withExtension:@"wav"];
    error = nil;
    _dangerAlertSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (!_dangerAlertSound) {
        NSLog(@"Error creating player(dangerAlert): %@",error);
    }
    
    soundUrl = [[NSBundle mainBundle] URLForResource:@"errorSound" withExtension:@"wav"];
    error = nil;
    _errorAlertSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (!_errorAlertSound) {
        NSLog(@"Error creating player(errorAlert): %@",error);
    }
    
    soundUrl = [[NSBundle mainBundle] URLForResource:@"boostSound" withExtension:@"wav"];
    error = nil;
    _boostFreezerSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (!_boostFreezerSound) {
        NSLog(@"Error creating player(boostFreezer): %@",error);
    }
    
    soundUrl = [[NSBundle mainBundle] URLForResource:@"cookingPotSound" withExtension:@"wav"];
    error = nil;
    _cookingPotSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (!_cookingPotSound) {
        NSLog(@"Error creating player(cookingPot): %@",error);
    }
    
    soundUrl = [[NSBundle mainBundle] URLForResource:@"mixingSound" withExtension:@"wav"];
    error = nil;
    _mixingSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (!_mixingSound) {
        NSLog(@"Error creating player(mixing): %@",error);
    }
    
    soundUrl = [[NSBundle mainBundle] URLForResource:@"backgroundSound" withExtension:@"mp3"];//"Carefree" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 http://creativecommons.org/licenses/by/3.0/
    error = nil;
    _backgroundSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if (!_backgroundSound) {
        NSLog(@"Error creating player(background): %@",error);
    }
}

/*
 1-sonido puerta
 2-sonido contracts
 3-sonido freezer
 4-sonido shop
 5-sonido money
 6-sonido lab
 7-sonido danger
 8-sonido danger alert
 9-sonido error alert
 10-sonido boost freezer
 11-sonido cooking pot
 12-sonido mixing
*/

- (void)playSound:(int)whichSound
{
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"soundOnOrOff"]==0)
    {
        if (whichSound==1)
        {
            _puertaSound.volume = [_puertaSound play];
        }
        else if (whichSound==2)
        {
            _contractsSound.volume = [_contractsSound play];
        }
        else if (whichSound==3)
        {
            _freezerSound.volume = [_freezerSound play];
        }
        else if (whichSound==4)
        {
            _shopSound.volume = [_shopSound play];
        }
        else if (whichSound==5)
        {
            _moneySound.volume = [_moneySound play];
        }
        else if (whichSound==6)
        {
            _labSound.volume = [_labSound play];
        }
        else if (whichSound==7)
        {
            _dangerSound.volume = [_dangerSound play];
        }
        else if (whichSound==8)
        {
            _dangerAlertSound.volume = [_dangerAlertSound play];
        }
        else if (whichSound==9)
        {
            _errorAlertSound.volume = [_errorAlertSound play];
        }
        else if (whichSound==10)
        {
            _boostFreezerSound.volume = [_boostFreezerSound play];
        }
        else if (whichSound==11)
        {
            _cookingPotSound.volume = [_cookingPotSound play];
        }
        else if (whichSound==12)
        {
            _mixingSound.volume = [_mixingSound play];
        }
    }
}

- (void)playBackground
{
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"soundOnOrOff"]==0)
    {
        _backgroundSound.volume =[_backgroundSound play];
        _backgroundSound.numberOfLoops=-1;
    }
}

- (void)stopBackground
{
    [_backgroundSound stop];
}

- (void)stopSound:(int)whichSound
{
    if (whichSound==11) {
        [_cookingPotSound stop];
    }
    else if (whichSound==12) {
        [_mixingSound stop];
    }
}

@end