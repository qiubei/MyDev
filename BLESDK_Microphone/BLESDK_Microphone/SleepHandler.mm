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
#include "Vendor/libAlgorithmSDK/include/src/sdk/sleep_v3/DataManager.h"

using namespace std;
using namespace EnterTech;
using namespace EnterTech::AlgorithmSDK;
using namespace EnterTech::AlgorithmSDK::SleepV3;

#define MicDataManager SleepV3::DataManager::getInstance()


static int SLEEP_TRIGGER_INTERVAL = 60;
static dispatch_queue_t micQueue = dispatch_queue_create("com.entertech.queue.algorithm.microphone", DISPATCH_QUEUE_SERIAL);

std::vector<AUDIO_DATA> encodeMicDataToAlgorithmData(NSData *datas);
std::vector<NPMicAnalyzedProcessData *>dumpAllWithTimestamp(std::vector<NPMicAnalyzedProcessData *> processDatas);

static std::vector<NPMicAnalyzedProcessData *> micAnalyzedVector;
static std::vector<NPNapAnalyzedProcessData *> napAnalyzedVector;
static std::vector<DATA> micTimestampVector;
static std::vector<DATA> micMovementEnVector;
static std::vector<DATA> micMovementFreqVector;
static std::vector<bool> micSnoreFlagVector;
static std::vector<bool> micDaydreamFlagVector;
static std::vector<DATA> micNoiseLevelStoreVector;

static std::vector<DATA> napTimestampVector;
static std::vector<SOUND_CONTROL_RAW> napSoundControlVector;
static std::vector<DATA_QUALITY> napDataQualityVector;
static std::vector<DATA> napSleepStatusVector;


@implementation SleepHandler

+ (NSString *)version {
    std::string version = SleepV3::SLEEP_VERSION;
    NSString *vs = [NSString stringWithUTF8String:version.c_str()];
    return vs;
}

+ (void)start {
    MicDataManager.init();
    [self clearVector];

}

+ (void)setMusic: (bool) flag {
    MicDataManager.setMusicFlag(flag);
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
            analyzedData.soundControl = UInt8(micResult.soundControl);
            analyzedData.alarm = micResult.alarm;
            analyzedData.movementEn = micResult.movementEn;
            analyzedData.movementFreq = micResult.movementFreq;
            vector<NSNumber *> tempSnoreRecData;
            vector<NSNumber *> tempDaydreamRecData;
            for(int i = 0; i < micResult.snoreRecData.size(); i++) {
                float algorithmValue = micResult.snoreRecData[i];
                int16_t pcmValue = int16_t(algorithmValue);
                NSNumber *value = [NSNumber numberWithInt: pcmValue];
                tempSnoreRecData.push_back(value);
            }
            for(int j = 0; j < micResult.daydreamRecData.size(); j++) {
                float algorithmValue = micResult.daydreamRecData[j];
                int16_t pcmValue = int16_t(algorithmValue);
                NSNumber *value = [NSNumber numberWithInt: pcmValue];
                tempDaydreamRecData.push_back(value);
            }
            analyzedData.snoreRecData = [NSArray arrayWithObjects:&tempSnoreRecData[0]
                                                            count:micResult.snoreRecData.size()];
            analyzedData.daydreamRecData = [NSArray arrayWithObjects:&tempDaydreamRecData[0]
                                                               count:micResult.daydreamRecData.size()];
            process(analyzedData);
            micAnalyzedVector.push_back(analyzedData);
            tempSnoreRecData.clear();
            tempDaydreamRecData.clear();
        }
    });
}

