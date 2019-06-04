//
// Created by 雷京颢 on 2018/6/5.
//

#ifndef ALGORITHMSDK_SDK_CONCENTRAIONMUSIC_V3_DATAMANAGER_H
#define ALGORITHMSDK_SDK_CONCENTRAIONMUSIC_V3_DATAMANAGER_H

#include "DataDefine.h"
#include "ConcentrationMusicHandler.h"
#include "command/command.h"

namespace EnterTech {
namespace AlgorithmSDK {
namespace ConcentrationMusicV3 {
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
     * 生成演奏命令。调用频次为 2.5 Hz（配合来自注意力算法的 400ms 一次的回调）
     */
    void trigger();

    /**
     * 输入接触信号
     * @param status 接触信号
     */
    void setTouchStatus(TOUCH_STATUS status);

    /**
     * 获得小睡音乐播放指令
     * @return 小睡音乐播放指令
     */
    std::vector<CommandPack> getCommandPack() const;

    /**
     * 获得小睡当前运行状态
     * @return 小睡当前运行状态
     */
    CurrentResult getCurrentResult() const;

    /**
     * 结束注意力音乐
     */
    void finish();

    /**
     * 获得结束报表
     * @return
     */
    FinishDataPack getFinishDataPack() const;


    /**
     * 是否生成了新的音乐指令
     * @return
     */
    bool hasNewCommands() const;

private:

    DataManager() = default;
    ~DataManager();

    //算法的handler
    ConcentrationMusicHandler *handler_ = nullptr;
    bool isInited_ = false;
};
}
}
}



#endif //ALGORITHMSDK_SDK_CONCENTRAIONMUSIC_V3_DATAMANAGER_H
