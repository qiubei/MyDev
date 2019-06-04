//
// Created by 雷京颢 on 2018/5/31.
//

#ifndef ALGORITHMSDK_SDK_NAPMUSIC_V3_DATAMANAGER_H
#define ALGORITHMSDK_SDK_NAPMUSIC_V3_DATAMANAGER_H

#include "EnterEEG.h"
#include "DataDefine.h"
#include "NapMusicHandler.h"

namespace EnterTech {
namespace AlgorithmSDK {
namespace NapMusicV3 {

class DataManager {
public:

    /**
     *  获得类的单例
     *
     *  @return 指向单例的指针
     */
    static DataManager &getInstance() {
        static DataManager instance;
        return instance;
    }

    DataManager(DataManager const &) = delete;

    void operator=(DataManager const &)  = delete;

    /**
     * 是否初始化
     * @return
     */
    bool isInited();

    /**
     * Manager初始化
     */
    void init(LANGUAGE_MODE languageMode);

    /**
     * 输入来自小睡的分析后数据，生成演奏命令。调用频次应该在 0.5Hz
     */
    void trigger(NapMusicInput input);

    /**
     * 输入接触信号
     * @param status 接触信号
     */
    void setTouchStatus(TOUCH_STATUS status);

    /**
     * 获得小睡音乐分析后结果
     * @return 小睡音乐分析后结果
     */
    NapMusicAnalyzedDataPack getAnalyzedDataPack() const;

    /**
     * 获得小睡音乐播放指令
     * @return 小睡音乐播放指令
     */
    std::vector<CommandPack> getCommandPack() const;

private:

    DataManager() = default;
    ~DataManager();

    //算法的handler
    NapMusicHandler *handler_ = nullptr;
    bool isInited_ = false;
};

}
}
}


#endif //ALGORITHMSDK_SDK_NAPMUSIC_V3_DATAMANAGER_H
