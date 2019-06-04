//
//  NapMusic.h
//  BLESDK-NapMusic
//
//  Created by HyanCat on 2018/6/7.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NapDefines.h"
#import "NapMusicDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface NapMusicHandler : NSObject

@property (class, nonatomic, assign) AlgorithmLanguage language;
@property (class, nonatomic, assign) BOOL enableMusic;

/**
 版本号
 @return 点分隔的三位版本号
 */
+ (NSString *)version;

/**
 开启算法，一定要调用。
 */
+ (void)start;

/**
 推送原始数据给算法

 @param rawData 原始数据
 @param handleProcess 分析过程回调
 @param musicBlock 音乐回调
 */
+ (void)pushRawData:(NSData *)rawData
      handleProcess:(NPAlgorithmProcessBlock)handleProcess
     withMusicBlock:(NapMusicBlock _Nullable)musicBlock;

/**
 佩戴是否正常

 @param isOK 是否正常
 */
+ (void)wearing:(BOOL)isOK;

/**
 用户手动调节音量

 @param volume 音量值：0 表示没有调节，非 0 表示有调节
 */
+ (void)operateVolume:(float)volume;

/**
 结束算法

 @param handleResult 结果回调 Block
 */
+ (void)finishWithResult:(NPAlgorithmResultBlock)handleResult;

/**
 计算绘制曲线部分：睡眠曲线数据 + 睡眠状态曲线数据；通过保存的实时分析结果文件数据作为输入来获得算法综合结果的绘制曲线部分。

 @param analyzedData 分析后的数据集合
 @param handleResult 结果回调 Block
 */
+ (void)calculateSleepCurve:(NSData *)analyzedData handleResult:(NPAlgorithmResultBlock)handleResult;

@end

NS_ASSUME_NONNULL_END