+ (void)finish:(NSArray *)napAnalyzedList block:(NPSleepMicFinishBlock)block {
    dispatch_async(micQueue, ^{
        for(int i = 0; i < napAnalyzedList.count; i++){
            NPNapAnalyzedProcessData *iterm = napAnalyzedList[i];
            int timestamp = int(iterm.timestamp);
            napTimestampVector.push_back(DATA(timestamp));
            napSoundControlVector.push_back(SOUND_CONTROL_RAW([iterm soundControl]));
            napDataQualityVector.push_back(DATA_QUALITY([iterm dataQuality]));
            napSleepStatusVector.push_back([iterm sleepState]);
        }

        for(int i = 0; i < micAnalyzedVector.size(); i++) {
            micTimestampVector.push_back(DATA(micAnalyzedVector.at(i).timestamp));
            micMovementEnVector.push_back(micAnalyzedVector.at(i).movementEn);
            micMovementFreqVector.push_back(micAnalyzedVector.at(i).movementFreq);
            micSnoreFlagVector.push_back(micAnalyzedVector.at(i).snoreFlag);
            micDaydreamFlagVector.push_back(micAnalyzedVector.at(i).dayDreamFlag);
            micNoiseLevelStoreVector.push_back(micAnalyzedVector.at(i).noiseLv);
        }

        if (block) {
            if (micAnalyzedVector.size() > 0) {
                SleepV3::FinishDataPackPlus finishResult = MicDataManager.finish(napSoundControlVector,
                                                                                 napDataQualityVector,
                                                                                 napSleepStatusVector,
                                                                                 micMovementEnVector,
                                                                                 micMovementFreqVector,
                                                                                 micSnoreFlagVector,
                                                                                 micDaydreamFlagVector,
                                                                                 micTimestampVector,
                                                                                 napTimestampVector,
                                                                                 micNoiseLevelStoreVector);
                NPSleepFinishResult *result = [[NPSleepFinishResult alloc] init];
                result.score = (Byte)finishResult.finishDataPack.score;
                result.soberLen = (int)finishResult.finishDataPack.soberLen;
                result.lightSleepLen = (int)finishResult.finishDataPack.lightSleepLen;
                result.deepSleepLen = (int)finishResult.finishDataPack.deepSleepLen;
                result.latencyLen = (int)finishResult.finishDataPack.latencyLen;
                result.sleepLen = (int)finishResult.finishDataPack.sleepLen;
                result.sleepPoint = (int)finishResult.sleepPoint;
                result.alarmPoint = (int)finishResult.alarmPoint;
                result.detectQuality = (int)finishResult.detectQuality;

                // 不能直接转成 Data，finishResult.sleepCurveCom 是 double 型的
                std::vector<Byte> tempSleepCurveVector;
                for (int i = 0; i < finishResult.sleepCurveCom.size(); i++) {
                    tempSleepCurveVector.push_back(Byte(finishResult.sleepCurveCom[i]));
                }
                result.sleepCurveCom = [NSData dataWithBytes:tempSleepCurveVector.data()
                                                      length:finishResult.sleepCurveCom.size()];
                tempSleepCurveVector.clear();

                // 拿到完整的连续分析后数据数组（体验过程由于某种情况有段时间不触发算法导致数据不连续）
                std::vector<NPMicAnalyzedProcessData *> processDatas = dumpAllWithTimestamp(micAnalyzedVector);
                std::vector<Byte> tempSnoreVector;
                std::vector<Byte> tempDayDreamVector;
                std::vector<Byte> tempNoiseVector;
                for(int i = 0; i < processDatas.size(); i++) {
                    tempSnoreVector.push_back(Byte(processDatas[i].snoreFlag));
                    tempDayDreamVector.push_back(Byte(processDatas[i].dayDreamFlag));
                    tempNoiseVector.push_back(Byte(processDatas[i].noiseLv));
                }
                result.sleepSnoreCom = [NSData dataWithBytes:tempSnoreVector.data() length:tempSnoreVector.size()];
                result.sleepDaydreamCom = [NSData dataWithBytes:tempDayDreamVector.data() length:tempDayDreamVector.size()];
                result.sleepNoiseCom = [NSData dataWithBytes:tempNoiseVector.data() length:tempNoiseVector.size()];
                tempNoiseVector.clear();
                tempSnoreVector.clear();
                tempSnoreVector.clear();
                processDatas.clear();
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
    micNoiseLevelStoreVector.clear();
}

@end

/* Dump all serial data with NPMicAnalyzedProcessData arrays;
 * for adopting the format in report protocol,
 * like the `timestamp` scalaradd  is 60.
 */
std::vector<NPMicAnalyzedProcessData *>dumpAllWithTimestamp(std::vector<NPMicAnalyzedProcessData *> processDatas){
    std::vector<NPMicAnalyzedProcessData *> array;
    for(int i = 0; i < processDatas.size(); i++) {
        NPMicAnalyzedProcessData *current = processDatas[i];
        array.push_back(current);
        if((i+1) < processDatas.size() && (processDatas[i+1].timestamp - current.timestamp) > SLEEP_TRIGGER_INTERVAL) {
            NPMicAnalyzedProcessData *next = processDatas[i+1];
            int interval = int(next.timestamp - current.timestamp) / SLEEP_TRIGGER_INTERVAL;
            for(int j = 1; j < interval; j++) {
                NPMicAnalyzedProcessData *defalutValue = [[NPMicAnalyzedProcessData alloc] init];
                defalutValue.timestamp = int(current.timestamp) + SLEEP_TRIGGER_INTERVAL*j;
                defalutValue.noiseLv = current.noiseLv;
                defalutValue.snoreFlag = false;
                defalutValue.dayDreamFlag = false;
                defalutValue.alarm = current.alarm;
                defalutValue.movementEn = current.movementEn;
                defalutValue.movementFreq = current.movementFreq;
                array.push_back(defalutValue);
            }
        }
    }
    return array;
}

std::vector<AUDIO_DATA> encodeMicDataToAlgorithmData(NSData *datas) {
    std::vector<AUDIO_DATA> values;
    Byte *bytes = (Byte *)datas.bytes;
    for(int i = 0; i < datas.length; i += 1) {
        if((i % 2) == 0 && ((i + 1) < datas.length)) {
            float value = float(bytes[i]) + float(int(bytes[i+1])<<8);
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
