# Innerpeace-EEG-iOS-SDK

易休（Luuna）基础能力服务 SDK。

## 功能

1. 易休蓝牙设备通信，固件更新；
2. 大脑实时注意力信息；
3. 注意力脑波谱曲；
4. 小睡实时状态和结果信息；
5. 小睡脑波音乐谱曲。
6. 晚睡算法实时状态和结果信息。

## 安装集成

1. 推荐使用 `Cocoapods` 方式安装，在 Podfile 中添加依赖即可

    ```ruby
    pod 'InnerpeaceSDK', :git => "https://github.com/AnotherEnterTech/Entertech-EEG-iOS-SDK.git"
    ```

2. 手动引入 frameworks（尽量不要这样）

    下载将 frameworks 文件夹中所有 framework 拖入项目 target 配置 Embeded Binaries 中，由于依赖了 RxSwift、RxBluetoothKit、PromiseKit、Zip 等库，所以还需自行添加这些开源库。

## 使用

### 操作方法

1. 连接

    因为 SDK 提供了用户绑定功能，所以连接的时候需要传入用户 ID，ID 不匹配的设备不能连接。如果业务无需 ID 校验，传入一个固定值即可。

    ```swift
    try Innerpeace.ble.findAndConnect(identifier: 1234) { isOK in
       if isOK {
           // 连接成功
       } else {
           // 连接失败
       }
    }
    ```

2. 断开连接

    ```swift
    Innerpeace.ble.disconnect()
    ```

3. 开始体验（开始采集脑电数据和分析）

    ```swift
    try Innerpeace.start(algorithm options: AlgorithmOptions)
    ```
    
    `AlgorithmOptions` 为算法选项集合，可开启一个或多个，开启需要的算法，相应地就可以去监听并收到对应的分析处理数据。其完整定义如下：

    ```swift
    /// 算法选项
    public struct AlgorithmOptions : OptionSet {
        /// 注意力算法
        public static let concentration: AlgorithmOptions
    
        /// 注意力谱曲算法
        public static let concentrationMusic: AlgorithmOptions
    
        /// 小睡算法
        public static let nap: AlgorithmOptions
    
        /// 小睡脑波音乐算法
        public static let napMusic: AlgorithmOptions
    }
    ```

4. 结束体验（停止采集脑电数据和分析）

    ```swift
    Innerpeace.end()
    ```
    
5. 晚睡算法: 单独麦克风算法、 麦克风+小睡算法

    + 单独麦克风算法

         晚睡算法开始
        
        ```swift
        Innerpeace.microphone.start()
        ```
        
         晚睡算法结束
        
        ```swift 
        Innerpeace.microphone.end()
        ```
    + 麦克风算法 + 小睡算法

        晚睡算法开始
            
            ```swift 算法开始
            // 如果使用脑波谱曲助眠  AlgorithmOptions 选用 .napMusic
            Innerpeace.start(.nap)
            Innerpeace.microphone.start()
            ```
            
        晚睡算法结束
            
            ```swift 
            Innerpeace.end()
            // 传的参数默认为 nil，就是单独的麦克风算法。 
            // self.napAnalyzedDatas  为'小睡'过程中实时分析结果构成的结构体数组.
            // 类型参考 Sleep.NapAnalyzedProcessData
            Innerpeace.microphone.end(napAnalyzedDatas: self.napAnalyzedDatas)
            ```    

6. 固件更新

    ```swift
    // 提前下载固件包 (zip格式) 到本地，拿到 fileURL
    try Innerpeace.ble.dfu(fileURL: fileURL)
    ```

### 获取信息

1. 获取设备状态，判断是否连接

    ```swift
    Innerpeace.ble.state
    Innerpeace.ble.state.isConnected
    ```

    设备状态 case 定义如下：

    ```swift
    /// 蓝牙状态
    ///
    /// - disconnected: 断开连接
    /// - searching: 搜索中
    /// - connecting: 连接中
    /// - connected: 连接成功
    public enum BLEState {
       case disconnected
       case searching
       case connecting
       case connected(BLEWearState)
    }

    /// 佩戴状态
    ///
    /// - allWrong: 全部不正常
    /// - referenceWrong: 参考电极不正常
    /// - activeWrong: 活动电极不正常
    /// - normal: 佩戴正常
    public enum BLEWearState: UInt8 {
        case allWrong
        case referenceWrong
        case activeWrong
        case normal
    }
    ```

