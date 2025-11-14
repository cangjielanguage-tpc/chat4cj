/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package chat

public class RestAPI {
    private var httpRequestConnector: HttpRequestConnector
    private var username: String
    private var credentialKey: String

    /**
     * 根据参数创建 RestAPI 实例。
     *
     * @param url - Rocket.Chat 服务器地址，如http://xxx.x.xxx.x:3000/api/v1/
     * @param username - 用于登录认证的用户名。
     * @param credentialKey - 用户的登录凭据（即密码）。
     */
    public init(url: String, username: String, credentialKey: String) {
        this.httpRequestConnector = HttpRequestConnector(url)
        this.username = username
        this.credentialKey = credentialKey
    }

    // 用户登录
    public func login(): String {
        // 构造登录数据
        let userData = JsonObject()
        if (this.username.contains("@")) {
            userData.put("email", JsonString(this.username))
            userData.put("password", JsonString(this.credentialKey))
        } else {
            userData.put("username", JsonString(this.username))
            userData.put("password", JsonString(this.credentialKey))
        }
        // 发送登录请求
        let response = this.httpRequestConnector.post("login", userData.toString())
        let json_data = response.asObject()
        let success = (json_data.get("success").getOrThrow() as JsonBool).getOrThrow().getValue()
        if (!success) {
            return response.toJsonString()
        }
        if (let Some(body) <- json_data.get("body")) {
            let bodyObj = body.asObject()
            // 获取 data 对象
            let data = (bodyObj.get("data").getOrThrow() as JsonObject).getOrThrow()
            let userId = (data.get("userId").getOrThrow() as JsonString).getOrThrow()
            let authToken = (data.get("authToken").getOrThrow() as JsonString).getOrThrow()
            this.httpRequestConnector.setUserData(authToken.getValue(), userId.getValue())
        }
        return response.toJsonString()
    }

    // 使用认证令牌登录
    public func loginWithAuthToken(authToken: String): String {
        // 构造登录数据
        let data = JsonObject()
        data.put("resume", JsonString(authToken))
        // 发送登录请求
        let response = this.httpRequestConnector.post("login", data.toString())
        return response.toJsonString()
    }

    // 获取当前登录用户信息
    public func me(): String {
        let response = this.httpRequestConnector.get("me", "")
        return response.toJsonString()
    }

    // 创建新用户
    public func userCreate(data: String): String {
        let response = this.httpRequestConnector.post("users.create", data)
        return response.toJsonString()
    }

    // 获取用户列表
    public func usersList(query: String, fields: String, sort: String, count: Int64, offset: Int64): String {
        var url = "users.list?query=${query}&fields=${fields}&sort=${sort}&offset=${offset}&count=${count}"
        try {
            let response = this.httpRequestConnector.get(url, "")
            return response.toJsonString()
        } catch (e: Exception) {
            return handleException(e)
        }
    }

    // 获取用户信息
    public func usersInfo(userId: String, userName: String): String {
        let endpoint: String
        if (userId.size > 0) {
            endpoint = "users.info?userId=" + userId
        } else {
            endpoint = "users.info?username=" + userName
        }
        let response = this.httpRequestConnector.get(endpoint, "")
        return response.toJsonString()
    }

    // 获取用户在线状态
    public func usersPresence(userId: String, userName: String): String {
        var endpoint = "users.getPresence"
        if (userName.size > 0) {
            endpoint = "users.getPresence?username=" + userName
        } else if (userId.size > 0) {
            endpoint = "users.getPresence?userId=" + userId
        }
        let response = this.httpRequestConnector.get(endpoint, "")
        return response.toJsonString()
    }

    // 设置用户头像
    public func setAvatar(avatarUrl: String): String {
        let data = JsonObject()
        data.put("avatarUrl", JsonString(avatarUrl))
        let response = this.httpRequestConnector.post("users.setAvatar", data.toString())
        return response.toJsonString()
    }

