# OC runtime

Runtime 有几个常见的概念：

**动态性** C 语言代码，由代码编译成一个顺序执行文件，编译器完成已经确定代码的执行顺序，但 OC 方法调度是消息机制，在运行时确定方法的调用关系。unrecognized selector...
**消息机制** send_message(identifer,SEL) 格式
**消息转发**



**C 语言的编译过程**

1. 预处理阶段，处理宏定义和 include 文件展开等工作。
2. 生成汇编代码。
3. 汇编到目标代码。（二进制文件）
4. Link 过程，把目标代码和系统或用户提供的库关联起来，生成最终的执行代码。

整个编译过程如下：

源代码 > 预处理器 > 编译器 > 汇编器 > 机器码 > 链接器 > 可执行文件

`源文件经过一系列处理以后，会生成对应的.obj文件，然后一个项目必然会有许多.obj文件，并且这些文件之间会有各种各样的联系，例如函数调用。链接器做的事就是把这些目标文件和所用的一些库链接在一起形成一个完整的可执行文件。`

