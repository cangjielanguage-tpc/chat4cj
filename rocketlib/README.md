<div align="center">
<h1>RocketLib REST API</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.2-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.0.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-0.0%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/domain-Cloud-brightgreen" style="display: inline-block;" />
</p>

## 介绍

RocketLib REST API 是一个用于与 Rocket.Chat 服务器进行交互的 Cangjie 语言客户端库。它提供了完整的 REST API 封装，使开发者能够轻松地实现用户认证、频道管理、消息发送等功能。

### 项目特性

- 支持 Rocket.Chat REST API
- 支持用户认证和会话管理
- 频道、群组和消息的全面管理功能
- 用户管理和权限控制
- 简单易用的 API 设计

## 项目架构

该库采用面向对象的设计方式，主要通过 RestAPI 类提供所有功能。底层使用 HttpRequestConnector 处理具体的 HTTP 请求。

### 源码目录

```shell
.
├── README.md                                  # 项目说明文档
├── doc                                        # 文档目录
│    └── feature_api.md                        # API 接口文档
├── entry                                      # 示例代码目录
│    └── src
│         └── main
│             └── cangjie
│                  ├── restApiSample.cj        # API 使用示例
│                  └── RestApiSamepleEntity.cj # 示例实体类
└── src
     └── main
          └── cangjie
               └── src
                   ├── RestAPI.cj              # 主要的 API 实现
                   └── HttpRequestConnector.cj # HTTP 请求处理

```

### 接口说明

主要功能分为以下几个模块：

- 认证相关：login、loginWithAuthToken、logout 等
- 频道管理：
  - 基础操作：createChannel、archiveChannel、unArchiveChannel 等
  - 成员管理：addAllChannel、addLeaderChannel、kickChannel 等
  - 设置管理：setAnnouncementChannel、setCustomFieldsChannel、setTopicChannel 等
- 群组管理：
  - 基础操作：groupCreate、groupArchive、groupUnArchive 等
  - 成员管理：groupAddAll、groupAddOwner、groupKick 等
  - 设置管理：groupSetDescription、groupSetTopic、groupSetType 等
- 消息操作：postMessageChat、updateMessageChat、deleteMessageChat
- 用户管理：userCreate、userDelete、usersInfo、usersPresence、setAvatar 等
- 访客管理：pageVisited、visitorRegistration、visitor 等
- 系统管理：settings、me 等

详细 API 文档请参考 [API](./doc/feature_api.md)

## 使用说明

### 功能示例
#### 用户登录示例

使用用户名和密码登录：

```cangjie
import rocketlib.*
import ohos.hilog.Hilog

main() {
    let api = RestAPI("https://your-rocket-chat-server", "username", "password")
    let result = api.login()
    Hilog.info(0, "RestAPI", "result:${result}")
}
```

#### 发送消息示例

向指定频道发送消息：

```cangjie
import rocketlib.*
import stdx.encoding.json.*
import ohos.hilog.Hilog

main() {
    let api = RestAPI("https://your-rocket-chat-server", "username", "password")
    api.login()
    
    let msgData = JsonObject()
    msgData.put("channel", JsonString("general"))
    msgData.put("text", JsonString("Hello, World!"))
    
    let result = api.postMessageChat(msgData.toString())
    Hilog.info(0, "RestAPI", "result:${result}")
}
```

#### 频道管理示例

创建并设置频道：

```cangjie
import rocketlib.*
import stdx.encoding.json.*
import ohos.hilog.Hilog

main() {
    let api = RestAPI("https://your-rocket-chat-server", "username", "password")
    api.login()
    
    // 创建频道
    let channelData = JsonObject()
    channelData.put("name", JsonString("new-channel"))
    let members = JsonArray()
    members.add(JsonString("user1"))
    members.add(JsonString("user2"))
    channelData.put("members", members)
    let createResult = api.createChannel(channelData.toString())
    
    // 设置频道主题
    let roomId = "xxx" // 需要从createResult中获取频道id
    api.setTopicChannel(roomId, "Welcome to the new channel!")
}
```

#### 群组管理示例

创建并管理群组：

```cangjie
import rocketlib.*
import stdx.encoding.json.*

main() {
    let api = RestAPI("https://your-rocket-chat-server", "username", "password")
    api.login()
    
    // 创建群组
    let groupData = JsonObject()
    groupData.put("name", JsonString("new-group"))
    let members = JsonArray()
    members.add(JsonString("user1"))
    members.add(JsonString("user2"))
    groupData.put("members", members)
    let createResult = api.groupCreate(groupData.toString())
    
    // 添加群组所有者
    let groupId = "xxx" // 需要从createResult中获取群组id
    api.groupAddOwner(groupId, "user1Id") // 需要传入用户id
}
```

## 约束与限制

在下述版本验证通过：

    DevEco Studio 5.1.0 Release(5.1.0.828SP1) 
    Cangjie Support Plugin 5.1.0.828
    Cangjie Compiler: 1.0.0(cjnative)

- 需要有效的 Rocket.Chat 服务器地址
- 部分 API 可能需要管理员权限
- 大部分API 调用前需要先完成登录
- 部分高级功能可能受到服务器配置限制
- 建议在调用API前检查用户权限

## 开源协议
本项目基于 [MIT License](./LICENSE)，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。