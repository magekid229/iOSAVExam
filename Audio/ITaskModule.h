//
//  ITaskModule.h
//  TXRTMPSDK
//
//  Created by kuenzhang on 16/11/14.
//
//

typedef NS_ENUM(NSInteger, TaskModuleErrorCode) {
    TaskModuleStateError = -1,
    TaskModuleRunSucess = 0
} _TaskModuleErrorCode;

@protocol ITaskModule

- (int)start;

- (int)stop;

- (int)pause;

- (int)resume;

@end
