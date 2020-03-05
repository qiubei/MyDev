# Enter-AffectiveComputing-iOS-SDK

# 目录

* [目录](#目录)
* [SDK 说明](#SDK-说明)
  * [结构说明](#结构说明)
  * [安装集成](#安装集成)
    * [Cocoapods](#Cocoapods)
* [情感云 SDK API 使用说明](#情感云-SDK-API-使用说明)
    * [情感云结构](#情感云结构)
        * [使用需知](#使用需知)
        * [模块的逻辑关系](#模块的逻辑关系)
        * [生物数据与情感数据的对应关系](#生物数据与情感数据的对应关系)
    * [情感云 session（开启、关闭和代理）](#情感云-session (开启、关闭和代理))
        * [方法说明](#方法说明)
        * [示例代码](#示例代码)
        * [参数说明](#参数说明)
    * [请求生物数据服务](#请求生物数据服务)
        * [方法说明1](#方法说明1)
        * [示例代码1](#示例代码1)
        * [参数说明1](#参数说明1)
    * [请求情感数据服务 （Affective 服务）](#请求情感数据服务-(Affective-服务))
        * [方法说明2](#方法说明2)
        * [示例代码2](#示例代码2)
        * [参数说明2](#参数说明2)
    * [获取情感云数据代理(CSResponseDelegate)](#获取情感云数据代理(CSResponseDelegate))
  
# SDK 说明

情感云 SDK 是一个根据脑波数据和心率数据来分析情感数据的一个云算法平台，目前 SDK 能根据你的脑波数据和心率数据快速分析出你当前脑波和心率的状态，同时能给出包括：放松度、注意力、愉悦值，压力值、激动度（内测）在内的多种值。详情请查看<a href='https://docs.affectivecloud.com'>官网</a>.

## 结构说明

业务层只需要实例化 `CSClient` 类就可以请求情感云数据，通过代理 `CSResponseDelegate` 来获取情感云分析后的结果。具体 `CSClient` 方法的功能介绍请看 [情感云 SDK API 使用说明](#情感云 SDK-API 使用说明)

![](media/15644764106226/15659273084519.jpg)


## 安装集成
### Cocoapods

添加下面内容到你的 Podfile。

~~~ruby
# 指定 pod 仓库源
source 'git@github.com:EnterTech/PodSpecs.git'


target 'Your Target' do
    pod 'EnterAffectiveCloud', '~> 1.0.0'
end
~~~

运行 `pod  install` 安装命令.

# 情感云 SDK API 使用说明

分析情感云，我们将会从下面`情感云结构`和 `API 说明`两个方面展开。

## 情感云结构

从服务的角度，我们将情感云分为三类服务，第一种服务是与连接相关的 `session 服务`，第二种服务是情感云分析原始数据的`生物数据服务`和第三种情感云分析情感数据的`情感数据服务`。

### 使用需知

**1. 情感云分为三大模块：情感云 session 服务（开启、关闭和代理）、生物数据服务和情感数据服务 （Affective 服务）**
**2. 必须开启情感云后，才会有生物数据处理和情感数据处理服务。**
**3. 必须开启对应的生物数据处理服务（.eeg 和 .hr）才会有情感云情感数据；而且不同的生物数据对应不同的情感数据。详情图如下>>**
**4. 获取情感云的返回数据必须通过 delegate 来获取。**

### 模块的逻辑关系

![](media/15644764106226/15656655529982.jpg)

### 生物数据与情感数据的对应关系

<table>
  <tr>
    <th>生物数据服务</th>
    <th>情感数据服务</th>
    <th>说明</th>
  </tr>
  <tr>
    <td rowspan = "2">心率数据服务（.hr）</td>
    <td>pressure</td>
    <td>压力值：表示您的压力水平</td>
  </tr>
  <tr>
    <td>arousal</td>
    <td>激活度：表示您的激动水平</td>
  </tr>
  <tr>
    <td rowspan="3">脑电数据服务（.eeg）</td>
    <td>attention</td>
    <td>专注度：表示您的专注水平</td>
  </tr>
  <tr>
    <td>relaxation</td>
    <td>放松度：表示您的放松水平</td>
  </tr>
  <tr>
    <td>pleasure</td>
    <td>愉悦度：表示您的愉悦水平</td>
  </tr>
</table>

## 情感云 session（开启、关闭和代理）

```swift
init(wssURL: URL)
var cloudServiceDelegate: CSResponseDelegate?
func startCloudService(appKey: String, appSecret: String, username: String, uniqueID: String)
func sessionRestore()           
func closeCloudService()
```

### 方法说明

`init(wssURL: URL)` 初始化情感云，在调用这个方法后，会开启与情感云连接。 
`cloudServiceDelegate` 业务层通过这个代理获取情感云的返回数据，详情请参见[获取情感云数据](#jump6)。
`startCloudService(...)` 开启情感云服务。在使用其他服务前必须使用调用这个方法。
`sessionRestore()` 这个方法在情感云中断（网络或者其他原因导致的中断）后恢复之前的 session 连接。如果情感云中断时间超过 10 min, 调用该方法无效。
`closeCloudService()` 关闭情感云服务。调用这个方法后会关闭所有情感服务，并且会断开情感云连接。

### 示例代码

~~~swift
import EnterAffectiveCloud

// 初始化情感云
func setup() {
    client = CSClient(wss: YOUR_WSS_URL)
    self.client.delegate = self //implement the delegate
}

// 在 CSResponseDelegate 代理方法 websocketState(...) 中开启情感云
func websocketState(client: CSClient, state: CSState) {
    ...
    if state == .connected {
        self.client.startCloudService(appKey: YourAppKey,
                                      appSecret: YourAppSecret,
                                      userName: YourUserName,
                                      uniqueID: yourAppUniqueID)
    }
}

...

// restore 操作``
func restoreAction(_ sender: UIButton) {
    ...
    self.client.sessionRestore()
}

// 结束体验，在所有服务结束后需要调用 closeCloudService
func finishAction(_ sernder: UIButton) {
    ...
    self.client.closeCloudService()
}
~~~

### 参数说明

|参数|类型|说明|
|:--:|:--:|:--:|
| wssURL | String | 情感云服务器链接 |

|参数|类型|说明|
|:--:|:--:|:--:|
| appKey | String | 由我们后台生成的：App Key |
| appSecret | String | 由我们后台生成的：App Secret|
| username | String | 由我们后台生成的：username |
| uniqueID | String | 开发平台用户的唯一识别码 |


## 请求生物数据服务

`生物数据服务` 情感云对采集到的硬件生物数据进行简单分析，把不同的分析结果以服务的形式返回给客户端。具体服务请参考**参数说明**。

```
func biodataInitial(serivices: BiodataTypeOptions)
func biodataAppend(eegData: [UInt8])
func biodataAppend(hrData: [UInt8])
func biodataSubscribe(serivices: BiodataParameterOptions)
func biodataUnSubscribe(serivices: BiodataParameterOptions)
func biodataReport(services: BiodataTypeOptions)
```

### 方法说明1

* `biodataInitial(serivices: BiodataTypeOptions)`  这个方法根据`多选参数`  [BiodataTypeOptions](#jump1) 用来初始化生物数据服务，目前有两种生物数据：`脑电数据`和`心率数据`。同时这个方法也是后面所有服务的基础(**必须调用这个才有后面的服务**)。
* `biodataAppend(eegData: Data)` 这个方法向情感云添加硬件采集到的脑电数据，然后再由情感云中的算法分析,并返回相应的脑电服务数据。可以在 `FlowtimeBLESDK` 的脑电数据回调中直接调用。
* `biodataAppend(hrData: Data)` 这个方法向情感云添加硬件采集到的心率数据，然后再由情感云中的算法分析,并返回相应的心率服务数据。可以在 `FlowtimeBLESDK` 的脑电数据回调中直接调用。
* `biodataSubscribe(serivices: BiodataParameterOptions)` 这个方法根据`多选参数`  [BiodataParameterOptions](#jump2) 请求情感云实时获取生物数据服务，以订阅的方式获取想要的`数据服务`。订阅后根据代理`CSResponseDelegate` 获取服务数据。
* `biodataUnSubscribe(serivices: BiodataParameterOptions)` 这个方法根据`多选参数`  [BiodataParameterOptions](#jump2) 取消订阅对应的数据。
* `biodataReport(services: BiodataTypeOptions)` 这个方法根据`多选参数`  [BiodataTypeOptions](#jump1)向情感云请求获取生物数据类型报表。

### 示例代码1

~~~ swift
import EnterAffectiveCloud

// 开启生物信号
func startBioataServices() {
    self.client.biodataInitial(services: [.EEG, .HeartRate])
    self.client.biodataSubscribe(services: [.eeg_all, .hr_all])
    ...
}

// 原始脑电数据：硬件监听方法
func brainData() {
    ...
    self.client.biodataAppend(eegData: data)
}

// 心率数据： 硬件监听方法
func hrData() {
    ...
    self.client.biodataAppend(hrData: data)
}

// 结束体验
func finish() {
    // generate report
    self.client.biodataReport(services: [.EEG, .HeartRate])
    // unsubscribe services
    self.client.biodataUnsubscribe(services: [.eeg_all, .hr_all])
    ...
}

~~~

### 参数说明1

**<span id="jump1">生物数据类型（BiodataTypeOptions）</span>**

|名称|说明|
|:--:|:--:|
| EEG | 脑波数据 |
| HeartRate | 心率数据 |

**<span id="jump2">生物数据服务（BiodataParameterOptions）</span>**

|名称|说明|
|:--:|:--:|
| eeg_wave_left | 脑电波：左通道脑波数据 |
| eeg_wave_right | 脑电波：右通道脑波数据 |
| eeg_alpha | 脑电波频段能量：α 波 |
| eeg_beta | 脑电波频段能量：β 波 |
| eeg_theta | 脑电波频段能量：θ 波 |
| eeg_delta | 脑电波频段能量：δ 波 |
| eeg_gamma | 脑电波频段能量：γ 波 |
| eeg_quality | 脑电波数据质量 |
| hr_value | 心率 |
| hr_variability | 心率变异性 |
| eeg_all | 所有脑波数据服务（包含上面所有 `eeg_` 开头的服务）|
| hr_all | 所有心率数据服务 （包含上面所有 `hr_` 开头的服务）|

## 请求情感数据服务 （Affective 服务）

`情感数据服务` 根据上传的生物数据，我们可以分析出不同的情感数据，每种情感数据对应 [情感数据服务](#jump3)。

```
func emotionStart(services: CSEmotionsAffectiveOptions)
func emotionReport(services: CSEmotionsAffectiveOptions)
func emotionSubscribe(options: CSAffectiveSubscribeOptions)
func emotionUnSubscribe(options: CSAffectiveSubscribeOptions)
func emotionClose(services: CSEmotionsAffectiveOptions)
```

### 方法说明2

* `emotionStart(services: CSEmotionsAffectiveOptions)` 这个方法根据`多选参数` [CSEmotionsAffectiveOptions](#jump3) 开启情感服务，是获取实时分析数据和获取报表数据的基础。
* `emotionReport(services: CSEmotionsAffectiveOptions)` 这个方法根据`多选参数` [CSEmotionsAffectiveOptions](#jump3) 向情感云请求情感数据的报表。
* `emotionSubscribe(options: CSAffectiveSubscribeOptions)` 这个方法根据`多选参数` [CSAffectiveSubscribeOptions](#jump4) 向情感云获取对应的`实时情感数据服务`，以订阅的方式获取数据。订阅后根据代理 `CSResponseDelegate` 获取服务数据。
* `emotionUnSubscribe(options: CSAffectiveSubscribeOptions)` 这个方法根据`多选参数` [CSAffectiveSubscribeOptions](#jump4) 向情感云取消订阅情感数据服务。取消订阅后`情感云`停止返回实时数据。
* `emotionClose(services: CSEmotionsAffectiveOptions)`这个方法根据`多选参数` [CSEmotionsAffectiveOptions](#jump3) 关闭情感服务。

### 示例代码2 

~~~ swift
    // 开启情感数据服务
    func startEmotionServices() {
        self.client.emotionStart(services: [.attention, .relaxation, .pleasure, .pressure])
        self.client.emotionSubscribe(services: [.attention, .relaxation, .pressure, .pleasure])
    }
    
    // 结束体验
    func finish() {
        ...
        self.client.emotionReport(services: [.relaxation, .attention, .pressure, .pleasure])
        self.client.emotionUnsubscribe(services: [.attention, .relaxation, .pressure, .pleasure])
        self.client.emotionClose(services: [.attention, .relaxation, .pressure, .pleasure])
        ...
    }
~~~

### 参数说明2

**<span id="jump3">情感数据服务（CSEmotionsAffectiveOptions）</span>**

|名称|说明|
|:--:|:--:|
| attention | 专注度服务 （依赖脑波数据）|
| relaxation | 放松度服务 （依赖脑波数据）|
| pressure | 压力水平服务 （依赖心率数据）|
| pleasure | 愉悦度服务 （依赖脑波数据）|
| arousal | 激活度服务 （依赖心率数据）|

**<span id="jump4">情感数据订阅服务（CSAffectiveSubscribeOptions）</span>**

|名称|说明|
|:--:|:--:|
| attention | 专注度服务 （依赖脑波数据）|
| relaxation | 放松度服务 （依赖脑波数据）|
| pressure | 压力水平服务 （依赖心率数据）|
| pleasure | 愉悦度服务 （依赖脑波数据）|
| arousal | 激活度服务 （依赖心率数据）|

**<span id="jump5">情感报表数据服务（CSAffectiveReportOptions）</span>**

|名称|说明|
|:--:|:--:|
| attention | 专注度服务 |
| relaxation | 放松度服务 |
| pressure | 压力水平服务 |
| pleasure | 愉悦度服务 |
| arousal | 激活度服务 |
| attention | 专注度服务 |
| relaxation | 放松度服务 |
| pressure | 压力水平服务 |
| pleasure | 愉悦度服务 |
| arousal | 激活度服务 |
| pleasure | 愉悦度服务 |
| arousal | 激活度服务 |

### <span id = "jump6">获取情感云数据代理(CSResponseDelegate)<span>

`CSResponseDelegate` 用来获取情感云返回数据代理。里面包含四类方法： 

* session 回话相关代理方法
* biodata 生物数据
* affective 情感数据
* error 错误处理

~~~
// session
func sessionCreate(response: CSResponseJSONModel)
func sessionRestore(response: CSResponseJSONModel)
func sessionClose(response: CSResponseJSONModel)

// biodata
func biodataInitial(response: CSResponseJSONModel)
func biodataSubscribe(response: CSResponseJSONModel)
func biodataUnsubscribe(response: CSResponseJSONModel)
func biodataUpload(response: CSResponseJSONModel)
func biodataReport(response: CSResponseJSONModel)

// affective
func affectiveStart(response: CSResponseJSONModel)
func affectiveSubscribe(response: CSResponseJSONModel)
func affectiveUnsubscribe(response: CSResponseJSONModel)
func affectiveReport(response: CSResponseJSONModel)
func affectiveFinish(response: CSResponseJSONModel)

// error
func error(response: CSResponseJSONModel?, error: CSResponseError, message: String?)
func error(request: CSRequestJSONModel?, error: CSRequestError, message: String?)
~~~



