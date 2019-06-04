//
//  AlgorithmHandler.m
//  BLESDK-Nap
//
//  Created by HyanCat on 2018/6/1.
//  Copyright © 2018 EnterTech. All rights reserved.
//

#import "AlgorithmHandler.h"
#import <libkern/OSAtomic.h>
#include "Vendor/libAlgorithmSDK/include/src/sdk/nap_v3/DataManager.h"
#import <objc/objc.h>

using namespace EnterTech;
using namespace EnterTech::AlgorithmSDK;
using namespace EnterTech::AlgorithmSDK::NapV3;

#define DataManager DataManager::getInstance()
#define NapHandler  NapManager::getInstance().getHandler()
#define BamHandler  EEGMusicManager::getInstance().getHandler()

static std::vector<DATA> mlpDegreeVector;   // 神经网络值，每 2 秒一个值
static std::vector<SLEEP_STATE> sleepStatusVector;  // 睡眠状态，每 2 秒一个值
static std::vector<SOUND_CONTROL> soundControlMoveVector;   // 音量控制，每 2 秒一个值
static std::vector<DATA_QUALITY> dataQualityVector;    // 数据质量，每 2 秒一个值

static dispatch_queue_t queue = dispatch_queue_create("com.entertech.queue.algorithm", DISPATCH_QUEUE_SERIAL);

std::vector<NSUInteger> decodeRawDataToValues(NSData *data);

@implementation AlgorithmHandler

+ (NSString *)version
{
    std::string version = NAP_V3_VERSION;

    return [NSString stringWithCString:version.c_str() encoding:NSUTF8StringEncoding];
}

+ (void)start
{
//    __resetBuffer();

    DataManager.init("mlp.json");

    mlpDegreeVector.clear();
    sleepStatusVector.clear();
    soundControlMoveVector.clear();
    dataQualityVector.clear();
}

+ (void)pushRawData:(NSData *)rawData handleProcess:(NPAlgorithmProcessBlock)handleProcess
{
    dispatch_async(queue, ^() {
        std::vector<NSUInteger> values = decodeRawDataToValues(rawData);
        for (auto it = values.cbegin(); it != values.cend(); it++) {
            TriggerState trigged = DataManager.appendRawData((RAW_DATA)*it);
            if (trigged.commonTriggered) {
                [self pushToAlgorithmIfHandleProcess:handleProcess];
            }
        }
    });
}

+ (void)pushToAlgorithmIfHandleProcess:(NPAlgorithmProcessBlock)handleProcess
{
    if (!handleProcess) { return; }

    CommonResult dataPack = DataManager.getCommonResult();

    // 记录体验中数据
    mlpDegreeVector.push_back(dataPack.mlpDegree);
    sleepStatusVector.push_back(dataPack.sleepState);
    soundControlMoveVector.push_back(dataPack.soundControl);
    dataQualityVector.push_back(dataPack.dataQuality);

    // 构造数据并返回上层
    NPAnalyzeProcessData *data = [[NPAnalyzeProcessData alloc] init];
    data.mlpDegree     = dataPack.mlpDegree;
    data.napDegree     = dataPack.napDegree;
    data.dataQuality   = (Byte)dataPack.dataQuality;
    data.soundControl  = (Byte)dataPack.soundControl;
    data.sleepState    = (Byte)dataPack.sleepState;
    data.smoothRawData = [NSData dataWithBytes:dataPack.smoothRawData.data()
                                        length:dataPack.smoothRawData.size()];

    handleProcess(data);

    // 重置一下音量操作数
    DataManager.setManualOperated(0);
}

+ (void)operateVolume:(float)volume
{
    dispatch_async(queue, ^() {
        DataManager.setManualOperated(volume);
    });
}

