//
//  ConcentrationMusicHandle.h
//  BLESDK-Concentration
//
//  Created by HyanCat on 2018/5/14.
//  Copyright © 2018 EnterTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConcentrationMusicDefines.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LanguageMode) {
    LanguageModeUnknown = 0,
    LanguageModeChinese,
    LanguageModeEnglish,
    LanguageModeJapanese,
};

@interface ConcentrationMusicHandle : NSObject

@property (class, nonatomic, assign) LanguageMode language;

+ (void)start;

+ (void)pushRawData:(NSData *)rawData
        handleMusic:(ConcentrationMusicBlock)handleMusic;

+ (void)wearinng:(BOOL)isOK;

+ (void)finishWithResult:(ConcentrationResultBlock)handleResult;

@end

NS_ASSUME_NONNULL_END
