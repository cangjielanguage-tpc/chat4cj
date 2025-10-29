# chat 库

### 介绍

RocketLib REST API 是一个用于与 Rocket.Chat 服务器进行交互的 Cangjie 语言客户端库。它提供了完整的 REST API 封装，使开发者能够轻松地实现用户认证、频道管理、消息发送等功能。

### RestAPI主要接口

```
public class RestAPI {

    // 频道相关 API
    /*
     * 将所有用户添加到指定频道
     * 参数roomId-频道ID
     * 参数activeUsersOnly-是否仅添加活跃用户
     * 返回操作结果(JSON字符串)
     */
    func addAllChannel(roomId: String, activeUsersOnly: Bool): String
     
    /*
     * 添加频道领导者
     * 参数roomId-频道ID
     * 参数userId-用户ID
     * 返回操作结果(JSON字符串)
     */
    func addLeaderChannel(roomId: String, userId: String): String
     
    /*
     * 添加频道管理员角色
     * 参数roomId-频道ID
     * 参数userId-用户ID
     * 返回操作结果(JSON字符串)
     */
    func addModeratorChannel(roomId: String, userId: String): String
     
    /*
     * 添加频道所有者
     * 参数roomId-频道ID
     * 参数userId-用户ID
     * 返回操作结果(JSON字符串)
     */
    func addOwnerChannel(roomId: String, userId: String): String
     
    /*
     * 获取某个频道的统计信息
     * 参数roomId-频道ID
     * 返回计数信息(JSON字符串)
     */
    func counterChannel(roomId: String): String
     
    /*
     * 获取频道中所有提及信息
     * 参数roomId-频道ID
     * 返回提及信息列表(JSON字符串)
     */
    func getUserAllMentionByChannel(roomId: String): String
     
    /*
     * 获取频道文件列表
     * 参数roomId-频道ID
     * 参数roomName-频道名称(当roomId为空时使用)
     * 返回文件列表(JSON字符串)
     */
    func filesChannel(roomId: String, roomName: String): String
     
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
     
    /*
     * 获取频道信息
     * 参数roomId-频道ID
     * 参数roomName-频道名称(当roomId为空时使用)
     * 返回频道信息(JSON字符串)
     */
    func infoChannel(roomId: String, roomName: String): String
     
    /*
     * 邀请用户加入频道
     * 参数roomId-频道ID
     * 参数userId-被邀请用户ID
     * 返回邀请结果(JSON字符串)
     */
    func inviteChannel(roomId: String, userId: String): String
     
    /*
     * 加入频道
     * 参数roomId-频道ID
     * 参数joinCode-加入码(如果需要)
     * 返回加入结果(JSON字符串)
     */
    func joinChannel(roomId: String, joinCode: String): String
     
    /*
     * 将用户踢出频道
     * 参数roomId-频道ID
     * 参数userId-被踢用户ID
     * 返回操作结果(JSON字符串)
     */
    func kickChannel(roomId: String, userId: String): String
     
    /*
     * 离开频道
     * 参数roomId-频道ID
     * 返回离开结果(JSON字符串)
     */
    func leaveChannel(roomId: String): String
     
    /*
     * 获取所有频道列表
     * 返回频道列表(JSON字符串)
     */
    func listChannel(): String
     
    /*
     * 获取已加入的频道列表
     * 返回频道列表(JSON字符串)
     */
    func joinListChannel(): String
     
    /*
     * 获取频道成员列表
     * 参数roomId-频道ID
     * 参数roomName-频道名称(当roomId为空时使用)
     * 返回成员列表(JSON字符串)
     */
    func membersChannel(roomId: String, roomName: String): String
     
    /*
     * 获取频道消息
     * 参数roomId-频道ID
     * 参数roomName-频道名称(当roomId为空时使用)
     * 返回消息列表(JSON字符串)
     */
    func messageChannel(roomId: String, roomName: String): String
     
    /*
     * 获取频道当前在线用户
     * 参数roomId-频道ID
     * 返回在线用户列表(JSON字符串)
     */
    func onlineChannel(roomId: String): String
     
    /*
     * 打开频道
     * 参数roomId-频道ID
     * 返回操作结果(JSON字符串)
     */
    func openChannel(roomId: String): String
     
    /*
     * 重命名频道
     * 参数roomId-频道ID
     * 参数name-新名称
     * 返回重命名结果(JSON字符串)
     */
    func renameChannel(roomId: String, name: String): String
     
    /*
     * 获取频道角色列表
     * 参数roomId-频道ID
     * 参数roomName-频道名称(当roomId为空时使用)
     * 返回角色列表(JSON字符串)
     */
    func rolesChannel(roomId: String, roomName: String): String
     
    /*
     * 设置频道公告
     * 参数roomId-频道ID
     * 参数announcement-公告内容
     * 返回设置结果(JSON字符串)
     */
    func setAnnouncementChannel(roomId: String, announcement: String): String
     
    /*
     * 设置频道自定义字段
     * 参数roomId-频道ID
     * 参数roomName-频道名称(当roomId为空时使用)
     * 参数customField-自定义字段(JSON对象)
     * 返回设置结果(JSON字符串)
     */
    func setCustomFieldsChannel(roomId: String, roomName: String, customField: JsonObject): String
     
    /*
     * 设置频道加入码
     * 参数roomId-频道ID
     * 参数joinCode-加入码
     * 返回设置结果(JSON字符串)
     */
    func setJoinCodeChannel(roomId: String, joinCode: String): String
     
    /*
     * 设置频道用途说明
     * 参数roomId-频道ID
     * 参数purpose-用途说明
     * 返回设置结果(JSON字符串)
     */
    func setPurposeChannel(roomId: String, purpose: String): String
     
    /*
     * 设置频道类型
     * 参数roomId-频道ID
     * 参数roomName-频道名称(当roomId为空时使用)
     * 参数channelType-频道类型
     * 返回设置结果(JSON字符串)
     */
    func setTypeChannel(roomId: String, roomName: String, channelType: String): String
     
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
     
    /*
      * 删除一个频道（永久移除）
      * 参数roomId-频道ID
      * 参数roomName-频道名称(当roomId为空时使用)
      * 返回删除结果
      */
     public func deleteChannel(roomId: String, roomName: String): String
     
    /*
     * 设置频道主题
     * 参数roomId-频道ID
     * 参数topic-主题内容
     * 返回设置结果(JSON字符串)
     */
    func setTopicChannel(roomId: String, topic: String): String
     
    // 访客相关 API
    /*
     * 记录访客页面访问数据
     * 参数pageData-页面访问数据(JSON字符串)
     * 返回记录结果(JSON字符串)
     */
    func pageVisited(pageData: String): String
     
    /*
     * 注册访客
     * 参数visitor-访客信息(JSON字符串)
     * 返回注册结果(JSON字符串)
     */
    func visitorRegistration(visitor: String): String
     
    /*
     * 获取访客信息
     * 参数token-访客token
     * 返回访客信息(JSON字符串)
     */
    func visitor(token: String): String
     
    /*
     * 设置访客状态
     * 参数visitor-访客状态信息(JSON字符串)
     * 返回设置结果(JSON字符串)
     */
    func setVisitorStatus(visitor: String): String
     
    /*
     * 删除访客
     * 参数token-访客token
     * 返回删除结果(JSON字符串)
     */
    func visitorDelete(token: String): String
     
    // 横幅相关 API
    /*
     * 获取指定横幅信息
     * 参数id-横幅ID
     * 返回横幅信息(JSON字符串)
     */
    func bannersEndPoint(id: Int64): String
     
    /*
     * 获取所有横幅列表
     * 返回横幅列表(JSON字符串)
     */
    func getBanners(): String
     
    // 群组相关 API
    /*
     * 添加群组领导者
     * 参数groupID-群组ID
     * 参数userId-用户ID
     * 返回操作结果(JSON字符串)
     */
    func groupAddLeader(groupID: String, userId: String): String
     
    /*
     * 添加群组管理员
     * 参数groupID-群组ID
     * 参数userId-用户ID
     * 返回操作结果(JSON字符串)
     */
    func groupAddModerator(groupID: String, userId: String): String
     
    /*
     * 邀请用户加入群组
     * 参数groupID-群组ID
     * 参数userId-被邀请用户ID
     * 返回邀请结果(JSON字符串)
     */
    func groupInvite(groupID: String, userId: String): String
     
    /*
     * 将用户踢出群组
     * 参数groupID-群组ID
     * 参数userId-被踢用户ID
     * 返回操作结果(JSON字符串)
     */
    func groupKick(groupID: String, userId: String): String
     
    /*
     * 离开群组
     * 参数groupID-群组ID
     * 返回离开结果(JSON字符串)
     */
    func groupLeave(groupID: String): String
     
    /*
     * 设置群组只读状态
     * 参数groupID-群组ID
     * 参数readOnly-是否只读
     * 返回设置结果(JSON字符串)
     */
    func groupSetReadOnly(groupID: String, readOnly: Bool): String
     
    /*
     * 设置群组主题
     * 参数groupID-群组ID
     * 参数groupTopic-主题内容
     * 返回设置结果(JSON字符串)
     */
    func groupSetTopic(groupID: String, groupTopic: String): String
     
    /*
     * 设置群组类型
     * 参数groupID-群组ID
     * 参数groupType-群组类型
     * 返回设置结果(JSON字符串)
     */
    func groupSetType(groupID: String, groupType: String): String
     
    /*
      * 设置群组用途
      * 参数 roomId       - 群组 ID
      * 参数 groupPurpose - 群组用途或简介文本
      * 返回设置结果 (JSON 字符串)，success 为 true 表示设置成功
      */
    func groupSetPurpose(roomId: String, groupPurpose: String): String
     
    /*
     * 获取群组信息
     * 参数roomId-群组ID
     * 参数roomName-群组名称(当roomId为空时使用)
     * 返回群组信息(JSON字符串)
     */
    func groupInfo(roomId: String, roomName: String): String
     
    /*
     * 获取群组集成列表
     * 参数roomId-群组ID
     * 返回集成列表(JSON字符串)
     */
    func groupIntegrations(roomId: String): String
     
    /*
     * 获取群组列表
     * 返回群组列表(JSON字符串)
     */
    func groupList(): String
     
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
     
    /*
     * 重命名群组
     * 参数name-新名称
     * 参数groupID-群组ID
     * 返回重命名结果(JSON字符串)
     */
    func groupRename(name: String, groupID: String): String
     
    /*
     * 归档群组
     * 参数groupID-群组ID
     * 返回归档结果(JSON字符串)
     */
    func groupArchive(groupID: String): String
     
    /*
     * 取消群组归档
     * 参数groupID-群组ID
     * 返回取消归档结果(JSON字符串)
     */
    func groupUnArchive(groupID: String): String
     
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
     
    /*
      * 删除群组
      * 参数 roomId - 群组ID
      * 参数 roomName - 群组名称（可选，当未提供 roomId 时使用）
      * 返回删除操作结果 (JSON 字符串)，success 为 true 表示删除成功
      */
    func groupDelete(roomId: String, roomName: String): String
     
    /*
     * 打开群组
     * 参数groupID-群组ID
     * 返回打开结果(JSON字符串)
     */
    func groupOpen(groupID: String): String
     
    /*
     * 关闭群组
     * 参数groupID-群组ID
     * 返回关闭结果(JSON字符串)
     */
    func groupClose(groupID: String): String
     
    /*
     * 将所有用户添加到群组
     * 参数groupID-群组ID
     * 参数activeUsersOnly-是否仅添加活跃用户
     * 返回操作结果(JSON字符串)
     */
    func groupAddAll(groupID: String, activeUsersOnly: Bool): String
     
    /*
     * 添加群组所有者
     * 参数groupID-群组ID
     * 参数userId-用户ID
     * 返回操作结果(JSON字符串)
     */
    func groupAddOwner(groupID: String, userId: String): String
     
    /*
     * 移除群组所有者
     * 参数groupID-群组ID
     * 参数userId-用户ID
     * 返回操作结果(JSON字符串)
     */
    func groupRemoveOwner(groupID: String, userId: String): String
     
    /*
     * 移除群组管理员
     * 参数groupID-群组ID
     * 参数userId-用户ID
     * 返回操作结果(JSON字符串)
     */
    func groupRemoveModerator(groupID: String, userId: String): String
     
    /*
     * 设置群组描述
     * 参数groupID-群组ID
     * 参数groupDescription-描述内容
     * 返回设置结果(JSON字符串)
     */
    func groupSetDescription(groupID: String, groupDescription: String): String
     
    // 系统相关 API
    /*
     * 获取系统公共设置
     * 返回设置信息(JSON字符串)
     */
    func settings(): String
     
    /*
     * 获取当前登录用户信息
     * 返回用户信息(JSON字符串)
     */
    func me(): String
     
    // 用户相关API
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
     
    /*
     * 创建新用户
     * 参数data-用户数据(JSON字符串)
     * 返回创建结果(JSON字符串)
     */
    func userCreate(data: String): String
     
    /*
     * 获取用户信息
     * 参数userId-用户ID
     * 参数userName-用户名(当userId为空时使用)
     * 返回用户信息(JSON字符串)
     */
    func usersInfo(userId: String, userName: String): String
     
    /*
     * 获取用户在线状态
     * 参数userId-用户ID
     * 参数userName-用户名(当userId为空时使用)
     * 返回在线状态(JSON字符串)
     */
    func usersPresence(userId: String, userName: String): String
     
    /*
     * 设置用户头像
     * 参数avatarUrl-头像URL
     * 返回设置结果(JSON字符串)
     */
    func setAvatar(avatarUrl: String): String
     
    /*
     * 删除用户
     * 参数userId-用户ID
     * 参数confirmRelinquish-确认放弃所有权
     * 返回删除结果(JSON字符串)
     */
    func userDelete(userId: String, confirmRelinquish: Bool): String
     
    // 聊天相关 API
    /*
     * 发送聊天消息
     * 参数postMessageData-消息数据(JSON字符串)
     * 返回发送结果(JSON字符串)
     */
    func postMessageChat(postMessageData: String): String
     
    /*
     * 更新聊天消息
     * 参数updateMsg-更新的消息数据(JSON字符串)
     * 返回更新结果(JSON字符串)
     */
    func updateMessageChat(updateMsg: String): String
     
    /*
     * 删除聊天消息
     * 参数roomId-房间ID
     * 参数msgId-消息ID
     * 参数asUser-是否以用户身份删除
     * 返回删除结果(JSON字符串)
     */
    func deleteMessageChat(roomId: String, msgId: String, asUser: Bool): String
     
    // 认证相关 API
    /*
     * 用户登录
     * 使用用户名/邮箱和密码登录
     * 返回登录结果(JSON字符串)
     */
    func login(): String
     
    /*
     * 使用认证令牌登录
     * 参数authToken-认证令牌
     * 返回登录结果(JSON字符串)
     */
    func loginWithAuthToken(authToken: String): String
     
    /*
     * 用户退出登录
     * 返回退出结果(JSON字符串)
     */
    func logout(): String
     
    // 频道管理 API
    /*
     * 关闭频道
     * 参数roomId-频道ID
     * 返回关闭结果(JSON字符串)
     */
    func closeChannel(roomId: String): String
     
    /*
     * 移除频道领导者
     * 参数roomId-频道ID
     * 参数userId-用户ID
     * 返回操作结果(JSON字符串)
     */
    func removeLeaderChannel(roomId: String, userId: String): String
     
    /*
     * 移除频道管理员角色
     * 参数roomId-频道ID
     * 参数userId-用户ID
     * 返回操作结果(JSON字符串)
     */
    func removeModeratorChannel(roomId: String, userId: String): String
     
    /*
     * 移除频道所有者
     * 参数roomId-频道ID
     * 参数userId-用户ID
     * 返回操作结果(JSON字符串)
     */
    func removeOwnerChannel(roomId: String, userId: String): String
     
    /*
     * 设置默认频道
     * 参数roomId-频道ID
     * 参数isDefault-是否为默认频道
     * 返回设置结果(JSON字符串)
     */
    func setDefaultChannel(roomId: String, isDefault: Bool): String
     
    /*
     * 设置频道只读状态
     * 参数roomId-频道ID
     * 参数readOnly-是否只读
     * 返回设置结果(JSON字符串)
     */
    func setReadOnlyChannel(roomId: String, readOnly: Bool): String
     
    /*
     * 归档频道
     * 参数roomId-频道ID
     * 返回归档结果(JSON字符串)
     */
    func archiveChannel(roomId: String): String
     
    /*
     * 取消频道归档
     * 参数roomId-频道ID
     * 返回取消归档结果(JSON字符串)
     */
    func unArchiveChannel(roomId: String): String
     
    /*
     * 获取频道集成列表
     * 参数roomId-频道ID
     * 返回集成列表(JSON字符串)
     */
    func getIntegrationChannel(roomId: String): String
}
```