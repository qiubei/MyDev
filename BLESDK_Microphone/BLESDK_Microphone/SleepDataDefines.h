//
//  SleepDataDefines.h
//  BLESDK_Microphone
//
//  Created by Anonymous on 2018/7/23.
//  Copyright © 2018年 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 晚睡闹钟设置
 */
typedef struct AlarmSet {
    BOOL alarmPeriodFlag;
    double alarmPeriodLen;
} AlarmSet;

/**
 OC 类： 麦克风实时分析结果
 */
@interface NPMicAnalyzedProcessData: NSObject

@property (nonatomic, assign, readwrite) long timestamp;
@property (nonatomic, assign, readwrite) double noiseLv;
@property (nonatomic, assign, readwrite) BOOL snoreFlag;
@property (nonatomic, assign, readwrite) BOOL dayDreamFlag;
@property (nonatomic, assign, readwrite) Byte soundControl;
@property (nonatomic, assign, readwrite) BOOL alarm;
@property (nonatomic, assign, readwrite) double movementEn;
@property (nonatomic, assign, readwrite) double movementFreq;
@property (nonatomic, strong, readwrite) NSArray<NSNumber *> *snoreRecData;
@property (nonatomic, strong, readwrite) NSArray<NSNumber *> *daydreamRecData;

@end


/**
 OC 类：小睡算法实时分析结果
 */
@interface NPNapAnalyzedProcessData: NSObject

@property (nonatomic, assign, readwrite) long timestamp;
@property (nonatomic, assign, readwrite) Byte dataQuality;
@property (nonatomic, assign, readwrite) Byte soundControl;
@property (nonatomic, assign, readwrite) Byte sleepState;

@end


/**
 OC 类：晚睡算法的综合结果
 */
@interface NPSleepFinishResult : NSObject

@property (nonatomic, assign, readwrite) Byte score;
@property (nonatomic, assign, readwrite) int soberLen;
@property (nonatomic, assign, readwrite) int lightSleepLen;
@property (nonatomic, assign, readwrite) int deepSleepLen;
@property (nonatomic, assign, readwrite) int latencyLen;
@property (nonatomic, assign, readwrite) int sleepLen;
@property (nonatomic, assign, readwrite) int sleepPoint;
@property (nonatomic, assign, readwrite) int alarmPoint;
@property (nonatomic, assign, readwrite) int detectQuality;
@property (nonatomic, retain, readwrite) NSData *sleepCurveCom;
@property (nonatomic, retain, readwrite) NSData *sleepNoiseCom;
@property (nonatomic, retain, readwrite) NSData *sleepSnoreCom;
@property (nonatomic, retain, readwrite) NSData *sleepDaydreamCom;
@end

typedef void(^NPSleepMicProcessDataBlock)(NPMicAnalyzedProcessData *data);
typedef void(^NPSleepMicFinishBlock)(NPSleepFinishResult *reportData);

NS_ASSUME_NONNULL_END
