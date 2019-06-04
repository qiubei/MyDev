//
// Created by 雷京颢 on 2018/5/31.
//

#ifndef PUBLIC_HANDY_H
#define PUBLIC_HANDY_H

#include <vector>
#include <string>
#include "iostream"
#include <unistd.h>

namespace EnterTech {


    /*
     * 获取测试的文件名
     */
    std::vector <std::string> getNameList(const std::string &prefix) {
        std::string nameListFileName = prefix + "nameList.txt";
        std::vector<std::string> data;
        std::ifstream dataIn(nameListFileName);

        std::string tmp;
        while (dataIn >> tmp) {
            if(tmp[0] != '#')
                data.emplace_back(tmp);
        }

        dataIn.close();
        return data;
    }

    /*
     * 获取本地文件地址
     */
#define WORK_FILE_LENGTH 512
    std::string getWorkDir()
    {
        char pwd[WORK_FILE_LENGTH];

//getcwd函数测试
        if(!getcwd(pwd,WORK_FILE_LENGTH)){
            printf("error");
        } else {
            printf("\ngetcwd pwd is %s\n",pwd);
        }
        std::string tmp = pwd;
        return tmp;

    }







}


#endif //PUBLIC_HANDY_H
