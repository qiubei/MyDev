//
// Created by 雷京颢 on 2018/1/9.
//

#ifndef ALGORITHMSDK_SDK_NAPMUSIC_V3_COMMAND_COMMAND_H
#define ALGORITHMSDK_SDK_NAPMUSIC_V3_COMMAND_COMMAND_H

#include <iostream>
#include <vector>
#include <cstddef>

namespace EnterTech{
namespace AlgorithmSDK{
namespace NapMusicV3 {

typedef short Pitch;

enum INSTRUMENT {
    UNKNOWN = 0, GRAND_PIANO = 1, STRING = 2, VOICE = 3
};

/**
 * 音量控制模型
 */
struct VolumeControlPoint {
    double amp;
    double time;

    VolumeControlPoint(double amp_, double time_) : amp(amp_), time(time_) {}
};

/**
 * 演奏标记，包括音符和休止符
 */
struct Command {
    double duration;

    Command() : duration(0) {}

    explicit Command(double d) : duration(d) {}
};

/**
 * 停顿标记
 */
struct SleepCommand : public Command {
    SleepCommand() : Command(0.) {}

    explicit SleepCommand(double t) : Command(t) {}
};

/**
 * 音符
 */
struct NoteCommand : public Command {
    Pitch pitch; // 音高
    double pan;  // 立体声参数
    INSTRUMENT instrument; // 乐器名
    std::vector<VolumeControlPoint> vcp; // 音量控制模型

    NoteCommand() : Command(0.), pitch(20), pan(0), instrument(INSTRUMENT::UNKNOWN) {
        vcp.emplace_back(VolumeControlPoint(1, 0));
        vcp.emplace_back(VolumeControlPoint(1, 1));
    }
};

/**
 * 同一时刻播放的音符集合
 */
struct CommandPack {
    size_t index = 0;
    std::vector<NoteCommand> nc;
    SleepCommand sc;

    explicit CommandPack(size_t in) : index(in) {}
};

}
}
}

#endif //ALGORITHMSDK_SDK_NAPMUSIC_V3_COMMAND_COMMAND_H
