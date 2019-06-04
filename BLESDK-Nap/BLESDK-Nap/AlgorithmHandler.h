//
//  AlgorithmHandler.h
//  BLESDK-Nap
//
//  Created by HyanCat on 2018/6/1.
//  Copyright © 2018 EnterTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlgorithmDefines.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AlgorithmLanguage) {
    AlgorithmLanguageUnknown = 0,
    AlgorithmLanguageChinese = 1,
    AlgorithmLanguageEnglish = 2,
    AlgorithmLanguageJapanese = 3,
};

@interface AlgorithmHandler : NSObject

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
 @param handleProcess 过程回调
 */
+ (void)pushRawData:(NSData *)rawData
      handleProcess:(NPAlgorithmProcessBlock)handleProcess;


/**
 结束算法

 @param handleResult 结果回调 Block
 */
+ (void)finishWithResult:(NPAlgorithmResultBlock)handleResult;

@end

NS_ASSUME_NONNULL_END
