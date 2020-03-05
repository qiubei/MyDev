# Microphone
~~~
//
//  SleepHandler.cpp
//  BLESDK_Microphone
//
//  Created by Anonymous on 2018/7/23.
//  Copyright © 2018年 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

#import "SleepHandler.h"
#import "SleepDataDefines.h"
#import <libkern/OSAtomic.h>
#import <objc/objc.h>
#include "Vendor/libAlgorithmSDK/include/src/sdk/nap_v3/DataManager.h"
#include "Vendor/libAlgorithmSDK/include/src/sdk/sleep_v3/DataManager.h"

using namespace std;
using namespace EnterTech;
using namespace EnterTech::AlgorithmSDK;
using namespace EnterTech::AlgorithmSDK::SleepV3;
using namespace EnterTech::AlgorithmSDK::NapV3;

#define MicDataManager SleepV3::DataManager::getInstance()


static dispatch_queue_t micQueue = dispatch_queue_create("com.entertech.queue.algorithm.microphone", DISPATCH_QUEUE_SERIAL);

std::vector<AUDIO_DATA> encodeMicDataToAlgorithmData(NSData *datas);

static std::vector<NPMicAnalyzedProcessData *> micAnalyzedVector;
static std::vector<NPNapAnalyzedProcessData *> napAnalyzedVector;
static std::vector<DATA> micTimestampVector;
static std::vector<DATA> micMovementEnVector;
static std::vector<DATA> micMovementFreqVector;
static std::vector<bool> micSnoreFlagVector;
static std::vector<bool> micDaydreamFlagVector;

static std::vector<DATA> napTimestampVector;
static std::vector<SOUND_CONTROL> napSoundControlVector;
static std::vector<DATA_QUALITY> napDataQualityVector;
static std::vector<DATA> napSleepStatusVector;


@implementation SleepHandler

+ (NSString *)version {
    std::string version = "0.0.1";
    NSString *vs = [NSString stringWithUTF8String:version.c_str()];
    return vs;
}

+ (void)start {
    MicDataManager.init();
    [self clearVector];

}

+ (void)setAlarm:(AlarmSet *)alarmSet {
    SleepV3::ClockSet clockSet;
    clockSet.alarmPeriodFlag = alarmSet->alarmPeriodFlag;
    clockSet.alarmPeriodLen = alarmSet->alarmPeriodLen;
    MicDataManager.setClock(clockSet);
}


+ (void)appendMicData:(NSData *)data processData:(nonnull NPSleepMicProcessDataBlock)process {
    dispatch_async(micQueue, ^{
        std::vector<AUDIO_DATA> audioData = encodeMicDataToAlgorithmData(data);
        if(MicDataManager.appendMicData(audioData)) {
            SleepV3::MicResult micResult = MicDataManager.getMicResult();
            NPMicAnalyzedProcessData *analyzedData = [[NPMicAnalyzedProcessData alloc] init];
            NSDate *date = [[NSDate alloc] init];
            double timestamp = date.timeIntervalSince1970;
            printf("mic analyzed data %f", timestamp);
            analyzedData.timestamp = int(timestamp);
            analyzedData.noiseLv = micResult.noiseLv;
            analyzedData.snoreFlag = micResult.snoreFlag;
            analyzedData.dayDreamFlag = micResult.daydreamFlag;
            analyzedData.alarm = micResult.alarm;
            analyzedData.movementEn = micResult.movementEn;
            analyzedData.movementFreq = micResult.movementFreq;
            process(analyzedData);

            micAnalyzedVector.push_back(analyzedData);
        }
    });
}

+ (void)finish:(NSArray *)napAnalyzedList block:(NPSleepMicFinishBlock)block {
    dispatch_async(micQueue, ^{
        for(int i = 0; i < napAnalyzedList.count; i++){
            NPNapAnalyzedProcessData *iterm = napAnalyzedList[i];
            int timestamp = int(iterm.timestamp);
            napTimestampVector.push_back(DATA(timestamp));
            napSoundControlVector.push_back(SOUND_CONTROL([iterm soundControl]));
            napDataQualityVector.push_back(DATA_QUALITY([iterm dataQuality]));
            napSleepStatusVector.push_back([iterm sleepStatusMove]);
        }

        for(int i = 0; i < micAnalyzedVector.size(); i++) {
            micTimestampVector.push_back(DATA(micAnalyzedVector.at(i).timestamp));
            micMovementEnVector.push_back(micAnalyzedVector.at(i).movementEn);
            micMovementFreqVector.push_back(micAnalyzedVector.at(i).movementFreq);
            micSnoreFlagVector.push_back(micAnalyzedVector.at(i).snoreFlag);
            micDaydreamFlagVector.push_back(micAnalyzedVector.at(i).dayDreamFlag);
        }

        if (block) {
            if (micAnalyzedVector.size() > 0) {
                SleepV3::FinishDataPack finishResult = MicDataManager.finish(napSoundControlVector,
                                                                             napDataQualityVector,
                                                                             napSleepStatusVector,
                                                                             micMovementEnVector,
                                                                             micMovementFreqVector,
                                                                             micSnoreFlagVector,
                                                                             micDaydreamFlagVector,
                                                                             micTimestampVector,
                                                                             napTimestampVector);
                NPSleepFinishResult *result = [[NPSleepFinishResult alloc] init];
                result.score = (Byte)finishResult.score;
                result.soberLen = (int)finishResult.soberLen;
                result.lightSleepLen = (int)finishResult.lightSleepLen;
                result.deepSleepLen = (int)finishResult.deepSleepLen;
                result.latencyLen = (int)finishResult.latencyLen;
                result.sleepLen = (int)finishResult.sleepLen;
//                result.sleepCurveCom = [NSData dataWithBytes:finishResult.sleepCurveCom.data() length:finishResult.sleepCurveCom.size()];
//                result.sleepClassCom = [NSData dataWithBytes:finishResult.sleepClassCom.data() length:finishResult.sleepClassCom.size()];
                block(result);
            }
            [self clearVector];
        }
    });
}

// private

+ (void)clearVector {
    napAnalyzedVector.clear();
    napTimestampVector.clear();
    napSoundControlVector.clear();
    napDataQualityVector.clear();
    napSleepStatusVector.clear();

    micAnalyzedVector.clear();
    micTimestampVector.clear();
    micMovementEnVector.clear();
    micMovementFreqVector.clear();
    micSnoreFlagVector.clear();
    micDaydreamFlagVector.clear();
}

@end

std::vector<AUDIO_DATA> encodeMicDataToAlgorithmData(NSData *datas) {
    std::vector<AUDIO_DATA> values;
    Byte *bytes = (Byte *)datas.bytes;
    for(int i = 0; i < datas.length; i += 1) {
        if((i % 2) == 0 && ((i + 1) < datas.length)) {
            float value = bytes[i] + (bytes[i+1]<<8);
            float tempValue;
            if(value >= (1<<15)) {
                tempValue = -((1<<16) - value) / (1<<15);
            } else {
                tempValue = value / (1<<15);
            }
            values.push_back(tempValue);
        }
    }
    return values;
}
~~~



