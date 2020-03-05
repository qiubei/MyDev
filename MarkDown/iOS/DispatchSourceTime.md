# DispatchSourceTime

~~~
/1. 指定线程 行的)
 /**创建
  * flags: 一个数组，（暂时不知干吗用的，请大神指教）
  * queue: timer 在那个队列里面执
  */
let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())

//2. 默认主线程
let timer = DispatchSource.makeTimerSource()
~~~


