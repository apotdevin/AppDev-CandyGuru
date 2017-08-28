//
//  SoundHelper.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 8/31/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundHelper : NSObject

@property (strong, nonatomic)  AVAudioPlayer * puertaSound;
@property (strong, nonatomic)  AVAudioPlayer * contractsSound;
@property (strong, nonatomic)  AVAudioPlayer * freezerSound;
@property (strong, nonatomic)  AVAudioPlayer * shopSound;
@property (strong, nonatomic)  AVAudioPlayer * moneySound;
@property (strong, nonatomic)  AVAudioPlayer * labSound;
@property (strong, nonatomic)  AVAudioPlayer * dangerSound;
@property (strong, nonatomic)  AVAudioPlayer * dangerAlertSound;
@property (strong, nonatomic)  AVAudioPlayer * errorAlertSound;
@property (strong, nonatomic)  AVAudioPlayer * boostFreezerSound;
@property (strong, nonatomic)  AVAudioPlayer * cookingPotSound;
@property (strong, nonatomic)  AVAudioPlayer * mixingSound;
@property (strong, nonatomic)  AVAudioPlayer * backgroundSound;

+(instancetype)sharedSoundInstance;
-(void)startSoundSession;
-(void)playSound:(int)whichSound;
-(void)stopSound:(int)whichSound;
-(void)playBackground;
-(void)stopBackground;

@end
