//
//  ConcentrationHandler.h
//  BLESDK-Concentration
//
//  Created by HyanCat on 2018/5/14.
//  Copyright © 2018 EnterTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConcentrationData;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ConcentrationBlinkBlock)(BOOL);
typedef void(^ConcentrationDataBlock)(ConcentrationData *);

@interface ConcentrationHandler : NSObject

+ (void)start;

+ (void)pushRawData:(NSData *)rawData
        handleBlink:(ConcentrationBlinkBlock)handleBlink
         handleData:(ConcentrationDataBlock)handleData;

@end

NS_ASSUME_NONNULL_END
