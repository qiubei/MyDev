//
//  SleepHandler.hpp
//  BLESDK_Microphone
//
//  Created by Anonymous on 2018/7/23.
//  /Users/zhy/Desktop/GitRepository/BLESDK_Microphone/BLESDK_Microphone/SleepHandler.hppCopyright © 2018年 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SleepDataDefines.h"

@interface SleepHandler : NSObject

/**
 算法版本号

 @return 算法版本 3 段式，每段以点隔开
 */
+ (NSString *)version;

/**
 开启算法
 */
+ (void)start;

+ (void)setMusic: (bool) flag;

/**
 向算法输入智能闹钟参数

 @param clockSet 结构体智能闹钟参数（1. 是否在闹钟区间 2. 闹钟区间长度）
 */
+ (void)setAlarm:(AlarmSet *)clockSet;


/**
 向算法输入 1 分钟的麦克风数据,通过回调返回算法的实时分析结果

 @param data 1 分钟麦克风数据
 @param process 算法实时分析结果回调
 */
+ (void)appendMicData: (NSData *)data processData: (NPSleepMicProcessDataBlock)process;


/**
 晚睡结束

 @param napAnalyzedList 小睡算法实时分析结果列表
 @param block 晚睡结果回调
 */
+ (void)finish:(NSArray *)napAnalyzedList block:(NPSleepMicFinishBlock)block;

@end
