//
//  AudioRecordTask.h
//  TXRTMPSDK
//
//  Created by kuenzhang on 16/11/14.
//
//
#import "TaskModule.h"

typedef NS_ENUM(NSInteger, AudioRecordErrorCode) {
    AudioRecordSucess = 0,
    AudioRecordOpenError = -11,
    AudioRecordPauseError = -12,
    AudioRecordResumeError = -13,
} _AudioRecordErrorCode;

@interface AudioRecordTask : TaskModule

- (instancetype)initWithChannel:(int)channel SampleRate:(int)sampleRate Bit:(int)bit;

@end
