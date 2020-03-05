#  iOS 问题集合

#### GCD

1. dispatch_async 函数如何实现，分发到主队列和全局队列有什么区别，一定会新建线程执行任务么？
2. dispatch_sync 函数如何实现，为什么说 GCD 死锁是队列导致的而不是线程，死锁不是操作系统的概念么？
3. 信号量是如何实现的，有哪些使用场景？
4. dispatch_group 的等待与通知、dispatch_once 如何实现？
5. dispatch_source 用来做定时器如何实现，有什么优点和用途？
6. dispatch_suspend 和 dispatch_resume 如何实现，队列的的暂停和计时器的暂停有区别么？

#### Runloop

1. RunLoop 延迟回调、触摸事件、屏幕刷新等功能是怎样实现的。
2. 自动释放池实现机制。（讨论与 Runloop 相关的部门）。
3. runloop 是如何管理事件/消息，如何让线程在没有处理消息时休眠以避免资源占用、在有消息到来时立刻被唤醒。

#### UIview

* xib 和 storyboard 上的视图是什么初始的，特别是 IBOutlet 声明的变量。

#### 其他

1. iOS中App的启动时间是由 main 之前和 main 之后两部分时间组成的，指的是什么？
    
    ~~~
    等待答案
    ~~~

2. 一个view从创建到显示过程中经历那些步骤、CPU 和 GPU 在这个过程中都扮演什么角色？
    
    ~~~
    等待答案
    ~~~
    
3. 动画有几种实现方式？

    ~~~
    1. 图片帧的方式，获取 GIF、apng、json 之类的都可以，UI 出。
    2. frmae
    3. 绘制（drawrect、 coreAnimation）
    4. transform、CgAffine。。。
    5. dynamic or animate iterm and property
    6. 

    待补充
    ~~~
    
4. alamofire 解析

    ~~~
        1. 
    ~~~

5. swift 有关拷贝的问题（深拷贝和浅拷贝），特别是集合类型。

    ~~~
    等待答案
    ~~~


6. iOS build 过程（build 到 running），还有类的存储（堆和栈）？

    ~~~
    1. instance的isa指向class
    2. class的isa指向meta-class
    3. meta-class的isa指向基类的meta-class，基类的isa指向自己
    4. class的superclass指向父类的class，如果没有父类，superclass指针为nil
    5. meta-class的superclass指向父类的meta-class，基类的meta-class的superclass指向基类的class
    6. instance调用对象方法的轨迹，isa找到class，方法不存在，就通过superclass找父类
    7. class调用类方法的轨迹，isa找meta-class，方法不存在，就通过superclass找父类
    ~~~

7. 证书、上架等问题整理?

    ~~~
    等待答案
    ~~~


8. 数据库（Realm，sqlite）

    ~~~
    使用和架构，数据迁移。
    ~~~
    
9. 为什么 UI 要在主线程调用？

    ~~~
    等待答案
    ~~~
    
10. https 和 http 关系，https 为什么是安全的？

    ~~~
    等待答案
    ~~~

11. try! 与 try? 区别？？

    ~~~

    ~~~

12. 数据处理与多线程。

    ~~~
    
    ~~~
    
13. Realm 和 sqlite 对比，讲讲各自的特点？

    ~~~
    ~~~
    
14. Alamofire 结构详解

    ~~~
    
    ~~~

15. RunLoop 的中 timer 和 scrollview 同时存在，mode 切换问题的改变。

    ~~~
    
    ~~~

16. 在SDWebImageDownloaderOperation类,NSURLConnectionDataDelegate相关代理方法首先确保RunLoop运行在后台线程，当UI处于”空闲“（NSRunLoopDefault）把图片的下载操作加入到RunLoop，这样来保证混滑动图片的流畅性，所以当你把快速滑动UITableView时，图片不会立即显示，当处于空闲状态时图片才显示，原因就在这里。代码实现是怎样的呢？

    ~~~
    实现一个tableview，然后和 timer 来打印 print。
    ~~~


17. CPU 和 GPU 的工作内容

    **CPU**
    加载资源，对象创建，对象调整，对象销毁，布局计算，Autolayout，文本计算，文本渲染，图片        的解码， 图像的绘制（Core Graphics）都是在CPU上面进行的。
    
    **GPU**
    GPU的渲染性能要比CPU高效很多，同时对系统的负载和消耗也更低一些，所以在开发中，我们应该尽量让CPU负责主线程的UI调动，把图形显示相关的工作交给GPU来处理，当涉及到光栅化等一些工作时，CPU也会参与进来，这点在后面再详细描述。
相对于CPU来说，GPU能干的事情比较单一：接收提交的纹理（Texture）和顶点描述（三角形），应用变换（transform）、混合（合成）并渲染，然后输出到屏幕上。通常你所能看到的内容，主要也就是纹理（图片）和形状（三角模拟的矢量图形）两类。

18. signed 和 unsigned、retain 等的区别


19.  UI 的刷新和什么有关？RunLoop 还是线程？
20. bounds 与 frame 的区别，点、像素和的单位的概念。这里还有一个坐标的概念，需要搞清楚。。。


