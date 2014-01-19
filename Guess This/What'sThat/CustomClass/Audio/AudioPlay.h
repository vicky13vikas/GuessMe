//
//  AudioPlay.h
//  What'sThat
//
//  Created by Vibhooti on 5/13/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlay : NSObject
{
    AVAudioPlayer *audioPlayer;
    NSString *strAudioFile;

}
@property(nonatomic,retain)AVAudioPlayer *audioPlayer;
@property(nonatomic,retain)NSString *strAudioFile;

-(void)playAudio;
-(void)stopAudio;
-(void)muteUnmuteAudio;

@end
