# app 的启动过程

* 调用 main() 之前的过程

加载 app 所有的可执行文件（所谓的 Mach-o 文件，可以理解成 exec 文件），然后进行动态库（framework、系统的一些库 libSystem 如：libdispatch、 libsystem_blocks，处理 runtime 方法的 libobjc 等等）链接，动态库链接的过程由 动态链接库 dyld（the dynamic link editor）完成。主要的处理过程如下：

1. 加载镜像。（Load Image）
2. Rebase and Bind （修复错位的指针，这个与 Address space layout Randomization）
3. OBJC setup （Class 注册、category 方法加入方方法列表）
4. initialize

  


