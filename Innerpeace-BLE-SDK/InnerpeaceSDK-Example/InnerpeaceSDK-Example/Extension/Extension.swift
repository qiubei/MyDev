//
//  Extension.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/8/14.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import Foundation
import BLESDK_Microphone

extension Sleep.SleepFinishResult {
    public init(score: Int,
                soberLen: Int,
                lightSleepLen: Int,
                deepSleepLen: Int,
                latencyLen: Int,
                sleepLen: Int,
                sleepPoint: Int,
                alarmPoint: Int,
                detectQuality: Int,
                sleepCurveData: Data,
                sleepNoiseLvData: Data,
                sleepSnoresData: Data,
                sleepDaydreamData: Data) {
        self.score = score
        self.soberLen = soberLen
        self.lightSleepLen = lightSleepLen
        self.deepSleepLen = deepSleepLen
        self.latencyLen = latencyLen
        self.sleepLen = sleepLen
        self.sleepPoint = sleepPoint
        self.alarmPoint = alarmPoint
        self.detectQuality = detectQuality
        self.sleepCurveData = sleepCurveData
        self.sleepNoiseLvData = sleepNoiseLvData
        self.sleepSnoresData = sleepSnoresData
        self.sleepDaydreamData = sleepDaydreamData
    }

    func toDic() -> NSDictionary {
        return NSDictionary(dictionary: ["score": self.score,
                                         "soberLen": self.soberLen,
                                         "lightSleepLen": self.lightSleepLen,
                                         "deepSleepLen": self.deepSleepLen,
                                         "latencyLen": self.latencyLen,
                                         "sleepLen": self.sleepLen,
                                         "sleepPoint": self.sleepPoint,
                                         "alarmPoint": self.alarmPoint,
                                         "detectQuality": self.detectQuality,
                                         "sleepCurveData": self.sleepCurveData.count,
                                         "sleepNoiseLvData": self.sleepNoiseLvData.count,
                                         "sleepSnoresData": self.sleepSnoresData.count,
                                         "sleepDaydreamData": self.sleepDaydreamData.count])
    }

    public static func objectForDic(dic: NSDictionary) -> Sleep.SleepFinishResult {
        let score = dic["score"] as! Int
        let soberLen = dic["soberLen"] as! Int
        let lightSleepLen = dic["lightSleepLen"] as! Int
        let deepSleepLen = dic["deepSleepLen"] as! Int
        let latencyLen = dic["latencyLen"] as! Int
        let sleepLen = dic["sleepLen"] as! Int
        let sleepPoint = dic["sleepPoint"] as! Int
        let alarmPoint = dic["alarmPoint"] as! Int
        let detectQuality = dic["detectQuality"] as! Int
//        let sleepCurveData = dic["sleepCurveData"] as! Int
//        let sleepNoiseLvData = dic["sleepNoiseLvData"] as! Int
//        let sleepSnoresData = dic["sleepSnoresData"] as! Int
//        let sleepDaydreamData = dic["sleepDaydreamData"] as! Int
        return Sleep.SleepFinishResult(score: score,
                                       soberLen: soberLen,
                                       lightSleepLen: lightSleepLen,
                                       deepSleepLen: deepSleepLen,
                                       latencyLen: latencyLen,
                                       sleepLen: sleepLen,
                                       sleepPoint: sleepPoint,
                                       alarmPoint: alarmPoint,
                                       detectQuality: detectQuality,
                                       sleepCurveData: Data(),
                                       sleepNoiseLvData: Data(),
                                       sleepSnoresData: Data(),
                                       sleepDaydreamData: Data())
    }
}