    // 获取系统公共设置
    public func settings(): String {
        let response = this.httpRequestConnector.get("settings.public", "")
        return response.toJsonString()
    }

    // 记录访客页面访问数据
    public func pageVisited(pageData: String): String {
        let response = this.httpRequestConnector.post("livechat/page.visited", pageData)
        return response.toJsonString()
    }

    // 注册访客
    public func visitorRegistration(visitor: String): String {
        let response = this.httpRequestConnector.post("livechat/visitor", visitor)
        return response.toJsonString()
    }

    // 获取访客信息
    public func visitor(token: String): String {
        try {
            let response = this.httpRequestConnector.get("livechat/visitor/${token}", "")
            return response.toJsonString()
        } catch (e: Exception) {
            return handleException(e)
        }
    }

    // 设置访客状态
    public func setVisitorStatus(visitor: String): String {
        let response = this.httpRequestConnector.post("livechat/visitor.status", visitor.toString())
        return response.toJsonString()
    }

    // 删除访客
    public func visitorDelete(token: String): String {
        let response = this.httpRequestConnector.delete("livechat/visitor/${token}", "")
        return response.toJsonString()
    }

    // 获取指定横幅信息
    public func bannersEndPoint(id: Int64): String {
        let response = this.httpRequestConnector.get("banners/:id${id}?platform=web", "")
        return response.toJsonString()
    }

    // 获取所有横幅列表
    public func getBanners(): String {
        let response = this.httpRequestConnector.get("banners?platform=web", "")
        return response.toJsonString()
    }

    // 创建新频道
    public func createChannel(channel: String): String {
        let response = this.httpRequestConnector.post("channels.create", channel)
        return response.toJsonString()
    }

    // 关闭频道
    public func closeChannel(roomId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        let response = this.httpRequestConnector.post("channels.close", data.toString())
        return response.toJsonString()
    }

    // 打开频道
    public func openChannel(roomId: String): String {
        let channel = JsonObject()
        channel.put("roomId", JsonString(roomId))
        let response = this.httpRequestConnector.post("channels.open", channel.toString())
        return response.toJsonString()
    }

    // 设置频道类型
    public func setTypeChannel(roomId: String, roomName: String, channelType: String): String {
        let channelData = JsonObject()
        if (roomId.size > 0) {
            channelData.put("roomId", JsonString(roomId))
        } else {
            channelData.put("roomName", JsonString(roomName))
        }
        channelData.put("type", JsonString(channelType))
        let response = this.httpRequestConnector.post("channels.setType", channelData.toString())
        return response.toJsonString()
    }

    // 发送聊天消息
    public func postMessageChat(postMessageData: String): String {
        let response = this.httpRequestConnector.post("chat.postMessage", postMessageData)
        return response.toJsonString()
    }

    // 更新聊天消息
    public func updateMessageChat(updateMsg: String): String {
        let response = this.httpRequestConnector.post("chat.update", updateMsg)
        return response.toJsonString()
    }

