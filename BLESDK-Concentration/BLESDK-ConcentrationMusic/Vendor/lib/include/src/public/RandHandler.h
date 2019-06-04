//
// Created by 雷京颢 on 2018/5/2.
//

#ifndef PUBLIC_RANDHANDLER_H
#define PUBLIC_RANDHANDLER_H

#include <random>
#include <ctime>

namespace EnterTech {
class RandomHandler {
public:
    /**
     *  获得类的单例
     *
     *  @return 指向单例的指针
     */
    static RandomHandler &getInstance() {
        static RandomHandler instance;
        return instance;
    }

    RandomHandler(RandomHandler const &) = delete;
    void operator=(RandomHandler const &)  = delete;

private:
    RandomHandler() = default;

#ifdef RAND_BOX
    std::vector<DATA> rand_;
    std::vector<std::vector<size_t>> randperm_;
    size_t randIndex_ = 0;
    size_t randpermIndex_ = 0;
public:
    DATA rand(){
        return rand_[randIndex_++];
    }
    std::vector<size_t> randperm(size_t size) {
        if (randperm_[randpermIndex_].size() != size)
            throw std::runtime_error("randperm size not fit!");
        return randperm_[randpermIndex_++];
    }
    void setRand(const std::vector<DATA> &rand) {
        rand_ = rand;
        randIndex_ = 0;
    }
    void setRandperm(const std::vector<std::vector<size_t>> &randperm) {
        randperm_ = randperm;
        randpermIndex_ = 0;
    }
    bool isEnd() {
        return (randpermIndex_ == randperm_.size()) && (randIndex_ == rand_.size());
    }
#else
    std::default_random_engine engine_ = std::default_random_engine(static_cast<unsigned>(time(nullptr)));
    std::uniform_real_distribution<DATA> realDistribution_ = std::uniform_real_distribution<DATA>(0, 1);
public:
    DATA rand() { return realDistribution_(engine_); }
    std::vector<size_t> randperm(size_t size) {
        std::vector<size_t> res;
        res.reserve(size);
        for (size_t i = 1; i <= size; i++) res.emplace_back(i);
        std::shuffle(res.begin(), res.end(), engine_);
        return res;
    }
#endif
};

}

#endif //PUBLIC_RANDHANDLER_H