2. 获取设备基本信息

   ```swift
   Innerpeace.ble.deviceInfo
   ```

   ```swift
   /// 基本设备信息
   public struct BLEDeviceInfo {
       /// 设备名称
       public internal (set) var name: String
       /// 设备硬件版本
       public internal (set) var hardware: String
       /// 设备固件版本
       public internal (set) var firmware: String
       /// 设备 mac 地址
       public internal (set) var mac: String
   }
   ```

3. 获取设备电量信息

   ```swift
   Innerpeace.ble.battery
   ```

   ```swift
   /// 电量信息
   public struct Battery {
       /// 当前电压（伏特）
       public let voltage: Float
       /// 遗留电量（小时），仅供参考
       public let remain: Int
       /// 电量百分比值 [0,1]
       public let percentage: Float
   }
   ```

### 监听通知

所有的数据或状态的监听都是通过 `Notification` 的形式，所有通知都是异步主线程回调，所有通知 Name 如下：

```swift
/// 所有的通知
public enum NotificationName: String {
    case bleStateChanged
    case bleBrainwaveData
    case bleBatteryChanged

    case concentrationData
    case concentrationBlink
    case concentrationMusicData
    case concentrationMusicFinishData
    
    case napProcessData
    case napFinishData
    case napMusicData

    case dfuStateChanged
}
```

1. 原始脑电数据监听

    ```swift
    NotificationCenter.default.addObserver(forName: NotificationName.bleBrainwaveData.name, object: nil, queue: nil) { notification in
        guard let userInfo = notification.userInfo, let data = userInfo[NotificationKey.bleBrainwaveKey] as? Data else { return }
         // data 就是原始脑波数据
         // 原始脑波数据每 24 位为一个值
    }
    ```

2. 电量监听

    ```swift
    NotificationCenter.default.addObserver(forName: NotificationName.bleBatteryChanged.name, object: nil, queue: nil) { notification in
        guard let userInfo = notification.userInfo, let battery = userInfo[NotificationKey.bleBatteryKey] as? UInt8 else { return }
        // battery 就是电量信息，结构和上面读取电量一样
    }
    ```

3. 注意力分析数据监听

    ```swift
    NotificationCenter.default.addObserver(forName: NotificationName.concentrationData.name, object: nil, queue: nil) { notification in
        guard let userInfo = notification.userInfo, let concentrationData = userInfo[NotificationKey.concentrationDataKey] as? ConcentrationData else { return }
        // concentrationData 即分析后的注意力数据
    }
    ```

    ```swift
    // ConcentrationData 数据结构定义
    public struct ConcentrationData {

        public internal(set) var dataQuality: DataQuality

        public internal(set) var concentration: UInt8

        public internal(set) var relax: UInt8

        public internal(set) var smoothData: [Int]

        public internal(set) var spectrum: [Int]
    }
    ```

4. 眨眼检测监听

    ```swift
    NotificationCenter.default.addObserver(forName: NotificationName.concentrationBlink.name, object: nil, queue: nil) { notification in
        guard let userInfo = notification.userInfo, let isBlink = userInfo[NotificationKey.concentrationBlinkKey] as? Bool else { return }
        if isBlink {
            // 眨眼了
        }
    }
    ```

5. 注意力谱曲监听
    
    ```swift
    NotificationCenter.default.addObserver(forName: NotificationName.concentrationMusicData.name, object: nil, queue: nil) { notification in
        guard let userInfo = notification.userInfo, let concentrationMusicData = userInfo[NotificationKey.concentrationMusicKey] as? ConcentrationMusic.MusicProcessData else { return }
        // concentrationMusicData 就是注意力音乐信息，详细概念和定义见脑波谱曲文档
    }
    ```

