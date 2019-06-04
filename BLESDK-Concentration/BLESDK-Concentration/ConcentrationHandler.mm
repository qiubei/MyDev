//
//  ConcentrationHandler.m
//  BLESDK-Concentration
//
//  Created by HyanCat on 2018/5/14.
//  Copyright © 2018 EnterTech. All rights reserved.
//

#import "ConcentrationHandler.h"
#import "ConcentrationData.h"
#include "./Vendor/libAlgorithmSDK/include/src/sdk/concentration_v3/DataManager.h"

using namespace EnterTech::AlgorithmSDK::ConcentrationV3;
using namespace EnterTech;

template <typename T>
std::vector<T> __decodeRawDataToValues(NSData *data);

template <typename T>
Array __vectorToArray(std::vector<T> vector);

@implementation ConcentrationHandler

+ (instancetype)shared
{
    static ConcentrationHandler *handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [ConcentrationHandler new];
    });
    return handler;
}

+ (void)start
{
    DataManager::getInstance().init();
}

+ (void)pushRawData:(NSData *)rawData handleBlink:(ConcentrationBlinkBlock)handleBlink handleData:(ConcentrationDataBlock)handleData
{
    [[ConcentrationHandler shared] pushRawData:rawData handleBlink:handleBlink handleData:handleData];
}

- (void)pushRawData:(NSData *)rawData handleBlink:(ConcentrationBlinkBlock)handleBlink handleData:(ConcentrationDataBlock)handleData
{
    std::vector<DATA> values = __decodeRawDataToValues<DATA>(rawData);
    TriggerState trigger = DataManager::getInstance().appendRawData(values);

    // 200ms
    if (trigger.tinyTriggered) {
        TinyResult tinyRes = DataManager::getInstance().getTinyResult();
        BLINK_STATUS blinkStatus = tinyRes.blinkStatus;
        handleBlink(blinkStatus == BLINK_STATUS::BLINK);
    }

    // 400ms
    if (trigger.commonTriggered) {
        ConcentrationData *concentrationData = [ConcentrationData new];
        CommonResult commonRes = DataManager::getInstance().getCommonResult();

        concentrationData.dataQuality = (DataQuality)commonRes.dataQuality;
        concentrationData.concentration = (uint8_t)commonRes.concentration;
        concentrationData.relax = (uint8_t)commonRes.relax;

        std::vector<RAW_DATA> smoothRawData = commonRes.smoothRawData;
        concentrationData.smoothData = __vectorToArray(smoothRawData);

        std::vector<DATA> spectrum = commonRes.spectrum;
        concentrationData.spectrum = __vectorToArray(spectrum);

        handleData(concentrationData);
    }
}

@end


template <typename T>
std::vector<T> __decodeRawDataToValues(NSData *data)
{
    std::vector<T> values;
    Byte *bytes = (Byte *)data.bytes;
    NSUInteger count = data.length / 3;
    for (NSUInteger i = 0; i < count; i += 1) {
        NSUInteger value = (bytes[i*3] << 16) + (bytes[i*3+1] << 8) + bytes[i*3+2];
        values.push_back((T)value);
    }
    return values;
}

template <typename T>
Array __vectorToArray(std::vector<T> vector)
{
    NSUInteger length = vector.size();
    NSInteger *arr = (NSInteger *)malloc(length * sizeof(NSInteger));
    for (NSUInteger i = 0; i < length; i++) {
        arr[i] = (NSInteger)vector[i];
    }
    return ArrayMake(arr, length);
}
