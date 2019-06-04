//
//  Description.swift
//  BLESDK-Example
//
//  Created by HyanCat on 2018/5/23.
//  Copyright © 2018 EnterTech. All rights reserved.
//

import Foundation
import BLESDK
import BLESDK_Concentration
import BLESDK_ConcentrationMusic
import BLESDK_NapMusic
import BLESDK_Microphone

extension DFUState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "无状态"
        case .prepared:
            return "已准备"
        case .upgrading(let progress):
            return "正在更新：\(progress)%"
        case .succeeded:
            return "更新成功"
        case .failed:
            return "更新失败"
        }
    }
}

extension DataQuality: CustomStringConvertible {
    public var description: String {
        return ["invalid", "poor", "valid"][Int(self.rawValue)]
    }
}

extension ConcentrationData: CustomStringConvertible {
    public var description: String {
        return """
        data quality: \(self.dataQuality)
        concentration: \(self.concentration)
        relax: \(self.relax)
        rawData: \(self.smoothData)
        spectrum: \(self.spectrum)
        """
    }
}

extension Battery: CustomStringConvertible {
    public var description: String {
        return """
        voltage: \(voltage)v
        remain: \(remain)h
        percentage: \(UInt8(percentage * 100))%.
        """
    }
}

extension NapMusic.NapProcessData: CustomStringConvertible {
    public var description: String {
        return """
        mlpDegree: \(mlpDegree)
        napDegree: \(napDegree)
        sleepState: \(sleepState)
        dataQuality: \(dataQuality)
        soundControl: \(soundControl)
        smoothRawData: \(smoothRawData?.count ?? 0)
        alpha: \(alphaEngery)
        beta: \(betaEngery)
        theta: \(thetaEngery)
        """
    }
}

extension NapMusic.NapFinishData: CustomStringConvertible {
    public var description: String {
        return """
        sleepScore: \(sleepScore)
        sleepLatency:\(sleepLatency)
        soberDuration:\(soberDuration)
        blurrDuration:\(blurrDuration)
        sleepDuration:\(sleepDuration)
        sleepPoint:\(sleepPoint)
        alarmPoint:\(alarmPoint)
        soberLevelPoint:\(soberLevelPoint)
        blurrLevelPoint:\(blurrLevelPoint)
        sleepLevelPoint:\(sleepLevelPoint)
        wearQuality: \(wearQuality)
        sleepStateData:\(String(describing: sleepStateData?.count))
        sleepCurveData:\(String(describing: sleepCurveData?.count))
        """
    }
}

extension ConcentrationMusic.MusicProcessData: CustomStringConvertible {
    public var description: String {
        return """
        sleepCommand: { \n \(sleepCommand) }
        noteCommands: { \n \(noteCommands)  }
        process:  \(process.degree)
        musicState:  \(process.state)
        """
    }
}

extension ConcentrationMusic.SleepCommand: CustomStringConvertible {
    public var description: String {
        return """
        duration: \(duration)
        """
    }
}

extension ConcentrationMusic.NoteCommand: CustomStringConvertible {
    public var description: String {
        return """
        duration: \(duration)
        instrument: \(duration)
        pitch: \(pitch)
        pan: \(pan)
        """
    }
}

extension ConcentrationMusic.Result: CustomStringConvertible {
    public var description: String {
        return """
        soundCount: \(soundCount)
        avgConcentration: \(avgConcentration)
        rankRate: \(rankRate)
        similarRate: \(similarRate)
        similarName: \(similarName)
        maxConcentration: \(maxConcentration)
        minConcentration: \(minConcentration)
        highPitch: \(highPitch)
        lowPitch: \(lowPitch)
        """
    }
}

extension NapMusic.NapMusicCommand: CustomStringConvertible {
    public var description: String {
        return """
        sleepCommand { \n \(sleepCommand) \n}
        noteCommands { \n \(noteCommands) \n}
        status; \(status)
        """
    }
}

extension NapMusic.SleepCommand: CustomStringConvertible {
    public var description: String {
        return """
        duration: \(duration)
        """
    }
}

extension NapMusic.NoteCommand: CustomStringConvertible {
    public var description: String {
        return """
        duration: \(duration)
        instrument: \(duration)
        pitch: \(pitch)
        pan: \(pan)
        """
    }
}

extension NapMusic.Status: CustomStringConvertible {
    public var description: String {
        return """
        state value: \(self.rawValue)
        """
    }
}

extension Sleep.MicAnalyzedProcessData: CustomStringConvertible {
    public var description: String {
        return """
        timestamp: \(timestamp) -
        noiseLv: \(noiseLv) -
        snoreFlag: \(snoreFlag) -
        daydreamFlag: \(daydreamFlag) -
        alarm: \(alarm) -
        movementEn: \(movementEn) -
        movementFreq: \(movementFreq) -
        snoreRecData: \(snoreRecData.count) -
        daydreamRecData: \(daydreamRecData.count) -
        """
    }
}

extension Sleep.SleepFinishResult: CustomStringConvertible {
    public var description: String {
        return """
        score: \(score)
        soberLen: \(soberLen)
        lightSleepLen: \(lightSleepLen)
        deepSleepLen: \(deepSleepLen)
        latencyLen: \(latencyLen)
        sleepLen: \(sleepLen)
        sleepPoint: \(sleepPoint)
        alarmPoint: \(alarmPoint)
        detectQuality: \(detectQuality)
        sleepCurveData: \(sleepCurveData.count)
        sleepNoiseLvData: \(sleepNoiseLvData.count)
        sleepSnoresData: \(sleepSnoresData.count)
        sleepDaydreamData: \(sleepDaydreamData.count)
        """
    }
}



