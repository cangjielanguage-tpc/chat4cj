<div align="center">
<h1>Chat RestAPI</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.0.3-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-NA-red" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/domain-Cloud-brightgreen" style="display: inline-block;" />
</p>

## 介绍

Chat RestAPI 是一个用于与 Rocket.Chat 服务器进行交互的 Cangjie 语言客户端库。它提供了完整的 RestAPI 封装，使开发者能够轻松地实现用户认证、频道管理、消息发送等功能。

### 项目特性

- 支持 Rocket.Chat RestAPI
- 支持用户认证和会话管理
- 频道、群组和消息的全面管理功能
- 用户管理和权限控制
- 简单易用的 API 设计

## 项目架构

该库采用面向对象的设计方式，主要通过 RestAPI 类提供所有功能。底层使用 HttpRequestConnector 处理具体的 HTTP 请求。

### 源码目录

```shell
.
├── README.md                                     # 介绍及使用说明
├── doc                                           # 文档目录
├── entry                                         # 示例代码目录
│    └── src/main/cangjie
│                   ├── rest_api_sample.cj        # API 使用示例
│                   └── rest_api_sample_entity.cj # 示例实体类
└── chat
     └── src/main/cangjie
                    ├── rest_api.cj               # 主要的 API 实现
                    └── http_request_connector.cj # HTTP 请求处理

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

详细 API 文档请参考 [API](https://gitcode.com/Cangjie-TPC/chat4cj/blob/chat4cj_cangjie_plugin-5.1.1.840/doc/feature_api.md)

## 使用说明

### 编译构建

1. 通过 module 引入
    1. 克隆下载项目，将 chat 模块拷贝到应用项目下
    2. 在自身应用根目录build-profile.json5的"modules"中添加
       ```json
       {
         "name": "chat",
         "srcPath": "./chat"
       }
       ```
    3. 修改自身应用 entry 下的 oh-package.json5 文件，在 dependencies 字段添加 '@cangjie-tpc/chat': "file:../chat"，点击右上角“Sync Now”
      ```json
      {
        "name": "entry",
        "version": "1.0.0",
        "description": "Please describe the basic information.",
        "main": "",
        "author": "",
        "license": "",
        "dependencies": {
          '@cangjie-tpc/chat': "file:../chat"
        }
      }
      ```
    4. 在entry/src/main/module.json5的"modules"中添加
      ```json
      "requestPermissions": [
        {
          "name": "ohos.permission.INTERNET"
        },
        {
          "name": "ohos.permission.GET_NETWORK_INFO"
        }
      ]
      ```
    5. 在项目中使用 chat
      ```cangjie
      import chat.*
      ```
2. 把 chat 作为三方库依赖引入
    1. 克隆下载项目
	2. 用DevEco Studio打开工程，选中chat目录，点击顶部菜单栏“Build”-“Make Module ‘chat’”构建
    3. 构建成功后，在chat的build/default/outputs目录中找到chat.har，将chat.har拷贝到需要引入的工程中。例如，在需要引入的工程entry目录下新建一个har目录，将chat.har拷贝进去
	4. 打开 entry/oh-package.json5 在 “dependencies” 字段下添加'@cangjie-tpc/chat':   "file:../entry/har/chat.har"，点击右上角“Sync Now”
      ```json
      "dependencies": {
        '@cangjie-tpc/chat': "file:../entry/har/chat.har"
      }
      ```
    5. 在entry/src/main/module.json5的"modules"中添加
      ```json
      "requestPermissions": [
        {
          "name": "ohos.permission.INTERNET"
        },
        {
          "name": "ohos.permission.GET_NETWORK_INFO"
        }
      ]
      ```
    6. 在项目中使用 chat
      ```cangjie
      import chat.*
      ```

### 功能示例
#### 用户登录示例

使用用户名和密码登录：

```cangjie
import chat.*
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
import chat.*
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
import chat.*
import stdx.encoding.json.*
import ohos.hilog.Hilog

main() {
    let api = RestAPI("https://your-rocket-chat-server", "username", "password")
    api.login()
    
    // 创建频道
    let channelData = JsonObject()
    channelData.put("name", JsonString("new-channel"))
    let members = JsonArray()
    members.add(JsonString("user1")) // 需填实际用户名
    members.add(JsonString("user2")) // 需填实际用户名
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
import chat.*
import stdx.encoding.json.*

main() {
    let api = RestAPI("https://your-rocket-chat-server", "username", "password")
    api.login()
    
    // 创建群组
    let groupData = JsonObject()
    groupData.put("name", JsonString("new-group"))
    let members = JsonArray()
    members.add(JsonString("user1")) // 需填实际用户名
    members.add(JsonString("user2")) // 需填实际用户名
    groupData.put("members", members)
    let createResult = api.groupCreate(groupData.toString())
    
    // 添加群组所有者
    let groupId = "xxx" // 需要从createResult中获取群组id
    api.groupAddOwner(groupId, "user1Id") // 需要传入用户id
}
```

## 约束与限制

在下述版本验证通过：

    DevEco Studio 5.1.1 Release(5.1.1.840) 

- 需要有效的 Rocket.Chat 服务器地址
- 部分 API 可能需要管理员权限
- 大部分API 调用前需要先完成登录
- 部分高级功能可能受到服务器配置限制
- 建议在调用API前检查用户权限

## 开源协议
本项目基于 [MIT License](./LICENSE)，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。