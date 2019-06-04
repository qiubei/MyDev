//
//  AlgorithmDefines.h
//  BLESDK-Nap
//
//  Created by HyanCat on 2018/6/1.
//  Copyright © 2018 EnterTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPAnalyzeProcessData : NSObject

@property (nonatomic, assign, readwrite) double mlpDegree;// 神经网络数值
@property (nonatomic, assign, readwrite) Byte   napDegree;// 放松度
@property (nonatomic, assign, readwrite) Byte   sleepState;// 睡眠状态
@property (nonatomic, assign, readwrite) Byte   dataQuality;// 数据质量信号
@property (nonatomic, assign, readwrite) Byte   soundControl;// 音量控制信号
@property (nonatomic, strong, readwrite, nullable) NSData *smoothRawData;// 实时曲线数据

- (instancetype)initWithMLPDegree:(double)mlpDegree
                        napDegree:(Byte)napDegree
                       sleepState:(Byte)sleepState
                      dataQuality:(Byte)dataQuality
                     soundControl:(Byte)soundControl
                    smoothRawData:(NSData*) smoothRawData;

@end

@interface NPFinishedResult : NSObject

@property (nonatomic, assign, readwrite) Byte   sleepScore;// 综合得分
@property (nonatomic, assign, readwrite) double sleepLatency;// 睡眠时长
@property (nonatomic, assign, readwrite) double soberDuration;// 清醒时长
@property (nonatomic, assign, readwrite) double blurrDuration;// 迷糊时长
@property (nonatomic, assign, readwrite) double sleepDuration;// 浅睡时长
@property (nonatomic, assign, readwrite) Byte   sleepPoint;// 睡眠曲线：入睡点坐标
@property (nonatomic, assign, readwrite) Byte   alarmPoint;// 睡眠曲线：唤醒点坐标
@property (nonatomic, assign, readwrite) Byte   soberLevelPoint;// 状态曲线：清醒
@property (nonatomic, assign, readwrite) Byte   blurrLevelPoint;// 状态曲线：迷糊
@property (nonatomic, assign, readwrite) Byte   sleepLevelPoint;// 状态曲线：浅睡
@property (nonatomic, strong, readwrite, nullable) NSData *sleepStateData;// 睡眠状态数据
@property (nonatomic, strong, readwrite, nullable) NSData *sleepCurveData;// 绘制睡眠曲线数据

@end

typedef void(^NPAlgorithmProcessBlock)(NPAnalyzeProcessData *data);
typedef void(^NPAlgorithmResultBlock)(NPFinishedResult *result);


NS_ASSUME_NONNULL_END
