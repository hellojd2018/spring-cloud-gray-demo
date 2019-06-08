# 灰度测试

### eureka元数据

Eureka的元数据有两种，分别为标准元数据和自定义元数据。

> **标准元数据：**主机名、IP地址、端口号、状态页和健康检查等信息，这些信息都会被发布在服务注册表中，用于服务之间的调用。
>
> **自定义元数据：**自定义元数据可以使用`eureka.instance.metadata-map`配置，这些元数据可以在远程客户端中访问，但是一般不会改变客户端的行为，除非客户端知道该元数据的含义


### eureka RestFul接口

| 请求名称                   | 请求方式 | HTTP地址                                                 | 请求描述                                                     |
| -------------------------- | -------- | -------------------------------------------------------- | ------------------------------------------------------------ |
| 注册新服务                 | POST     | /eureka/apps/`{appID}`                                   | 传递JSON或者XML格式参数内容，HTTP code为204时表示成功        |
| 取消注册服务               | DELETE   | /eureka/apps/`{appID}`/`{instanceID}`                    | HTTP code为200时表示成功                                     |
| 发送服务心跳               | PUT      | /eureka/apps/`{appID}`/`{instanceID}`                    | HTTP code为200时表示成功                                     |
| 查询所有服务               | GET      | /eureka/apps                                             | HTTP code为200时表示成功，返回XML/JSON数据内容               |
| 查询指定appID的服务列表    | GET      | /eureka/apps/`{appID}`                                   | HTTP code为200时表示成功，返回XML/JSON数据内容               |
| 查询指定appID&instanceID   | GET      | /eureka/apps/`{appID}`/`{instanceID}`                    | 获取指定appID以及InstanceId的服务信息，HTTP code为200时表示成功，返回XML/JSON数据内容 |
| 查询指定instanceID服务列表 | GET      | /eureka/apps/instances/`{instanceID}`                    | 获取指定instanceID的服务列表，HTTP code为200时表示成功，返回XML/JSON数据内容 |
| 变更服务状态               | PUT      | /eureka/apps/`{appID}`/`{instanceID}`/status?value=DOWN  | 服务上线、服务下线等状态变动，HTTP code为200时表示成功       |
| 变更元数据                 | PUT      | /eureka/apps/`{appID}`/`{instanceID}`/metadata?key=value | HTTP code为200时表示成功                                     |



### 更改自定义元数据

配置文件方式：

```java
eureka.instance.metadata-map.version = v1
```