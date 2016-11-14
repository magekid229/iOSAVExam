//
//  TaskModule.m
//  TXRTMPSDK
//
//  Created by kuenzhang on 16/11/14.
//
//

#import "TaskModule.h"

typedef NS_ENUM(NSInteger, TaskModuleState) {
    TaskModuleStateStopped,
    TaskModuleStateRunning,
    TaskModuleStatePaused,
} __TaskModuleState;

@implementation TaskModule
{
    int     _taskStatus;
}

-(id)init
{
    self = [super init];
    
    if (self) {
        _taskStatus = TaskModuleStateStopped;
    }
    
    return self;
}

- (int)start
{
    if (_taskStatus == TaskModuleStateRunning) {
        return TaskModuleStateError;
    }
    _taskStatus = TaskModuleStateRunning;
    return [self startInternal];
}

- (int)pause
{
    if (_taskStatus != TaskModuleStateRunning) {
        return TaskModuleStateError;
    }
    _taskStatus = TaskModuleStatePaused;
    return [self pauseInternal];
}

- (int)resume
{
    if (_taskStatus != TaskModuleStatePaused) {
        return TaskModuleStateError;
    }
    _taskStatus = TaskModuleStateRunning;
    return [self resumeInternal];
}

- (int)stop
{
    if (_taskStatus == TaskModuleStateStopped) {
        return TaskModuleStateError;
    }
    _taskStatus = TaskModuleStateStopped;
    return [self stopInternal];
}


- (int)startInternal
{
    return TaskModuleRunSucess;
}

- (int)pauseInternal
{
    return TaskModuleRunSucess;
}

- (int)resumeInternal
{
    return TaskModuleRunSucess;
}

- (int)stopInternal
{
    return TaskModuleRunSucess;
}

@end
