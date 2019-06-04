//
// Created by 雷京颢 on 2018/5/31.
//

#ifndef PUBLIC_HANDY_H
#define PUBLIC_HANDY_H

#include <vector>
#include <string>

namespace EnterTech {

std::vector <std::string> getNameList(const std::string &prefix) {
    std::string nameListFileName = prefix + "nameList.txt";
    std::vector<std::string> data;
    std::ifstream dataIn(nameListFileName);
    std::string tmp;
    while (dataIn >> tmp) {
        data.emplace_back(tmp);
    }
    dataIn.close();
    return data;
}



}


#endif //PUBLIC_HANDY_H