6. 注意力谱曲结果监听

    ```swift
    NotificationCenter.default.addObserver(forName: NotificationName.concentrationMusicFinishData.name, object: nil, queue: nil) { notification in
        guard let userInfo = notification.userInfo, let result = userInfo[NotificationKey.concentrationFinishDataKey] as? ConcentrationMusic.Result else { return }
        // result 就是体验结果信息
    }
    ```

    ```swift
    /// 注意力谱曲结果
    public struct ConcentrationMusic.Result {
        /// 音效次数
        public let soundCount: UInt8
        /// 有效范围内平均注意力值
        public let avgConcentration: UInt8
        /// 排行比例
        public let rankRate: UInt8
        /// 作曲家的相似度
        public let similarRate: UInt8
        /// 作曲家
        public let similarName: ConcentrationMusic.ComposerName
        /// 有效范围内最大注意力值
        public let maxConcentration: UInt8
        /// 有效范围内最小注意力值
        public let minConcentration: UInt8
        /// 最高音
        public let highPitch: String
        /// 最低音
        public let lowPitch: String
    }
    ```

7. 小睡分析数据监听

    ```swift
    NotificationCenter.default.addObserver(forName: NotificationName.napProcessData.name, object: nil, queue: nil) { notification in
        guard let userInfo = notification.userInfo, let napProcessData = userInfo[NotificationKey.napProcessDataKey] as? NapMusic.NapProcessData else { return }
        // napProcessData 就是分析后的数据
    }
    ```

    ```swift
    /// 小睡过程分析数据
    public struct NapProcessData {
        /// 神经网络数值
        public internal (set) var mlpDegree: Double = 0

        /// 放松度
        public internal (set) var napDegree: UInt8 = 0

        /// 实时睡眠状态
        public internal (set) var sleepState: UInt8 = 0

        /// 实时数据质量
        public internal (set) var dataQuality: UInt8 = 0

        /// 声音控制信号
        public internal (set) var soundControl: UInt8 = 0

        /// 实时曲线数据
        public internal (set) var smoothRawData: Data?

        /// α 波能量
        public internal (set) var alphaEngery: UInt8 = 0

        /// β 波能量
        public internal (set) var betaEngery: UInt8 = 0

        /// θ 波能量
        public internal (set) var thetaEngery: UInt8 = 0
    }

    ```

8. 小睡脑波音乐监听

    ```swift
    NotificationCenter.default.addObserver(forName: NotificationName.napMusicData.name, object: nil, queue: nil) { notification in
        guard let userInfo = notification.userInfo, let command = userInfo[NotificationKey.napMusicCommandKey] as? NapMusic.NapMusicCommand else { return }
        // command 就是音乐指令信息，详细概念和定义见脑波谱曲文档
    }
    ```

9. 小睡结果数据

    ```swift
    NotificationCenter.default.addObserver(forName: NotificationName.napFinishData.name, object: nil, queue: nil) { notification in
        guard let userInfo = notification.userInfo, let napFinishData = userInfo[NotificationKey.napFinishDataKey] as? NapMusic.NapFinishData else { return }
        //
    }
    ```
    
    ```swift
   /// 小睡结束数据
    public struct NapFinishData {
        /// 睡眠度
        public internal (set) var sleepScore: UInt8 = 0

        /// 睡眠时长
        public internal (set) var sleepLatency: Double = 0.0

        /// 清醒时长
        public internal (set) var soberDuration: Double = 0

        /// 迷糊时长
        public internal (set) var blurrDuration: Double = 0

        /// 浅睡时长
        public internal (set) var sleepDuration: Double = 0

        /// 睡眠曲线：入睡点坐标
        public internal (set) var sleepPoint: UInt8 = 0

        /// 睡眠曲线：唤醒点坐标
        public internal (set) var alarmPoint: UInt8 = 0

        /// 状态曲线：清醒
        public internal (set) var soberLevelPoint: UInt8 = 0

        /// 状态曲线：迷糊
        public internal (set) var blurrLevelPoint: UInt8 = 0

        /// 状态曲线：浅睡
        public internal (set) var sleepLevelPoint: UInt8 = 0

        /// 体验过程中的数据质量
        public internal (set) var wearQuality: UInt8 = 0

        /// 睡眠状态数据
        public internal (set) var sleepStateData: Data?

        /// 绘制睡眠曲线数据
        public internal (set) var sleepCurveData: Data?
    }
    ```

