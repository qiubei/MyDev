//
//  NapMusicDefines.h
//  BLESDK-NapMusic
//
//  Created by HyanCat on 2018/6/7.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AnalyzeProcessData;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BamStatus) {
    BamStatusUnwear = 0,
    BamStatusGenerating = 1,
    BamStatusPlaying = 2,
    BamStatusWarming = 3,
    BamStatusStopped = 4,
};

typedef NS_ENUM(NSUInteger, AlgorithmLanguage) {
    AlgorithmLanguageUnknown = 0,
    AlgorithmLanguageChinese = 1,
    AlgorithmLanguageEnglish = 2,
    AlgorithmLanguageJapanese = 3,
};

@class BamSleepCommand, BamNoteCommand;
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

typedef void(^NapMusicBlock)(NSArray <BamCommand *> *command, BamStatus status);

NS_ASSUME_NONNULL_END
