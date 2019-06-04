//
//  ConcentrationMusicHandle.m
//  BLESDK-Concentration
//
//  Created by HyanCat on 2018/5/14.
//  Copyright © 2018 EnterTech. All rights reserved.
//

#import "ConcentrationMusicHandle.h"
#import "ConcentrationMusicDefines.h"
#include "./Vendor/lib/include/src/sdk/concentration_v3/DataManager.h"
#include "./Vendor/lib/include/src/sdk/concentrationmusic_v3/DataManager.h"

using namespace EnterTech;
using namespace EnterTech::AlgorithmSDK;

template <typename T>
std::vector<T> __decodeRawDataToValues(NSData *data);

static dispatch_queue_t queue = dispatch_queue_create("com.entertech.queue.algorithm.concentration", DISPATCH_QUEUE_SERIAL);
static LanguageMode _language;
@implementation ConcentrationMusicHandle
@dynamic language;

+ (LanguageMode)language
{
    return _language;
}

+ (void)setLanguage:(LanguageMode)language
{
    _language = language;
}

+ (instancetype)shared
{
    static ConcentrationMusicHandle *handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [ConcentrationMusicHandle new];
    });
    return handler;
}

+ (void)start
{
    ConcentrationV3::DataManager::getInstance().init();
    ConcentrationMusicV3::DataManager::getInstance().init((ConcentrationMusicV3::LANGUAGE_MODE)self.language);
}

+ (void)pushRawData:(NSData *)rawData handleMusic:(ConcentrationMusicBlock)handleMusic
{
    [[self shared] pushRawData:rawData handleMusic:handleMusic];
}

+ (void)wearinng:(BOOL)isOK
{
    ConcentrationMusicV3::DataManager::getInstance().setTouchStatus(isOK ? TOUCH_STATUS::GOOD : TOUCH_STATUS::BAD);
}

- (void)pushRawData:(NSData *)rawData handleMusic:(ConcentrationMusicBlock)handleMusic
{
    dispatch_async(queue, ^{
        std::vector<DATA> values = __decodeRawDataToValues<DATA>(rawData);
        TriggerState trigger = ConcentrationV3::DataManager::getInstance().appendRawData(values);

        if (trigger.commonTriggered) {
            // music
            ConcentrationMusicV3::DataManager::getInstance().trigger();

            if (!ConcentrationMusicV3::DataManager::getInstance().hasNewCommands()) {
                return;
            }

            std::vector<ConcentrationMusicV3::CommandPack> commands = ConcentrationMusicV3::DataManager::getInstance().getCommandPack();
            ConcentrationMusicV3::CurrentResult current = ConcentrationMusicV3::DataManager::getInstance().getCurrentResult();
            if (current.processState > ConcentrationMusicV3::GAME_STATE::NONE) {
                // 处理 Process
                ConcentrationProcess *process = [ConcentrationProcess new];
                process.state = (ConcentrationProcessState)current.processState;
                process.degree = current.concentrationDegree;

                NSMutableArray *bamCommands = [NSMutableArray arrayWithCapacity:commands.size()];
                // 处理 Command
                for (auto it = commands.cbegin(); it != commands.cend(); it++) {
                    BamCommand *command = [[BamCommand alloc] init];
                    {
                        BamSleepCommand *sleep = [[BamSleepCommand alloc] init];
                        sleep.duration = (*it).sc.duration;
                        command.sleepCommand = sleep;
                    }
                    {
                        std::vector<ConcentrationMusicV3::NoteCommand> notes = (*it).nc;
                        NSMutableArray *noteCommands = [NSMutableArray arrayWithCapacity:notes.size()];
                        for (auto it2 = notes.cbegin(); it2 != notes.cend(); it2++) {
                            BamNoteCommand *note = [[BamNoteCommand alloc] init];
                            note.duration = (*it2).duration;
                            note.instrument = (uint8_t)(*it2).instrument;
                            note.pitch = (uint64_t)(*it2).pitch;
                            note.pan = (float)(*it2).pan;
                            [noteCommands addObject:note];
                        }
                        command.noteCommands = noteCommands;
                    }
                    [bamCommands addObject:command];
                }
                if (handleMusic) {
                    handleMusic(process, bamCommands);
                }
            }
        }
    });
}

+ (void)finishWithResult:(ConcentrationResultBlock)handleResult
{
    ConcentrationMusicV3::DataManager::getInstance().finish();
    ConcentrationMusicV3::FinishDataPack finishData = ConcentrationMusicV3::DataManager::getInstance().getFinishDataPack();
    ConcentrationResult *result = [ConcentrationResult new];
    result.soundCount = finishData.soundSum;
    result.avgConcentration = finishData.concentrationAvg;
    result.maxConcentration = finishData.concentrationHigh;
    result.minConcentration = finishData.concentrationLow;
    result.rankRate = finishData.rankRate;
    result.similarRate = finishData.simRate;
    result.similarName = (ComposerName)finishData.musicianName;
    result.highPitch = [NSString stringWithUTF8String:finishData.pitchNameHigh.c_str()];
    result.lowPitch = [NSString stringWithUTF8String:finishData.pitchNameLow.c_str()];

    handleResult(result);
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
