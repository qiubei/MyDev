//
// Created by like on 2018/10/26.
//

#ifndef PUBLIC_MATHTOOL_H
#define PUBLIC_MATHTOOL_H


#include <vector>
#include "EnterEEG.h"

namespace EnterTech {
    namespace EnterEEG {



        /**
         *  局部加权平滑
         *
         *  @param data             数据
         *  @param smoothRange      平滑范围比例（取值范围：0~1）
         *  @param endPointAdjust   是否端点校正
         *
         *  @return  求值结果
         */
        std::vector<DATA> loessSmooth(const std::vector<DATA> &data, float smoothRange = 0.1, float sig = 3., bool endPointAdjust = true);



    }
}
#endif





