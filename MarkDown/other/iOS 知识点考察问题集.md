# iOS 知识点考察问题集

#### GCD

1. dispatch_async 函数如何实现，分发到主队列和全局队列有什么区别，一定会新建线程执行任务么？
2. dispatch_sync 函数如何实现，为什么说 GCD 死锁是队列导致的而不是线程，死锁不是操作系统的概念么？
3. 信号量是如何实现的，有哪些使用场景？
4. dispatch_group 的等待与通知、dispatch_once 如何实现？
5. dispatch_source 用来做定时器如何实现，有什么优点和用途？
6. dispatch_suspend 和 dispatch_resume 如何实现，队列的的暂停和计时器的暂停有区别么？

