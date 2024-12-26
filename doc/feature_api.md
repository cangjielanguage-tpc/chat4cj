# RocketLib REST API 接口文档

## 频道相关 API

### addAllChannel
```
/*
* 将所有用户添加到指定频道
* 参数roomId-频道ID
* 参数activeUsersOnly-是否仅添加活跃用户
* 返回操作结果(JSON字符串)
*/
func addAllChannel(roomId: String, activeUsersOnly: Bool): String
```

### addLeaderChannel
```
/*
* 添加频道领导者
* 参数roomId-频道ID
* 参数userId-用户ID
* 返回操作结果(JSON字符串)
*/
func addLeaderChannel(roomId: String, userId: String): String
```

### addModeratorChannel
```
/*
* 添加频道版主
* 参数roomId-频道ID
* 参数userId-用户ID
* 返回操作结果(JSON字符串)
*/
func addModeratorChannel(roomId: String, userId: String): String
```

### addOwnerChannel
```
/*
* 添加频道所有者
* 参数roomId-频道ID
* 参数userId-用户ID
* 返回操作结果(JSON字符串)
*/
func addOwnerChannel(roomId: String, userId: String): String
```

### counterChannel
```
/*
* 获取频道计数信息
* 参数roomId-频道ID
* 返回计数信息(JSON字符串)
*/
func counterChannel(roomId: String): String
```

### getUserAllMentionByChannel
```
/*
* 获取频道中所有提及信息
* 参数roomId-频道ID
* 返回提及信息列表(JSON字符串)
*/
func getUserAllMentionByChannel(roomId: String): String
```

### filesChannel
```
/*
* 获取频道文件列表
* 参数roomId-频道ID
* 参数roomName-频道名称(当roomId为空时使用)
* 返回文件列表(JSON字符串)
*/
func filesChannel(roomId: String, roomName: String): String
```

### historyChannel
```
/*
* 获取频道历史消息
* 参数roomId-频道ID
* 参数optionalParams-可选参数(JSON对象)，包含:
*   - latest: 最新消息时间
*   - oldest: 最早消息时间
*   - inclusive: 是否包含边界消息
*   - offset: 偏移量
*   - count: 消息数量
*   - unreads: 是否包含未读数
* 返回历史消息(JSON字符串)
*/
func historyChannel(roomId: String, optionalParams: JsonValue): String
```

### infoChannel
```
/*
* 获取频道信息
* 参数roomId-频道ID
* 参数roomName-频道名称(当roomId为空时使用)
* 返回频道信息(JSON字符串)
*/
func infoChannel(roomId: String, roomName: String): String
```

### inviteChannel
```
/*
* 邀请用户加入频道
* 参数roomId-频道ID
* 参数userId-被邀请用户ID
* 返回邀请结果(JSON字符串)
*/
func inviteChannel(roomId: String, userId: String): String
```

### joinChannel
```
/*
* 加入频道
* 参数roomId-频道ID
* 参数joinCode-加入码(如果需要)
* 返回加入结果(JSON字符串)
*/
func joinChannel(roomId: String, joinCode: String): String
```

### kickChannel
```
/*
* 将用户踢出频道
* 参数roomId-频道ID
* 参数userId-被踢用户ID
* 返回操作结果(JSON字符串)
*/
func kickChannel(roomId: String, userId: String): String
```

### leaveChannel
```
/*
* 离开频道
* 参数roomId-频道ID
* 返回离开结果(JSON字符串)
*/
func leaveChannel(roomId: String): String
```

### listChannel
```
/*
* 获取所有频道列表
* 返回频道列表(JSON字符串)
*/
func listChannel(): String
```

### joinListChannel
```
/*
* 获取已加入的频道列表
* 返回频道列表(JSON字符串)
*/
func joinListChannel(): String
```

### membersChannel
```
/*
* 获取频道成员列表
* 参数roomId-频道ID
* 参数roomName-频道名称(当roomId为空时使用)
* 返回成员列表(JSON字符串)
*/
func membersChannel(roomId: String, roomName: String): String
```

### messageChannel
```
/*
* 获取频道消息
* 参数roomId-频道ID
* 参数roomName-频道名称(当roomId为空时使用)
* 返回消息列表(JSON字符串)
*/
func messageChannel(roomId: String, roomName: String): String
```

### onlineChannel
```
/*
* 获取频道��线用户
* 参数roomId-频道ID
* 返回在线用户列表(JSON字符串)
*/
func onlineChannel(roomId: String): String
```

### openChannel
```
/*
* 打开频道
* 参数roomId-频道ID
* 返回操作结果(JSON字符串)
*/
func openChannel(roomId: String): String
```

### renameChannel
```
/*
* 重命名频道
* 参数roomId-频道ID
* 参数name-新名称
* 返回重命名结果(JSON字符串)
*/
func renameChannel(roomId: String, name: String): String
```

