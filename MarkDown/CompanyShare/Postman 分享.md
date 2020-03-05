# Postman 分享

Postman 是一个 Chrome 扩展，提供功能强大的 Web API & HTTP 请求调试。它能够发送任何类型的HTTP 请求 (GET, HEAD, POST, PUT..)，附带任何数量的参数+ headers。
支持不同的认证机制（basic, digest, OAuth），接收到的响应语法高亮（HTML，JSON或XML）。[Pasted Graphi](media/14903183330825/Pasted%20Graphic.tiff)Postman 能够保留了历史的请求，这样我们就可以很容易地重新发送请求，有一个“集合”功能，用于存储所有请求相同的API/域。


## Postman 安装



虽然 chrome 有 postman的插件，但是功能不是很全，建议下载 postman app 。[官网下载地址] (https://www.getpostman.com)，选择操作系统。

![](http://enter-image-internal.oss-cn-hangzhou.aliyuncs.com/ipic/2017-03-24-093056.jpg)

点击安装包，安装成功后进入 postman 首页。

![](http://enter-image-internal.oss-cn-hangzhou.aliyuncs.com/ipic/2017-03-24-Pasted%20Graphic%201.tiff)

![](http://enter-image-internal.oss-cn-hangzhou.aliyuncs.com/ipic/2017-03-24-100239.jpg)

postman 的布局如下：

![](http://enter-image-internal.oss-cn-hangzhou.aliyuncs.com/ipic/2017-03-25-011544.jpg)


新建网络接口如下图：

![](http://enter-image-internal.oss-cn-hangzhou.aliyuncs.com/ipic/2017-03-25-014101.jpg)

保存接口信息（command + s）：

![](http://enter-image-internal.oss-cn-hangzhou.aliyuncs.com/ipic/2017-03-25-034759.jpg)
``


## 先看 Demo



Naptime-v2-API-tests

## 单个例子

### write test

1. url
2. GET 请求 参数设置
3. POST 请求 参数设置
4. request、response 对象
    
    <https://www.getpostman.com/docs/sandbox>

4. pre-request script 
5. Tests

### test operation

1. history
2. duplicate

### environment or global variable

postman.setEnvironmentVariable(...)

## Collection

testsuite，将有逻辑的接口串起来，可以用 collection 来实现。

1. 无序
2. 有序

### write test collection

Demo

### run test collection

1. 环境配置
2. 测试次数 
3. 每次跑的时间间隔

## Document

1. 点击 view docs
2. 文档内容


### 优点

1. 不需要封装网络库
2. 有可化话的测试报告
3. 可以导出测试用例、导入测试用例
4. Collection 提供 TestSuite。
5. 操作简单
6. 入门容易

### 缺点

1. 接口误删，找不回来。





