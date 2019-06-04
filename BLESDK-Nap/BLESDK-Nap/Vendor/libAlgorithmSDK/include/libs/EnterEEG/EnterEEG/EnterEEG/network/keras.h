//
// Created by 雷京颢 on 2018/7/26.
//

#ifndef ENTEREEG_NETWORK_KERAS_H
#define ENTEREEG_NETWORK_KERAS_H

#include <string>
#include <fdeep/fdeep.hpp>

#include "../define/Data.h"

namespace EnterTech {
namespace EnterEEG {

class KerasModel {
private:
    fdeep::model model_;
public:
    KerasModel() = delete;
    KerasModel(const std::string &modleFile) : model_(fdeep::load_model(modleFile)) {}
    DATA predict(const std::vector<DATA> &input);
};

}
}



#endif //ENTEREEG_KERAS_H