### rolesChannel
```
/*
* 获取频道角色列表
* 参数roomId-频道ID
* 参数roomName-频道名称(当roomId为空时使用)
* 返回角色列表(JSON字符串)
*/
func rolesChannel(roomId: String, roomName: String): String
```

### setAnnouncementChannel
```
/*
* 设置频道公告
* 参数roomId-频道ID
* 参数announcement-公告内容
* 返回设置结果(JSON字符串)
*/
func setAnnouncementChannel(roomId: String, announcement: String): String
```

### setCustomFieldsChannel
```
/*
* 设置频道自定义字段
* 参数roomId-频道ID
* 参数roomName-频道名称(当roomId为空时使用)
* 参数customField-自定义字段(JSON对象)
* 返回设置结果(JSON字符串)
*/
func setCustomFieldsChannel(roomId: String, roomName: String, customField: JsonObject): String
```

### setJoinCodeChannel
```
/*
* 设置频道加入码
* 参数roomId-频道ID
* 参数joinCode-加入码
* 返回设置结果(JSON字符串)
*/
func setJoinCodeChannel(roomId: String, joinCode: String): String
```

### setPurposeChannel
```
/*
* 设置频道用途说明
* 参数roomId-频道ID
* 参数purpose-用途说明
* 返回设置结果(JSON字符串)
*/
func setPurposeChannel(roomId: String, purpose: String): String
```

### setTypeChannel
```
/*
* 设置频道类型
* 参数roomId-频道ID
* 参数roomName-频道名称(当roomId为空时使用)
* 参数channelType-频道类型
* 返回设置结果(JSON字符串)
*/
func setTypeChannel(roomId: String, roomName: String, channelType: String): String
```

### createChannel
```
/*
* 创建新频道
* 参数channel-频道信息(JSON字符串)，包含:
*   - name: 频道名称
*   - members: 成员列表(可选)
*   - readOnly: 是否只读(可选)
*   - customFields: 自定义字段(可选)
* 返回创建结果(JSON字符串)
*/
func createChannel(channel: String): String
```

### setTopicChannel
```
/*
* 设置频道主题
* 参数roomId-频道ID
* 参数topic-主题内容
* 返回设置结果(JSON字符串)
*/
func setTopicChannel(roomId: String, topic: String): String
```

## 访客相关 API

### pageVisited
```
/*
* 记录访客页面访问
* 参数pageData-页面访问数据(JSON字符串)
* 返回记录结果(JSON字符串)
*/
func pageVisited(pageData: String): String
```

### visitorRegistration
```
/*
* 注册访客
* 参数visitor-访客信息(JSON字符串)
* 返回注册结果(JSON字符串)
*/
func visitorRegistration(visitor: String): String
```

### visitor
```
/*
* 获取访客信息
* 参数token-访客token
* 返回访客信息(JSON字符串)
*/
func visitor(token: String): String
```

### setVisitorStatus
```
/*
* 设置访客状态
* 参数visitor-访客状态信息(JSON字符串)
* 返回设置结果(JSON字符串)
*/
func setVisitorStatus(visitor: String): String
```

### visitorDelete
```
/*
* 删除访客
* 参数token-访客token
* 返回删除结果(JSON字符串)
*/
func visitorDelete(token: String): String
```

## 横幅相关 API

### bannersEndPoint
```
/*
* 获取指定横幅信息
* 参数id-横幅ID
* 返回横幅信息(JSON字符串)
*/
func bannersEndPoint(id: Int64): String
```

### getBanners
```
/*
* 获取所有横幅列表
* 返回横幅列表(JSON字符串)
*/
func getBanners(): String
```

## 群组相关 API

### groupAddLeader
```
/*
* 添加群组领导者
* 参数groupID-群组ID
* 参数userId-用户ID
* 返回操作结果(JSON字符串)
*/
func groupAddLeader(groupID: String, userId: String): String
```

### groupAddModerator
```
/*
* 添加群组版主
* 参数groupID-群组ID
* 参数userId-用户ID
* 返回操作结果(JSON字符串)
*/
func groupAddModerator(groupID: String, userId: String): String
```

### groupInvite
```
/*
* 邀请用户加入群组
* 参数groupID-群组ID
* 参数userId-被邀请用户ID
* 返回邀请结果(JSON字符串)
*/
func groupInvite(groupID: String, userId: String): String
```

### groupKick
```
/*
* 将用户踢出群组
* 参数groupID-群组ID
* 参数userId-被踢用户ID
* 返回操作结果(JSON字符串)
*/
func groupKick(groupID: String, userId: String): String
```

### groupLeave
```
/*
* 离开群组
* 参数groupID-群组ID
* 返回离开结果(JSON字符串)
*/
func groupLeave(groupID: String): String
```

