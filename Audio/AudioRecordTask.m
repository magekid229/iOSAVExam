#import "AudioRecordTask.h"
#include <AudioToolbox/AudioToolbox.h>
#include <AVFoundation/AVAudioSession.h>

void AudioRecordInputBufferHandler(
                                   void * __nullable               inUserData,
                                   AudioQueueRef                   inAQ,
                                   AudioQueueBufferRef             inBuffer,
                                   const AudioTimeStamp *          inStartTime,
                                   UInt32                          inNumberPacketDescriptions,
                                   const AudioStreamPacketDescription * __nullable inPacketDescs)
{
//    TXAudioRecorder *aqr = (TXAudioRecorder *)inUserData;
//    
//    if (inBuffer->mAudioDataByteSize > 0)
//    {
//        aqr->OnSendRecordData((unsigned char*)(inBuffer->mAudioData), inBuffer->mAudioDataByteSize);
//    }
//    
//    // if we're not stopping, re-enqueue the buffe so that it gets filled again
//    if (aqr->IsRunning())
//    {
//        OSStatus err = AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
//        if (err) {
//            LOGE("AudioQueueEnqueueBuffer failed. With error:%ld",(signed long)err);
//        }
//    }
}


@implementation AudioRecordTask
{
    AudioStreamBasicDescription	_recordFormat;
    AudioQueueRef				_audioQueue;
}

- (instancetype)initWithChannel:(int)channel SampleRate:(int)sampleRate Bit:(int)bit
{
    self = [super init];
    
    if (self) {
        memset(&_recordFormat, 0, sizeof(_recordFormat));
        _recordFormat.mFormatID = kAudioFormatLinearPCM;
        _recordFormat.mSampleRate = sampleRate;
        _recordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        _recordFormat.mBitsPerChannel = bit;
        _recordFormat.mChannelsPerFrame = channel;
        _recordFormat.mFramesPerPacket = 1;
        _recordFormat.mBytesPerFrame = (_recordFormat.mBitsPerChannel/8) * _recordFormat.mChannelsPerFrame;
        _recordFormat.mBytesPerPacket =  _recordFormat.mBytesPerFrame;
        
        _audioQueue = nil;

    }
    
    return self;
}

- (int)startInternal
{
    if (_audioQueue)
    {
        AudioQueueDispose(_audioQueue, YES);
        _audioQueue = nil;
    }
    
    OSStatus err = AudioQueueNewInput(
                                      &_recordFormat,
                                      AudioRecordInputBufferHandler,
                                      (__bridge void *)self/* userData */,
                                      NULL /* run loop */, NULL /* run loop mode */,
                                      0 /* flags */, &_audioQueue);
    if (err) {
        NSLog(@"AudioQueueNewInput failed. With error:%ld",(signed long)err);
        return AudioRecordOpenError;
    }
    
    return [self resumeInternal];
}

- (int)pauseInternal
{
    OSStatus err = AudioQueuePause(_audioQueue);
    if (err) {
        NSLog(@"AudioQueuePause failed. With error:%ld",(signed long)err);
        return AudioRecordPauseError;
    }
    
    return TaskModuleRunSucess;
}

- (int)resumeInternal
{
    OSStatus err1 = AudioQueueStart(_audioQueue, NULL);
    if (err1) {
        NSLog(@"AudioQueueStart failed. With error:%ld",(signed long)err1);
        return AudioRecordOpenError;
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error]) {
        NSLog(@"setCategory failed");
    }
    if (![session setMode:AVAudioSessionModeVideoRecording error:&error]) {
        NSLog(@"setMode failed");
    }
    
    if (![session setPreferredIOBufferDuration:1024.0f/(float)_recordFormat.mSampleRate error:&error]) {
        NSLog(@"setPreferredIOBufferDuration failed");
    }
    
    [session setActive:YES error:nil];
    
    return TaskModuleRunSucess;
}

- (int)stopInternal
{
    if (_audioQueue) {
        OSStatus err = AudioQueueStop(_audioQueue, true);
        if (err) {
            NSLog(@"AudioQueueStop failed. With error:%ld",(signed long)err);
        }
        AudioQueueDispose(_audioQueue, TRUE);
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    }
    return TaskModuleRunSucess;
}

@end
