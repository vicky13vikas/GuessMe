//
//  AudioPlay.m
//  What'sThat
//
//  Created by Vibhooti on 5/13/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "AudioPlay.h"

@implementation AudioPlay

@synthesize audioPlayer;
@synthesize strAudioFile;


-(void)playAudio
{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],strAudioFile]];
	
	NSError *error;//
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if ([strAudioFile isEqualToString:@"playStart.wav"])
    {
      audioPlayer.numberOfLoops = -1;
    }
    else
    {
        audioPlayer.numberOfLoops = 0;
    }
//    [self muteUnmuteAudio];
	
    if (audioPlayer == nil)
    {
        
    }
	else
    {
		[audioPlayer play];
    }
}

-(void)stopAudio
{
    [audioPlayer stop];
}

-(void)muteUnmuteAudio
{
/*    BOOL isMute = [[NSUserDefaults standardUserDefaults]boolForKey:USERDEFAULTS_ISMUTE];
    if (isMute) 
    {
         audioPlayer.volume = 0;
    }
    else
    {
        audioPlayer.volume = 1;
    }*/
    
}

@end
