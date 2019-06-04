//
//  ConcentrationMusicDefines.h
//  BLESDK-ConcentrationMusic
//
//  Created by HyanCat on 2018/6/8.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BamSleepCommand, BamNoteCommand;

/// 脑波音乐控制信息
@interface BamCommand: NSObject

@property (nonatomic, strong, readwrite) BamSleepCommand *sleepCommand;
@property (nonatomic, copy, readwrite) NSArray <BamNoteCommand*> *noteCommands;

@end

@interface BamSleepCommand: NSObject

@property (nonatomic, assign, readwrite) NSTimeInterval duration;

@end

@interface BamNoteCommand: NSObject

@property (nonatomic, assign, readwrite) NSTimeInterval duration;
@property (nonatomic, assign, readwrite) uint8_t instrument;
@property (nonatomic, assign, readwrite) uint64_t pitch;
@property (nonatomic, assign, readwrite) float pan;

@end

typedef NS_ENUM(NSUInteger, ConcentrationProcessState) {
    ConcentrationProcessStateInit = 0,
    ConcentrationProcessStateReady = 1,
    ConcentrationProcessStateStart = 2,
    ConcentrationProcessStateEnd = 3,
};

@interface ConcentrationProcess: NSObject

@property (nonatomic, assign, readwrite) ConcentrationProcessState state;
@property (nonatomic, assign, readwrite) uint8_t degree;

@end

typedef NS_ENUM(NSUInteger, ComposerName) {
    ComposerNameNone = 0,
    ComposerNameLiszt,
    ComposerNameChopin,
    ComposerNameMozart,
    ComposerNameTschakovsky,
    ComposerNameBach,
    ComposerNameBrahms,
    ComposerNameHaydn,
    ComposerNameBeethoven,
    ComposerNameSchubert,
    ComposerNameMendelssohn,
};

/// 注意力谱曲结果
@interface ConcentrationResult: NSObject

/// 音效次数
@property (nonatomic, assign, readwrite) uint8_t soundCount;
/// 有效范围内平均注意力值
@property (nonatomic, assign, readwrite) uint8_t avgConcentration;
/// 排行比例
@property (nonatomic, assign, readwrite) uint8_t rankRate;
/// 作曲家的相似度
@property (nonatomic, assign, readwrite) uint8_t similarRate;
/// 作曲家
@property (nonatomic, assign, readwrite) ComposerName similarName;
/// 有效范围内最大注意力值
@property (nonatomic, assign, readwrite) uint8_t maxConcentration;
/// 有效范围内最小注意力值
@property (nonatomic, assign, readwrite) uint8_t minConcentration;
/// 最高音
@property (nonatomic, copy, readwrite) NSString *highPitch;
/// 最低音
@property (nonatomic, copy, readwrite) NSString *lowPitch;

@end

typedef void(^ConcentrationMusicBlock)(ConcentrationProcess *, NSArray <BamCommand *> *commands);
typedef void(^ConcentrationResultBlock)(ConcentrationResult *);

NS_ASSUME_NONNULL_END
