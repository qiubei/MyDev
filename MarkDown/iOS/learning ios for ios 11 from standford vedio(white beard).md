# learning ios for ios 11 from standford vedio(white beard)

 1. didSet can handle some same code or use lazy
 2. rename handle

    ~~~
    Model: what your application is(but not how it is displayed)
    Controller: how your Model is presented to the user(UI logic)
    View:Your controller's minions
    ~~~
3. xcode shortcut command key

    ~~~
    Command + 1...9: 导航面板上面的内容。
    command + option + 1..?: 页面信息面板的导航内容。
    command + 0: hide/show navigation menu.
    command + option + 0: hide/show utilities.
    command + shift + Y： 弹出 debug 面板内  容。
    command + option + Enter: 双页面
    command + Enter： 回到单页面
    ~~~
4. Swift Programming Language

    1. property: stored property and computed property.
    2. access control: default,private,private(set) just can set inner file,outer just read only,privatefile, public,open
    3. use assert 
    4. must learn to use enum, not just for single value and must learn to use enum funcation (other case type)
    5. must know what's mutating func in enum,and know why. (copy on write 写时复制)
 

**2018-05-09**

1. NSAttributeStringKey and NSAttributeString
2. function and closure(closure is reference type, store in heap)


**2018-05-10**

1. try! vs try (throws)
2. uiview

~~~
init(frame) coding 
init(coder) storyboard
awakeFormNib (storyboard, is called immediatly after initialization is complete )
~~~

3. uifontme****tric s

**2018-05-14**

1. redraw content mode
2. clear color must set opaque setting item


**2018-05-15**

1. rename: Command + 
2. button property: currentTitle
3. controller property: theme
4. timer: must be weak
5. spritekit


**2018-06-11**
1. extension 的方法如果想要继承的话，需要声明 @objc
2. lazy 只在第一次的时候调用，类初始化时不调用。 lazy 的是底层实现：

~~~
lazy var lazyValue: String = {
    ... // do something
    return stirng
}()

等价于 

var _lazyString: String?
var lazyString: String {
    if _lazyString == nil {
        ... // do someting
    }
    return string
}
~~~


**2018-06-12**
1. stack view 里面的 view 约束在使用 hidden 属性会发生变化。