10. DFU 状态监听

    ```swift
    NotificationCenter.default.addObserver(forName: NotificationName.dfuStateChanged.name, object: nil, queue: nil) { notification in
        guard let userInfo = notification.userInfo, let state = userInfo[NotificationKey.bleStateKey] as? DFUState else { return }
        // state 为 DFU 过程变化的状态
    }
    ```
    
    ```swift
    /// DFU 各阶段状态
    ///
    /// - none: 无状态
    /// - prepared: 设备准备
    /// - upgrading: 正在升级（含进度）
    /// - succeeded: 升级成功
    /// - failed: 升级失败
    public enum DFUState {
    
        case none
    
        case prepared
    
        case upgrading(progress: UInt8)
    
        case succeeded
    
        case failed
    }
    ```

11. 晚睡 Microphone 算法

    首先使用晚睡算法，app 允许麦克风权限。其次需要引入 `BLESDK` 库（算法操作：开始、结束、数据监听等）涉及晚睡数据类型需要引入`BLESDK_Microphone` 库。`BLESDK` 提供权限判断方式：
    
    ``` swift
     if Innerpeace.microphone.state == .unPermission {
            //TODO: do something ....        
        }
    ```
        
    监听实时的分析数据
    
    ```swift 
    NotificationCenter.default.addObserver(forName: NotificationName.sleepMicProcessData.name, object: nil, queue: nil).{ notification in
    let info = notification.userInfo
    let processData = info![NotificationKey.sleepMicProcessDataKey] as? Sleep.MicAnalyzedProcessData
        //TODO: 分析数据
        }
    ```
    
    `BLESDK_Microphone` 库中实时分析数据
    
    ```swift 
    /// swift 类型： 麦克风算法实时分析结果
    public struct MicAnalyzedProcessData {
        /// 时间戳
        public let timestamp: Int
        /// 环境噪声
        public let noiseLv: Double
        /// 鼾声标记
        public let snoreFlag: Bool
        /// 梦话标记
        public let daydreamFlag: Bool
        /// 闹钟信号
        public let alarm: Bool
        /// 动作能量变化
        public let movementEn: Double
        /// 动作频次
        public let movementFreq: Double
        /// 鼾声音频数据
        public let snoreRecData: [Double]
        /// 梦话音频数据
        public let daydreamRecData: [Double]
    }
    ```
    
    监听晚睡算法结果

    ```swift 
    NotificationCenter.default.addObserver(forName: NotificationName.sleepFinishResult.name, object: nil, queue: nil).{ notification in
    let info = notification.userInfo
        let sleepReslut = info![NotificationKey.sleepFinishResultKey] as? Sleep.SleepFinishResult
        //TODO: sleepResult 就是晚睡算法的综合结果
    }
    ```

    晚睡综合结果

    ```swift 
    /// swift 类型：晚睡算法综合得分结果
        public struct SleepFinishResult {
            /// 综合得分
            public let score: Int
            /// 清醒时长
            public let soberLen: Int
            /// 浅睡时长
            public let lightSleepLen: Int
            /// 深睡时长
            public let deepSleepLen: Int
            /// 入睡时长
            public let latencyLen: Int
            /// 睡眠时长（睡着到清醒）
            public let sleepLen: Int
            /// 入睡点
            public let sleepPoint: Int
            /// 唤醒点
            public let alarmPoint: Int
            /// 体验综合数据质量
            public let detectQuality: Int
            /// 睡眠曲线
            public let sleepCurveData: Data
            /// 环境噪声曲线
            public let sleepNoiseLvData: Data
            /// 鼾声记录曲线
            public let sleepSnoresData: Data
            /// 梦话记录曲线
            public let sleepDaydreamData: Data
        }
    ```