### groupSetReadOnly
```
/*
* 设置群组只读状态
* 参数groupID-群组ID
* 参数readOnly-是否只读
* 返回设置结果(JSON字符串)
*/
func groupSetReadOnly(groupID: String, readOnly: Bool): String
```

### groupSetTopic
```
/*
* 设置群组主题
* 参数groupID-群组ID
* 参数groupTopic-主题内容
* 返回设置结果(JSON字符串)
*/
func groupSetTopic(groupID: String, groupTopic: String): String
```

### groupSetType
```
/*
* 设置群组类型
* 参数groupID-群组ID
* 参数groupType-群组类型
* 返回设置结果(JSON字符串)
*/
func groupSetType(groupID: String, groupType: String): String
```

### groupInfo
```
/*
* 获取群组信息
* 参数roomId-群组ID
* 参数roomName-群组名称(当roomId为空时使用)
* 返回群组信息(JSON字符串)
*/
func groupInfo(roomId: String, roomName: String): String
```

### groupIntegrations
```
/*
* 获取群组集成列表
* 参数roomId-群组ID
* 返回集成列表(JSON字符串)
*/
func groupIntegrations(roomId: String): String
```

### groupList
```
/*
* 获取群组列表
* 返回群组列表(JSON字符串)
*/
func groupList(): String
```

### groupHistory
```
/*
* 获取群组历史消息
* 参数roomId-群组ID
* 参数optionalParams-可选参数(JSON对象)，包含:
*   - latest: 最新消息时间
*   - oldest: 最早消息时间
*   - inclusive: 是否包含边界消息
*   - offset: 偏移量
*   - count: 消息数量
*   - unreads: 是否包含未读数
* 返回历史消息(JSON字符串)
*/
func groupHistory(roomId: String, optionalParams: JsonValue): String
```

### groupRename
```
/*
* 重命名群组
* 参数name-新名称
* 参数groupID-群组ID
* 返回重命名结果(JSON字符串)
*/
func groupRename(name: String, groupID: String): String
```

### groupArchive
```
/*
* 归档群组
* 参数groupID-群组ID
* 返回归档结果(JSON字符串)
*/
func groupArchive(groupID: String): String
```

### groupUnArchive
```
/*
* 取消群组归档
* 参数groupID-群组ID
* 返回取消归档结果(JSON字符串)
*/
func groupUnArchive(groupID: String): String
```

### groupCreate
```
/*
* 创建新群组
* 参数group-群组信息(JSON字符串)，包含:
*   - name: 群组名称
*   - members: 成员列表(可选)
*   - readOnly: 是否只读(可选)
*   - customFields: 自定义字段(可选)
* 返回创建结果(JSON字符串)
*/
func groupCreate(group: String): String
```

### groupOpen
```
/*
* 打开群组
* 参数groupID-群组ID
* 返回打开结果(JSON字符串)
*/
func groupOpen(groupID: String): String
```

### groupClose
```
/*
* 关闭群组
* 参数groupID-群组ID
* 返回关闭结果(JSON字符串)
*/
func groupClose(groupID: String): String
```

### groupAddAll
```
/*
* 将所有用户添加到群组
* 参数groupID-群组ID
* 参数activeUsersOnly-是否仅添加活跃用户
* 返回操作结果(JSON字符串)
*/
func groupAddAll(groupID: String, activeUsersOnly: Bool): String
```

### groupAddOwner
```
/*
* 添加群组所有者
* 参数groupID-群组ID
* 参数userId-用户ID
* 返回操作结果(JSON字符串)
*/
func groupAddOwner(groupID: String, userId: String): String
```

### groupRemoveOwner
```
/*
* 移除群组所有者
* 参数groupID-群组ID
* 参数userId-用户ID
* 返回操作结果(JSON字符串)
*/
func groupRemoveOwner(groupID: String, userId: String): String
```

### groupRemoveModerator
```
/*
* 移除群组版主
* 参数groupID-群组ID
* 参数userId-用户ID
* 返回操作结果(JSON字符串)
*/
func groupRemoveModerator(groupID: String, userId: String): String
```

### groupSetDescription
```
/*
* 设置群组描述
* 参数groupID-群组ID
* 参数groupDescription-描述内容
* 返回设置结果(JSON字符串)
*/
func groupSetDescription(groupID: String, groupDescription: String): String
```

## 系统相关 API

### settings
```
/*
* 获取系统公共设置
* 返回设置信息(JSON字符串)
*/
func settings(): String
```

### me
```
/*
* 获取当前登录用户信息
* 返回用户信息(JSON字符串)
*/
func me(): String
```

## 用户相关 API

