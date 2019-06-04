//
//  NapMusicHandler.m
//  BLESDK-NapMusic
//
//  Created by HyanCat on 2018/6/7.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

#import "NapMusicHandler.h"
#include "./Vendor/libAlgorithmSDK/include/src/sdk/nap_v3/DataManager.h"
#include "./Vendor/libAlgorithmSDK/include/src/sdk/napmusic_v3/DataManager.h"

using namespace EnterTech;
using namespace EnterTech::AlgorithmSDK;
using namespace EnterTech::AlgorithmSDK::NapV3;

#define NapManager DataManager::getInstance()
#define NapMusicManager NapMusicV3::DataManager::getInstance()

static std::vector<DATA> mlpDegreeVector;   // 神经网络值， 每 2 秒一个值
static std::vector<DATA_QUALITY> dataQualityVector;  // 数据质量，每 2 秒一个值
static std::vector<SOUND_CONTROL> soundControlMoveVector;   // 音量控制，每 2 秒一个值
static std::vector<SLEEP_STATE> sleepStatusVector;    // 睡眠状态，每 2 秒一个值

static dispatch_queue_t queue = dispatch_queue_create("com.entertech.queue.algorithm", DISPATCH_QUEUE_SERIAL);

std::vector<NSUInteger> decodeRawDataToValues(NSData *data);

static std::vector<RAW_DATA> _rawDataBuffer;

static AlgorithmLanguage __algorithmLanguage = AlgorithmLanguageChinese;
static BOOL __enableMusic = NO;

@implementation NapMusicHandler
@dynamic language;
@dynamic enableMusic;

+ (AlgorithmLanguage)language
{
    return __algorithmLanguage;
}

+ (void)setLanguage:(AlgorithmLanguage)language
{
    __algorithmLanguage = language;
}

+ (BOOL)enableMusic
{
    return __enableMusic;
}

+ (void)setEnableMusic:(BOOL)enableMusic
{
    __enableMusic = enableMusic;
}

+ (NSString *)version
{
    std::string version = NAP_V3_VERSION;

    return [NSString stringWithCString:version.c_str() encoding:NSUTF8StringEncoding];
}

+ (void)start
{
    //    __resetBuffer();

    mlpDegreeVector.clear();
    sleepStatusVector.clear();
    soundControlMoveVector.clear();
    dataQualityVector.clear();

    NSBundle *napBundle = [NSBundle bundleForClass: [self class]];
    NSString *mlpPath = [napBundle pathForResource:@"mlp" ofType:@"json"];
    NapManager.init([mlpPath cStringUsingEncoding:NSUTF8StringEncoding]);
    NapMusicManager.init((NapMusicV3::LANGUAGE_MODE)[self language]);
}

+ (void)pushRawData:(NSData *)rawData handleProcess:(nonnull NPAlgorithmProcessBlock)handleProcess withMusicBlock:(nullable NapMusicBlock)musicBlock
{
    dispatch_async(queue, ^() {
        std::vector<NSUInteger> values = decodeRawDataToValues(rawData);
        for (auto it = values.cbegin(); it != values.cend(); it++) {
            TriggerState trigged = NapManager.appendRawData((EnterTech::RAW_DATA)*it);
            if ([self enableMusic]) {
                if ((trigged.musicTriggered)) {
                    NapV3::CommonResult dataPack = NapManager.getCommonResult();
                    NapMusicV3::NapMusicInput input;
                    input.napDegree = dataPack.napDegree;
                    input.soundControl = static_cast<NapMusicV3::SOUND_CONTROL_INPUT>(dataPack.soundControl);
                    // 每 musicTriggered (2s 一次)触发小睡音乐算法（连续 4 次喂一样的数据）
                    NapMusicManager.trigger(input);
                    
                    // 每 commonTriggered(8s 一次)触发一次小睡算法
                    if ((trigged.commonTriggered)&&(handleProcess)) {
                        handleProcess([self handleProcessNapData]);
                    }
                    BamStatus status;
                    NSArray *commands = [self handleProcessNapMusicDataStatus:&status];
                    if (musicBlock) {
                        musicBlock(commands, status);
                    }
                }
            } else {
                if (trigged.commonTriggered) {
                    if (handleProcess) {
                        handleProcess([self handleProcessNapData]);
                    }
                }
            }

            // 重置一下音量操作数
            NapManager.setManualOperated(0);
        }
    });
}

+ (NPAnalyzeProcessData *)handleProcessNapData
{
    NapV3::CommonResult dataPack = NapManager.getCommonResult();
    // 记录体验中数据
    mlpDegreeVector.push_back(dataPack.mlpDegree);
    sleepStatusVector.push_back(dataPack.sleepState);
    soundControlMoveVector.push_back(dataPack.soundControl);
    dataQualityVector.push_back(dataPack.dataQuality);

    // 构造数据并返回上层
    // 构造数据并返回上层
    NPAnalyzeProcessData *data = [[NPAnalyzeProcessData alloc] init];
    data.mlpDegree     = dataPack.mlpDegree;
    data.napDegree     = dataPack.napDegree;
    data.dataQuality   = (Byte)dataPack.dataQuality;
    data.soundControl  = (Byte)dataPack.soundControl;
    data.sleepState    = (Byte)dataPack.sleepState;
    data.alphaEnergy   = (Byte)dataPack.alphaEnergy;
    data.betaEnergy    = (Byte)dataPack.betaEnergy;
    data.thetaEnergy   = (Byte)dataPack.thetaEnergy;
    data.smoothRawData = [NSData dataWithBytes:dataPack.smoothRawData.data()
                                        length:dataPack.smoothRawData.size()];
    return data;
}

