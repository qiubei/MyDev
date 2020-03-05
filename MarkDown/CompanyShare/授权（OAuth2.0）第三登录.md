# 授权（OAuth2.0）第三登录

**ps: 阮一峰的博客可以看看**

## web

### 6个步骤

client                             |   Server
---------------------------
1. grant request  ---------->  
2. <----------  Resource Owner
3. authorization request  ----------->
4. <----------  Authorization request
5. token request  ---------->
6. <----------- Resource Owner 


## App
### web
流程与上面的相同，他会在 app 内置一个 web 网页。数据都是通过网页。
### sso
找到相应的 app 应用，然后跳转，这里有个 app 间的数据传递不太明确，就是授权成功之后信息返回，松明猜想是利用多个应用的数据传递方式来传递数据。



