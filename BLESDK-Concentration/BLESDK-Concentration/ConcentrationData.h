//
//  ConcentrationData.h
//  BLESDK-Concentration
//
//  Created by HyanCat on 2018/5/22.
//  Copyright © 2018 EnterTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(uint8_t, DataQuality) {
    DataQualityInvalid = 0,
    DataQualityPoor,
    DataQualityValid
};

struct Array {
    NSInteger *point;
    NSUInteger length;
};

FOUNDATION_EXTERN struct Array ArrayMake(NSInteger *point, NSUInteger length);

/**
 注意力数据类
 */
@interface ConcentrationData: NSObject

@property (nonatomic, assign) DataQuality dataQuality;
@property (nonatomic, assign) uint8_t concentration;
@property (nonatomic, assign) uint8_t relax;
@property (nonatomic, assign) struct Array smoothData;
@property (nonatomic, assign) struct Array spectrum;

@end

NS_ASSUME_NONNULL_END