+ (NSArray <BamCommand *>*)handleProcessNapMusicDataStatus:(BamStatus *)status
{
    std::vector<NapMusicV3::CommandPack> commands = NapMusicV3::DataManager::getInstance().getCommandPack();
    NapMusicV3::NapMusicAnalyzedDataPack musicDataPack = NapMusicV3::DataManager::getInstance().getAnalyzedDataPack();
    *status = (BamStatus)musicDataPack.musicStatus;

    NSMutableArray *commandsArray = [NSMutableArray arrayWithCapacity:commands.size()];
    for (auto it = commands.cbegin(); it != commands.cend(); it++) {
        BamCommand *command = [[BamCommand alloc] init];
        {
            BamSleepCommand *sleep = [[BamSleepCommand alloc] init];
            sleep.duration = (*it).sc.duration;
            command.sleepCommand = sleep;
        }
        {
            std::vector<NapMusicV3::NoteCommand> notes = (*it).nc;
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
        [commandsArray addObject:command];
    }
    return commandsArray.copy;
}

+ (void)operateVolume:(float)volume
{
    dispatch_async(queue, ^() {
    NapManager.setManualOperated(volume);
    });
}

+ (void)wearing:(BOOL)isOK
{
    dispatch_async(queue, ^{
        NapMusicV3::DataManager::getInstance().setTouchStatus(isOK ? TOUCH_STATUS::GOOD : TOUCH_STATUS::BAD);
    });
}

+ (void)finishWithResult:(NPAlgorithmResultBlock)handleResult
{
    dispatch_sync(queue, ^() {
        // ugly 规避数组为零
        if ((mlpDegreeVector.size() < 5)
            || (sleepStatusVector.size() < 5)
            || (dataQualityVector.size() < 5)
            || (soundControlMoveVector.size() < 5)){
            mlpDegreeVector = {0.3, 0.4, 0.4, 0.33, 0.36};
            sleepStatusVector = { NapV3::SLEEP_STATE(0),
                NapV3::SLEEP_STATE(0),
                NapV3::SLEEP_STATE(0),
                NapV3::SLEEP_STATE(0),
                NapV3::SLEEP_STATE(0)};
            dataQualityVector = {DATA_QUALITY(0),
                DATA_QUALITY(0),
                DATA_QUALITY(0),
                DATA_QUALITY(0),
                DATA_QUALITY(0)
            };
            soundControlMoveVector = {NapV3::SOUND_CONTROL(1),
                NapV3::SOUND_CONTROL(1),
                NapV3::SOUND_CONTROL(1),
                NapV3::SOUND_CONTROL(1),
                NapV3::SOUND_CONTROL(1)
            };
        }
        
        
        NapManager.finish(soundControlMoveVector,
                          sleepStatusVector,
                          mlpDegreeVector,
                          dataQualityVector);
        mlpDegreeVector.clear();
        sleepStatusVector.clear();
        soundControlMoveVector.clear();
        dataQualityVector.clear();
        //        __resetBuffer();
        if (handleResult) {
            handleResult([self handleResult]);
        }
    });
}

+ (void)calculateSleepCurve:(NSData *)analyzedData handleResult:(NPAlgorithmResultBlock)handleResult
{
    NSBundle *mlpBundle = [NSBundle bundleForClass: [self class]];
//    NSBundle *mlpBundle = [NSBundle bundleWithIdentifier:@"AlgorithmFile"];
    NSString *mlpPath = [mlpBundle pathForResource:@"mlp" ofType:@"json"];
    NapManager.init([mlpPath cStringUsingEncoding:NSUTF8StringEncoding]);
    dispatch_sync(queue, ^{
        NSInteger length = analyzedData.length;

        std::vector<DATA> tempMLPDegreeVector;
        tempMLPDegreeVector.reserve(length/8);
        std::vector<SLEEP_STATE> tempSleepStatusVector;
        tempSleepStatusVector.reserve(length/8);
        std::vector<DATA_QUALITY> tempDataQualityVector;
        tempDataQualityVector.reserve(length/8);
        std::vector<SOUND_CONTROL> tempSoundControlMoveVector;
        tempSoundControlMoveVector.reserve(length/8);

        Byte *bytes = (Byte *)malloc(analyzedData.length/sizeof(Byte));
        [analyzedData getBytes:bytes length:analyzedData.length];
        for (int i = 0; i < length-7; i+=8) {
            // mlp 的值在写入文件的时候会 *255，所以需要恢复一下。
            tempMLPDegreeVector.push_back((DATA)(double(bytes[i])/255.0));
            tempSleepStatusVector.push_back(bytes[i+2] == 255 ? (SLEEP_STATE)(-1) : (SLEEP_STATE)bytes[i+2]);
            tempDataQualityVector.push_back((DATA_QUALITY)bytes[i+3]);
            tempSoundControlMoveVector.push_back((SOUND_CONTROL)bytes[i+4]);
        }
        free(bytes);
        
        // ugly 规避数组为零
        if ((tempMLPDegreeVector.size() < 5)
            || (tempSleepStatusVector.size() < 5)
            || (tempDataQualityVector.size() < 5)
            || (tempSoundControlMoveVector.size() < 5)){
            tempMLPDegreeVector = {0.3, 0.4, 0.4, 0.33, 0.36};
            tempSleepStatusVector = { NapV3::SLEEP_STATE(0),
                NapV3::SLEEP_STATE(0),
                NapV3::SLEEP_STATE(0),
                NapV3::SLEEP_STATE(0),
                NapV3::SLEEP_STATE(0)
                
            };
            tempDataQualityVector = {DATA_QUALITY(0),
                DATA_QUALITY(0),
                DATA_QUALITY(0),
                DATA_QUALITY(0),
                DATA_QUALITY(0)
            };
            tempSoundControlMoveVector = {NapV3::SOUND_CONTROL(1),
                NapV3::SOUND_CONTROL(1),
                NapV3::SOUND_CONTROL(1),
                NapV3::SOUND_CONTROL(1),
                NapV3::SOUND_CONTROL(1)
            };
            
        }
//        for(int i = 0; i < tempSoundControlMoveVector.size(); i++) {
//            NSLog(@"sound - %d - sleep - %d  ------ mlp - %f - quality - %d",
//                  int(tempSoundControlMoveVector[i]),
//                  int(tempSleepStatusVector[i]),
//                  double(tempMLPDegreeVector[i]),
//                  int(tempDataQualityVector[i]));
//        }
        
        NapManager.finish(tempSoundControlMoveVector,
                          tempSleepStatusVector,
                          tempMLPDegreeVector,
                          tempDataQualityVector);

        tempMLPDegreeVector.clear();
        tempSleepStatusVector.clear();
        tempDataQualityVector.clear();
        tempSoundControlMoveVector.clear();
        if (handleResult) {
            handleResult([self handleResult]);
        }
    });
}

+ (NPFinishedResult *)handleResult
{
    NapV3::FinishResult finishDataPack = NapV3::DataManager::getInstance().getFinishResult();

    NPFinishedResult *result = [[NPFinishedResult alloc] init];
    result.sleepScore        = finishDataPack.napScore;
    result.sleepLatency      = finishDataPack.sleepLatency;
    result.soberDuration     = finishDataPack.soberDuration;
    result.blurrDuration     = finishDataPack.blurDuration;
    result.sleepDuration     = finishDataPack.sleepDuration;
    result.sleepPoint        = (int)finishDataPack.sleepPoint;
    result.alarmPoint        = (int)finishDataPack.alarmPoint;
    result.soberLevelPoint   = (int)finishDataPack.napClassSober;
    result.blurrLevelPoint   = (int)finishDataPack.napClassBlur;
    result.sleepLevelPoint   = (int)finishDataPack.napClassSleep;
    result.wearQuality       = WearQualityType(finishDataPack.wearQuality);

    {
        // 注意：napclass 和 napcurve 不是 Byte 型不能直接 Data。(不同类型占位不同)
        std::vector<Byte> napcurve;
        for(int i = 0; i < finishDataPack.napCurve.size(); i++) {
            napcurve.push_back(Byte(finishDataPack.napCurve[i]));
        }
        
        std::vector<Byte> napclass;
        for(int i = 0; i < finishDataPack.napClass.size(); i++) {
            napclass.push_back(Byte(finishDataPack.napClass[i]));
        }
        
//        for (int i; i < finishDataPack.napClass.size(); i++) {
//            NSLog(@"sobber: %d, blur: %d , sleep: %d ,napclass value is %d --- byte is %d ",result.soberLevelPoint, result.blurrLevelPoint, result.sleepLevelPoint, finishDataPack.napClass[i], Byte(finishDataPack.napClass[i]));
//        }
        
        result.sleepStateData = [NSData dataWithBytes:napclass.data()
                                               length:napclass.size()];
        result.sleepCurveData = [NSData dataWithBytes:napcurve.data()
                                               length:napcurve.size()];
        
        napcurve.clear();
        napclass.clear();
    }
    return result;
}

@end

std::vector<NSUInteger> decodeRawDataToValues(NSData *data)
{
    std::vector<NSUInteger> values;
    Byte *bytes = (Byte *)data.bytes;
    NSUInteger count = data.length / 3;
    for (NSUInteger i = 0; i < count; i += 1) {
        NSUInteger value = (bytes[i*3] << 16) + (bytes[i*3+1] << 8) + bytes[i*3+2];
        values.push_back(value);
    }
    return values;
}