    // 删除聊天消息
    public func deleteMessageChat(roomId: String, msgId: String, asUser: Bool): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("msgId", JsonString(msgId))
        data.put("asUser", JsonBool(asUser))
        let response = this.httpRequestConnector.post("chat.delete", data.toString())
        return response.toJsonString()
    }

    // 邀请用户加入频道
    public func inviteChannel(roomId: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("channels.invite", data.toString())
        return response.toJsonString()
    }

    // 添加频道领导者
    public func addLeaderChannel(roomId: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("channels.addLeader", data.toString())
        return response.toJsonString()
    }

    // 移除频道领导者
    public func removeLeaderChannel(roomId: String, userId: String): String {
        let leaderData = JsonObject()
        leaderData.put("roomId", JsonString(roomId))
        leaderData.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("channels.removeLeader", leaderData.toString())
        return response.toJsonString()
    }

    // 添加频道管理员角色
    public func addModeratorChannel(roomId: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("channels.addModerator", data.toString())
        return response.toJsonString()
    }

    // 移除频道管理员角色
    public func removeModeratorChannel(roomId: String, userId: String): String {
        let moderatorData = JsonObject()
        moderatorData.put("roomId", JsonString(roomId))
        moderatorData.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("channels.removeModerator", moderatorData.toString())
        return response.toJsonString()
    }

    // 添加频道所有者
    public func addOwnerChannel(roomId: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("channels.addOwner", data.toString())
        return response.toJsonString()
    }

    // 移除频道所有者
    public func removeOwnerChannel(roomId: String, userId: String): String {
        let ownerData = JsonObject()
        ownerData.put("roomId", JsonString(roomId))
        ownerData.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("channels.removeOwner", ownerData.toString())
        return response.toJsonString()
    }

    // 设置频道用途说明
    public func setPurposeChannel(roomId: String, purpose: String): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("purpose", JsonString(purpose))
        let response = this.httpRequestConnector.post("channels.setPurpose", channelData.toString())
        return response.toJsonString()
    }

    // 设置频道只读状态
    public func setReadOnlyChannel(roomId: String, readOnly: Bool): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("readOnly", JsonBool(readOnly))
        let response = this.httpRequestConnector.post("channels.setReadOnly", channelData.toString())
        return response.toJsonString()
    }

    // 归档频道
    public func archiveChannel(roomId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        let response = this.httpRequestConnector.post("channels.archive", data.toString())
        return response.toJsonString()
    }

    // 取消频道归档
    public func unArchiveChannel(roomId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        let response = this.httpRequestConnector.post("channels.unarchive", data.toString())
        return response.toJsonString()
    }

    // 获取某个频道的统计信息
    public func counterChannel(roomId: String): String {
        let response = this.httpRequestConnector.get("channels.counters?roomId=${roomId}", "")
        return response.toJsonString()
    }

    // 获取频道文件列表
    public func filesChannel(roomId: String, roomName: String): String {
        let endpoint: String
        if (roomId.size > 0) {
            endpoint = "channels.files?roomId=" + roomId
        } else {
            endpoint = "channels.files?roomName=" + roomName
        }
        let response = this.httpRequestConnector.get(endpoint, "")
        return response.toJsonString()
    }

    // 获取频道历史消息
    public func historyChannel(roomId: String, roomName: String, optionalParams: JsonValue): String {
        var url = "channels.history?roomId=" + roomId
        if (roomId.size > 0) {
            url = "channels.files?roomId=" + roomId
        } else {
            url = "channels.files?roomName=" + roomName
        }
        try {
            buildHistoryRequest(optionalParams, url)
            let response = this.httpRequestConnector.get(url, "")
            return response.toJsonString()
        } catch (e: Exception) {
            return handleException(e)
        }
    }

    // 获取频道信息
    public func infoChannel(roomId: String, roomName: String): String {
        let endpoint: String
        if (roomId.size > 0) {
            endpoint = "channels.info?roomId=" + roomId
        } else {
            endpoint = "channels.info?roomName=" + roomName
        }
        let response = this.httpRequestConnector.get(endpoint, "")
        return response.toJsonString()
    }

    // 加入频道
    public func joinChannel(roomId: String, joinCode: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("joinCode", JsonString(joinCode))
        let response = this.httpRequestConnector.post("channels.join", data.toString())
        return response.toJsonString()
    }

    // 将用户踢出频道
    public func kickChannel(roomId: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("channels.kick", data.toString())
        return response.toJsonString()
    }

    // 离开频道
    public func leaveChannel(roomId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        let response = this.httpRequestConnector.post("channels.leave", data.toString())
        return response.toJsonString()
    }

    // 获取所有频道列表
    public func listChannel(): String {
        let response = this.httpRequestConnector.get("channels.list", "")
        return response.toJsonString()
    }

    // 获取已加入的频道列表
    public func joinListChannel(): String {
        let response = this.httpRequestConnector.get("channels.list.joined", "")
        return response.toJsonString()
    }

    // 获取频道成员列表
    public func membersChannel(roomId: String, roomName: String): String {
        let endpoint: String
        if (roomId.size > 0) {
            endpoint = "channels.members?roomId=" + roomId
        } else {
            endpoint = "channels.members?roomName=" + roomName
        }
        let response = this.httpRequestConnector.get(endpoint, "")
        return response.toJsonString()
    }

    // 获取频道当前在线用户
    public func onlineChannel(roomId: String): String {
        let id = JsonObject()
        try {
            id.put("_id", JsonString(roomId))
            let response = this.httpRequestConnector.get("channels.online?query=" + id.toString(), "")
            return response.toJsonString()
        } catch (e: Exception) {
            return handleException(e)
        }
    }

    // 获取频道中所有提及信息
    public func getUserAllMentionByChannel(roomId: String): String {
        let response = this.httpRequestConnector.get("channels.getAllUserMentionsByChannel?roomId=${roomId}", "")
        return response.toJsonString()
    }

    // 重命名频道
    public func renameChannel(roomId: String, name: String): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("name", JsonString(name))
        let response = this.httpRequestConnector.post("channels.rename", channelData.toString())
        return response.toJsonString()
    }

    // 获取频道角色列表
    public func rolesChannel(roomId: String, roomName: String): String {
        let endpoint: String
        if (roomId.size > 0) {
            endpoint = "channels.roles?roomId=" + roomId
        } else {
            endpoint = "channels.roles?roomName=" + roomName
        }
        let response = this.httpRequestConnector.get(endpoint, "")
        return response.toJsonString()
    }

    // 设置频道公告
    public func setAnnouncementChannel(roomId: String, announcement: String): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("announcement", JsonString(announcement))
        let response = this.httpRequestConnector.post("channels.setAnnouncement", channelData.toString())
        return response.toJsonString()
    }

    // 设置频道加入码
    public func setJoinCodeChannel(roomId: String, joinCode: String): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("joinCode", JsonString(joinCode))
        let response = this.httpRequestConnector.post("channels.setJoinCode", channelData.toString())
        return response.toJsonString()
    }

    // 获取频道集成列表
    public func getIntegrationChannel(roomId: String): String {
        let response = this.httpRequestConnector.get("channels.getIntegrations?roomId=" + roomId, "")
        return response.toJsonString()
    }

    // 设置默认频道
    public func setDefaultChannel(roomId: String, isDefault: Bool): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("default", JsonBool(isDefault))
        let response = this.httpRequestConnector.post("channels.setDefault", channelData.toString())
        return response.toJsonString()
    }

    // 将所有用户添加到指定频道
    public func addAllChannel(roomId: String, activeUsersOnly: Bool): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("activeUsersOnly", JsonBool(activeUsersOnly))
        let response = this.httpRequestConnector.post("channels.addAll", data.toString())
        return response.toJsonString()
    }

    // 获取频道消息
    public func messageChannel(roomId: String, count!: UInt64 = 50, sort!: String = "{\"ts\": -1}", offset!: UInt64 = 0): String {
        var channelData: String = "channels.messages?roomId=" + roomId
        channelData += "&count=" + count.toString() + "&sort=" + sort + "&offset=" + offset.toString()
        try {
            let response = this.httpRequestConnector.get(channelData, "")
            return response.toJsonString()
        } catch (e: Exception) {
            return handleException(e)
        }
    }

    // 设置频道自定义字段
    public func setCustomFieldsChannel(roomId: String, customField: JsonObject): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("customFields", customField)
        let response = this.httpRequestConnector.post("channels.setCustomFields", channelData.toString())
        return response.toJsonString()
    }

    // 设置频道主题
    public func setTopicChannel(roomId: String, topic: String): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("topic", JsonString(topic))
        let response = this.httpRequestConnector.post("channels.setTopic", channelData.toString())
        return response.toJsonString()
    }

    // 删除一个频道（永久移除）
    public func deleteChannel(roomId: String, roomName: String): String {
        let data = JsonObject()
        if (roomId.size > 0) {
            data.put("roomId", JsonString(roomId))
        } else {
            data.put("roomName", JsonString(roomName))
        }
        let response = this.httpRequestConnector.post("channels.delete", data.toString())
        return response.toJsonString()
    }

    // 创建新群组
    public func groupCreate(group: String): String {
        let response = this.httpRequestConnector.post("groups.create", group.toString())
        return response.toJsonString()
    }

    // 邀请用户加入群组
    public func groupInvite(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("groups.invite", data.toString())
        return response.toJsonString()
    }

    // 重命名群组
    public func groupRename(name: String, groupID: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("name", JsonString(name))
        let response = this.httpRequestConnector.post("groups.rename", data.toString())
        return response.toJsonString()
    }

    // 设置群组只读状态
    public func groupSetReadOnly(groupID: String, readOnly: Bool): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("readOnly", JsonBool(readOnly))
        let response = this.httpRequestConnector.post("groups.setReadOnly", data.toString())
        return response.toJsonString()
    }

    // 设置群组主题
    public func groupSetTopic(groupID: String, groupTopic: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("topic", JsonString(groupTopic))
        let response = this.httpRequestConnector.post("groups.setTopic", data.toString())
        return response.toJsonString()
    }

    // 添加群组领导者
    public func groupAddLeader(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("groups.addLeader", data.toString())
        return response.toJsonString()
    }

    // 获取群组信息
    public func groupInfo(roomId: String, roomName: String): String {
        let endpoint: String
        if (roomId.size > 0) {
            endpoint = "groups.info?roomId=" + roomId
        } else {
            endpoint = "groups.info?roomName=" + roomName
        }
        let response = this.httpRequestConnector.get(endpoint, "")
        return response.toJsonString()
    }

    // 获取群组列表
    public func groupList(): String {
        let response = this.httpRequestConnector.get("groups.list", "")
        return response.toJsonString()
    }

    // 添加群组管理员
    public func groupAddModerator(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("groups.addModerator", data.toString())
        return response.toJsonString()
    }

    // 移除群组管理员
    public func groupRemoveModerator(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("groups.removeModerator", data.toString())
        return response.toJsonString()
    }

    // 设置群组描述
    public func groupSetDescription(groupID: String, groupDescription: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("description", JsonString(groupDescription))
        let response = this.httpRequestConnector.post("groups.setDescription", data.toString())
        return response.toJsonString()
    }

    // 归档群组
    public func groupArchive(groupID: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        let response = this.httpRequestConnector.post("groups.archive", data.toString())
        return response.toJsonString()
    }

    // 取消群组归档
    public func groupUnArchive(groupID: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        let response = this.httpRequestConnector.post("groups.unarchive", data.toString())
        return response.toJsonString()
    }

    // 获取群组集成列表
    public func groupIntegrations(roomId: String): String {
        let response = this.httpRequestConnector.get("groups.getIntegrations?roomId=" + roomId, "")
        return response.toJsonString()
    }

    // 关闭群组
    public func groupClose(groupID: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        let response = this.httpRequestConnector.post("groups.close", data.toString())
        return response.toJsonString()
    }

    // 打开群组
    public func groupOpen(groupID: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        let response = this.httpRequestConnector.post("groups.open", data.toString())
        return response.toJsonString()
    }

    // 获取群组历史消息
    public func groupHistory(roomId: String, optionalParams: JsonValue): String {
        var url = "groups.history?roomId=" + roomId
        try {
            buildHistoryRequest(optionalParams, url)
            let response = this.httpRequestConnector.get(url, "")
            return response.toJsonString()
        } catch (e: Exception) {
            return handleException(e)
        }
    }

    // 删除群组
    public func groupDelete(roomId: String, roomName: String): String {
        let data = JsonObject()
        if (roomId.size > 0) {
            data.put("roomId", JsonString(roomId))
        } else {
            data.put("roomName", JsonString(roomName))
        }
        let response = this.httpRequestConnector.post("groups.delete", data.toString())
        return response.toJsonString()
    }

    // 设置群组类型
    public func groupSetType(groupID: String, groupType: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("type", JsonString(groupType))
        let response = this.httpRequestConnector.post("groups.setType", data.toString())
        return response.toJsonString()
    }

    // 设置群组用途
    public func groupSetPurpose(groupID: String, groupPurpose: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("purpose", JsonString(groupPurpose))
        let response = this.httpRequestConnector.post("groups.setPurpose", data.toString())
        return response.toJsonString()
    }

    // 将用户踢出群组
    public func groupKick(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("groups.kick", data.toString())
        return response.toJsonString()
    }

    // 将所有用户添加到群组
    public func groupAddAll(groupID: String, activeUsersOnly: Bool): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("activeUsersOnly", JsonBool(activeUsersOnly))
        let response = this.httpRequestConnector.post("groups.addAll", data.toString())
        return response.toJsonString()
    }

    // 添加群组所有者
    public func groupAddOwner(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("groups.addOwner", data.toString())
        return response.toJsonString()
    }

    // 移除群组所有者
    public func groupRemoveOwner(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("groups.removeOwner", data.toString())
        return response.toJsonString()
    }

    // 离开群组
    public func groupLeave(groupID: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        let response = this.httpRequestConnector.post("groups.leave", data.toString())
        return response.toJsonString()
    }

    // 用户退出登录
    public func logout(): String {
        let response = this.httpRequestConnector.get("logout", "")
        return response.toJsonString()
    }

    // 删除用户
    public func userDelete(userId: String, confirmRelinquish: Bool): String {
        let data = JsonObject()
        data.put("userId", JsonString(userId))
        data.put("confirmRelinquish", JsonBool(confirmRelinquish))
        let response = this.httpRequestConnector.post("users.delete", data.toString())
        return response.toJsonString()
    }

    private func buildHistoryRequest(optionalParams: JsonValue, baseUrl: String): String {
        var url = baseUrl
        let params = optionalParams.asObject()
        if (params.get("latest").isSome()) {
            url += "&latest=" + (params.get("latest").getOrThrow() as JsonString).getOrThrow().getValue()
        }
        if (params.get("oldest").isSome()) {
            url += "&oldest=" + (params.get("oldest").getOrThrow() as JsonString).getOrThrow().getValue()
        }
        if (params.get("inclusive").isSome()) {
            if ((params.get("inclusive").getOrThrow() as JsonBool).getOrThrow().getValue()) {
                url += "&inclusive=" + "true"
            } else {
                url += "&inclusive=" + "false"
            }
        }
        if (params.get("offset").isSome()) {
            url += "&offset=" + ((params.get("offset").getOrThrow() as JsonInt).getOrThrow().getValue()).toString()
        } else {
            url += "&offset=0"
        }
        if (params.get("count").isSome()) {
            url += "&count=" + ((params.get("count").getOrThrow() as JsonInt).getOrThrow().getValue()).toString()
        } else {
            url += "&count=20"
        }
        if (params.get("unreads").isSome()) {
            if ((params.get("unreads").getOrThrow() as JsonBool).getOrThrow().getValue()) {
                url += "&unreads=" + "true"
            } else {
                url += "&unreads=" + "false"
            }
        }
        return url
    }

    private func handleException(exception: Exception): String {
        let response = JsonObject()
        response.put("success", JsonBool(false))
        response.put("code", JsonInt(0))
        response.put("errmsg", JsonString(exception.message))
        return response.toJsonString()
    }
}