+ (void)finishWithResult:(NPAlgorithmResultBlock)handleResult
{
    dispatch_sync(queue, ^() {
        DataManager.finish(soundControlMoveVector,
                           sleepStatusVector,
                           mlpDegreeVector,
                           dataQualityVector);
        mlpDegreeVector.clear();
        sleepStatusVector.clear();
        soundControlMoveVector.clear();
        dataQualityVector.clear();
        if (handleResult) {
            handleResult([self handleResult]);
        }
    });
}

//+ (void)calculateSleepState:(NSData *)analyzedData handleResult:(NPAlgorithmResultBlock)handleResult
//{
//    DataManager.init("mlp.json");
//    dispatch_sync(queue, ^{
//        NSInteger length = analyzedData.length;
//        std::vector<DATA> restStatusTemp;
//        restStatusTemp.reserve(length/8);
//        std::vector<DATA_QUALITY> dataQualityTemp;
//        dataQualityTemp.reserve(length/8);
//        std::vector<SOUND_CONTROL> soundControlTemp;
//        soundControlTemp.reserve(length/8);
//        std::vector<SLEEP_STATE> sleepStatusTemp;
//        sleepStatusTemp.reserve(length/8);
//
//        Byte *bytes = (Byte *)malloc(analyzedData.length/sizeof(Byte));
//        [analyzedData getBytes:bytes length:analyzedData.length];
//        for (int i = 0; i < length-7; i+=8) {
//            soundControlTemp.push_back((SOUND_CONTROL)bytes[i+1]);
//            sleepStatusTemp.push_back((SLEEP_STATE)bytes[i+2]);
//            dataQualityTemp.push_back((DATA_QUALITY)bytes[i+3]);
//            restStatusTemp.push_back((DATA)bytes[i+4]);
//        }
//        free(bytes);
//
//        DataManager.finish(soundControlMoveVector,
//                           sleepStatusVector,
//                           mlpDegreeVector,
//                           dataQualityVector);
//
//        restStatusTemp.clear();
//        sleepStatusTemp.clear();
//        soundControlTemp.clear();
//        sleepStatusTemp.clear();
//        if (handleResult) {
//            handleResult([self handleResult]);
//        }
//    });
//}

+ (NPFinishedResult *)handleResult
{
    FinishResult finishDataPack = DataManager.getFinishResult();

    NPFinishedResult *result = [[NPFinishedResult alloc] init];
    result.sleepScore = finishDataPack.napScore;
    result.sleepLatency = finishDataPack.sleepLatency;
    result.soberDuration = finishDataPack.soberDuration;
    result.blurrDuration = finishDataPack.blurDuration;
    result.sleepDuration = finishDataPack.sleepDuration;
    result.sleepPoint = (Byte)finishDataPack.sleepPoint;
    result.alarmPoint = (Byte)finishDataPack.alarmPoint;
    result.soberLevelPoint = (Byte)finishDataPack.napClassSober;
    result.blurrLevelPoint = (Byte)finishDataPack.napClassBlur;
    result.sleepLevelPoint = (Byte)finishDataPack.napClassSleep;

    {
        // 转成 NSData 并赋值
        result.sleepStateData = [NSData dataWithBytes:finishDataPack.napClass.data()
                                               length:finishDataPack.napClass.size()];

        result.sleepCurveData = [NSData dataWithBytes:finishDataPack.napCurve.data()
                                               length:finishDataPack.napCurve.size()];
    }
    return result;
}

@end


std::vector<NSUInteger> decodeRawDataToValues(NSData *data)
{
    std::vector<NSUInteger> values;
    Byte *bytes = (Byte *)data.bytes;
    NSUInteger count = data.length / 3;
    for (NSUInteger i = 0; i < count; i += 1) {
        NSUInteger value = (bytes[i*3] << 16) + (bytes[i*3+1] << 8) + bytes[i*3+2];
        values.push_back(value);
    }
    return values;
}

//int __bufferSize() {
//    return 250;
//}

//void __resetBuffer() {
//    _rawDataBuffer.clear();
//    _rawDataBuffer.reserve(__bufferSize());
//}
