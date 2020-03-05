# iOS 其它难点

## 编译过程

总体有四个过程：预编译 - 生成汇编语言 - 生成目标语言 - 链接（link）（组成一个可以运行的序列代码）

1. 预编译阶段：宏展开等操作（把编辑器做的语法糖转成相应的语言）
2. 高级语言 - 汇编语言经过：

    - `词法分析` （符号表）
    - `语法分析` （AST）
    - `语义分析` （ASL 插入警告和错误）
    - `Clang Importer`  (OC 代码的`语义分析`)，生成的 AST，然后生成 OC 和 swift 整的 AST
    - `SIL generation` 生成中间语言

## 启动加载

1. 加载 Mach-O（可理解成 .exe） 镜像
2. 加载 dylib (动态链接库，carthage)
3. fix-ups: 重新整理 dylib 之间的关系，dylib 地址偏移，类地址偏移（category修改别的 dylib 中的类）
4. 加载类 `+load`（category 的过程） -> `+initialize`

## 启动优化
1. embed dylib 合成一个
2. 使用 swift 结构体，避免类的加载和 fix-ups
3. 少用静态变量，类加载时分配内存


（静态库与动态库的概念）


