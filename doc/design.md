# RocketLib REST API 库设计文档

## 描述

RocketLib REST API 是一个用于与 Rocket.Chat 服务器进行交互的 Cangjie 语言客户端库。该库提供了完整的 REST API 封装，使开发者能够轻松地实现用户认证、频道管理、消息发送等功能。

## 设计目标

- 提供完整的 Rocket.Chat REST API 支持
- 简单易用的 API 设计
- 可靠的错误处理机制
- 良好的扩展性

## 核心类设计

### RestAPI 类

#### 类描述

RestAPI 类是该库的主要入口类，提供了所有 Rocket.Chat REST API 的封装实现。采用面向对象的设计方式，通过统一的接口设计，使开发者能够方便地调用各种功能。

#### 类API

```cangjie
public class RestAPI {
    // 构造函数
    public init(url: String, username: String, password: String)

    // 认证相关 API
    public func login(): String
    public func loginWithAuthToken(authToken: String): String
    public func logout(): String
    public func loggedIn(): Bool

    // 频道管理 API
    // - 基础操作
    public func createChannel(channel: String): String
    public func archiveChannel(roomId: String): String
    public func unArchiveChannel(roomId: String): String

    // - 成员管理
    public func addAllChannel(roomId: String, activeUsersOnly: Bool): String
    public func addLeaderChannel(roomId: String, userId: String): String
    public func kickChannel(roomId: String, userId: String): String

    // - 设置管理
    public func setAnnouncementChannel(roomId: String, announcement: String): String
    public func setCustomFieldsChannel(roomId: String, roomName: String, customField: JsonObject): String
    public func setTopicChannel(roomId: String, topic: String): String

    // 群组管理 API
    // - 基础操作
    public func groupCreate(group: String): String
    public func groupArchive(groupID: String): String
    public func groupUnArchive(groupID: String): String

    // - 成员管理
    public func groupAddAll(groupID: String, activeUsersOnly: Bool): String
    public func groupAddOwner(groupID: String, userId: String): String
    public func groupKick(groupID: String, userId: String): String

    // - 设置管理
    public func groupSetDescription(groupID: String, groupDescription: String): String
    public func groupSetTopic(groupID: String, groupTopic: String): String
    public func groupSetType(groupID: String, groupType: String): String

    // 消息操作 API
    public func postMessageChat(postMessageData: String): String
    public func updateMessageChat(updateMsg: String): String
    public func deleteMessageChat(roomId: String, msgId: String, asUser: Bool): String

    // 用户管理 API
    public func userCreate(data: String): String
    public func userDelete(userId: String, confirmRelinquish: Bool): String
    public func usersInfo(user_id: String, userName: String): String
    public func usersPresence(userId: String, userName: String): String
    public func setAvatar(avatarUrl: String): String

    // 访客管理 API
    public func pageVisited(pageData: String): String
    public func visitorRegistration(visitor: String): String
    public func visitor(token: String): String

    // 系统管理 API
    public func settings(): String
    public func me(): String
}
```

### HttpRequestConnector 类

#### 类描述

HttpRequestConnector 类负责处理与 Rocket.Chat 服务器的 HTTP 通信，封装了请求的发送和响应的处理。支持认证管理和各种 HTTP 方法。

#### 类API

```cangjie
public class HttpRequestConnector {
    // 构造函数
    public init(serverUrl: String)

    // HTTP 方法
    public func get(endpoint: String, data: String): Response
    public func post(endpoint: String, data: String): Response
    public func put(endpoint: String, data: String): Response
    public func delete(endpoint: String, data: String): Response

    // 认证管理
    public func setUserData(authToken: String, userId: String): Unit
    public func loggedIn(): Bool
}

// 认证数据结构
public struct Authdata {
    let authToken: String
    let userId: String
}

// 登录结果结构
public struct LoginResultAPI {
    let status: String
    let data: Authdata
}
```

## 架构设计

### 整体架构

```
┌──────────────────────────────────────────────────┐
│                    应用层                         │
└──────────────────────────────────────────────────┘
                      ↓ 调用
┌──────────────────────────────────────────────────┐
│                  RestAPI 接口层                   │
│  ┌────────────┐ ┌─────────┐ ┌──────────┐         │
│  │ 频道管理API │ │群组管理API│ │消息操作API│ ...     │
│  └────────────┘ └─────────┘ └──────────┘         │
└──────────────────────────────────────────────────┘
                      ↓ 使用
┌──────────────────────────────────────────────────┐
│              HttpRequestConnector                │
│        (HTTP通信层处理请求和认证管)                  │
└──────────────────────────────────────────────────┘
                      ↓ 请求
┌──────────────────────────────────────────────────┐
│               Rocket.Chat 服务器                  │
└──────────────────────────────────────────────────┘
```

### 设计原则

1. **分层设计**
   
   - API层：提供友好的接口封装
   - 通信层：处理HTTP通信细节
   - 数据层：使用JSON格式交换数据

2. **统一规范**
   
   - 所有API返回JSON字符串格式
   - 统一的错误处理机制
   - 规范的接口命名

3. **可扩展性**
   
   - 模块化设计便于扩展
   - 支持添加新的API
   - 灵活的配置选项

## 使用示例

### 基础使用

```cangjie
import rocketlib.*

main() {
    // 创建API实例
    let api = RestAPI("https://your-rocket-chat-server", "username", "password")

    // 登录
    let loginResult = api.login()
    print("Login result: ${loginResult}")
}
```

### 频道管理

```cangjie
import rocketlib.*
import encoding.json.*

main() {
    let api = RestAPI("https://your-rocket-chat-server", "username", "password")
    api.login()

    // 创建频道
    let channelData = JsonObject()
    channelData.put("name", JsonString("new-channel"))
    channelData.put("members", JsonArray(["user1", "user2"]))
    let result = api.createChannel(channelData.toString())

    print("Channel created: ${result}")
}
```

### 消息发送

```cangjie
import rocketlib.*
import encoding.json.*

main() {
    let api = RestAPI("https://your-rocket-chat-server", "username", "password")
    api.login()

    // 发送消息
    let msgData = JsonObject()
    msgData.put("channel", JsonString("general"))
    msgData.put("text", JsonString("Hello, World!"))

    let result = api.postMessageChat(msgData.toString())
    print("Message sent: ${result}")
}
```

## 版本规划

### v0.0.1 (当前版本)

- 实现基础API功能
- 提供基本的错误处理
- 完整的API文档

### v0.1.0 (计划中)

- 完善错误处理机制
- 添加更多单元测试
- 性能优化

### v1.0.0 (计划中)

- 添加WebSocket支持
- 完整的异常处理
- 更多高级功能支持