### usersList
```
/*
* 获取用户列表
* 参数query-查询条件
* 参数fields-返回字段
* 参数sort-排序方式
* 参数count-返回数量
* 参数offset-偏移量
* 返回用户列表(JSON字符串)
*/
func usersList(query: String, fields: String, sort: String, count: Int64, offset: Int64): String
```

### userCreate
```
/*
* 创建新用户
* 参数data-用户数据(JSON字符串)
* 返回创建结果(JSON字符串)
*/
func userCreate(data: String): String
```

### usersInfo
```
/*
* 获取用户信息
* 参数user_id-用户ID
* 参数userName-用户名(当user_id为空时使用)
* 返回用户信息(JSON字符串)
*/
func usersInfo(user_id: String, userName: String): String
```

### usersPresence
```
/*
* 获取用户在线状态
* 参数userId-用户ID
* 参数userName-用户名(当userId为空时使用)
* 返回在线状态(JSON字符串)
*/
func usersPresence(userId: String, userName: String): String
```

### setAvatar
```
/*
* 设置用户头像
* 参数avatarUrl-头像URL
* 返回设置结果(JSON字符串)
*/
func setAvatar(avatarUrl: String): String
```

### userDelete
```
/*
* 删除用户
* 参数userId-用户ID
* 参数confirmRelinquish-确认放弃所有权
* 返回删除结果(JSON字符串)
*/
func userDelete(userId: String, confirmRelinquish: Bool): String
```

## 聊天相关 API

### postMessageChat
```
/*
* 发送聊天消息
* 参数postMessageData-消息数据(JSON字符串)
* 返回发送结果(JSON字符串)
*/
func postMessageChat(postMessageData: String): String
```

### updateMessageChat
```
/*
* 更新聊天消息
* 参数updateMsg-更新的消息数据(JSON字符串)
* 返回更新结果(JSON字符串)
*/
func updateMessageChat(updateMsg: String): String
```

### deleteMessageChat
```
/*
* 删除聊天消息
* 参数roomId-房间ID
* 参数msgId-消息ID
* 参数asUser-是否以用户身份删除
* 返回删除结果(JSON字符串)
*/
func deleteMessageChat(roomId: String, msgId: String, asUser: Bool): String
```

## 认证相关 API

### login
```
/*
* 用户登录
* 使用用户名/邮箱和密码登录
* 返回登录结果(JSON字符串)
*/
func login(): String
```

### loginWithAuthToken
```
/*
* 使用认证令牌登录
* 参数authToken-认证令牌
* 返回登录结果(JSON字符串)
*/
func loginWithAuthToken(authToken: String): String
```

### logout
```
/*
* 用户登出
* 返回登出结果(JSON字符串)
*/
func logout(): String
```

### loggedIn
```
/*
* 检查是否已登录
* 返回登录状态(布尔值)
*/
func loggedIn(): Bool
```

## 频道管理 API

### closeChannel
```
/*
* 关闭频道
* 参数roomId-频道ID
* 返回关闭结果(JSON字符串)
*/
func closeChannel(roomId: String): String
```

### removeLeaderChannel
```
/*
* 移除频道领导者
* 参数roomId-频道ID
* 参数userId-用户ID
* 返回操作结果(JSON字符串)
*/
func removeLeaderChannel(roomId: String, userId: String): String
```

### removeModeratorChannel
```
/*
* 移除频道版主
* 参数roomId-频道ID
* 参数userId-用户ID
* 返回操作结果(JSON字符串)
*/
func removeModeratorChannel(roomId: String, userId: String): String
```

### removeOwnerChannel
```
/*
* 移除频道所有者
* 参数roomId-频道ID
* 参数userId-用户ID
* 返回操作结果(JSON字符串)
*/
func removeOwnerChannel(roomId: String, userId: String): String
```

### setDefaultChannel
```
/*
* 设置默认频道
* 参数roomId-频道ID
* 参数isDefault-是否为默认频道
* 返回设置结果(JSON字符串)
*/
func setDefaultChannel(roomId: String, isDefault: Bool): String
```

### setReadOnlyChannel
```
/*
* 设置频道只读状态
* 参数roomId-频道ID
* 参数readOnly-是否只读
* 返回设置结果(JSON字符串)
*/
func setReadOnlyChannel(roomId: String, readOnly: Bool): String
```

### archiveChannel
```
/*
* 归档频道
* 参数roomId-频道ID
* 返回归档结果(JSON字符串)
*/
func archiveChannel(roomId: String): String
```

### unArchiveChannel
```
/*
* 取消频道归档
* 参数roomId-频道ID
* 返回取消归档结果(JSON字符串)
*/
func unArchiveChannel(roomId: String): String
```

### getIntegrationChannel
```
/*
* 获取频道集成列表
* 参数roomId-频道ID
* 返回集成列表(JSON字符串)
*/
func getIntegrationChannel(roomId: String): String
```