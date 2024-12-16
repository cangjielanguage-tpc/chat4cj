package rocketlib

import encoding.json.*


public class RestAPI {
    private var httpRequestConnector: HttpRequestConnector
    private var username: String
    private var password: String 

    public init(url: String, username: String, password: String) {
        this.httpRequestConnector = HttpRequestConnector(url)
        this.username = username
        this.password = password
    }

    public func login(): String {
        // 构造登录数据
        let userData = JsonObject()
        if (this.username.contains("@")) {
            userData.put("email", JsonString(this.username))
            userData.put("password", JsonString(this.password))
        } else {
            userData.put("username", JsonString(this.username))
            userData.put("password", JsonString(this.password))
        }

        // 发送登录请求
        let response = this.httpRequestConnector.post("login", userData.toString())

        let json_data = response.asObject()
        let data = (json_data.get("data").getOrThrow() as JsonObject).getOrThrow()
        let userId = (data.get("userId").getOrThrow() as JsonString).getOrThrow()
        let authToken = (data.get("authToken").getOrThrow() as JsonString).getOrThrow()    
        this.httpRequestConnector.setUserData(authToken.getValue(), userId.getValue())

        return data.toJsonString()
    }

    public func loginWithAuthToken(authToken: String): String {
        // 构造登录数据
        let data = JsonObject()
        data.put("resume", JsonString(authToken))

        // 发送登录请求
        let response = this.httpRequestConnector.post("login", data.toString())

        let json_data = response.asObject()
        let result = (json_data.get("data").getOrThrow() as JsonObject).getOrThrow()
        return result.toJsonString()
    }
    
    public func pageVisited(pageData: String): String {
        let response = this.httpRequestConnector.post("livechat/page.visited", pageData)
        return response.toJsonString()
    }
    
    public func visitorRegistration(visitor: String): String {
        let response = this.httpRequestConnector.post("livechat/visitor", visitor)
        return response.toJsonString()
    }

    public func visitor(token: String): String {
        let response = this.httpRequestConnector.get("livechat/visitor/${token}", "")
        return response.toJsonString()
    }
    
    public func setVisitorStatus(visitor: String): String {
        let response = this.httpRequestConnector.post("livechat/visitor.status", visitor.toString())
        return response.toJsonString()
    }

    public func visitorDelete(token: String): String {
        let response = this.httpRequestConnector.delete("livechat/visitor/${token}", "")
        return response.toJsonString()
    }

    public func bannersEndPoint(id: Int64): String {
        let response = this.httpRequestConnector.get("banners/:id${id}?platform=web", "")
        return response.toJsonString()
    }

    public func getBanners(): String {
        let response = this.httpRequestConnector.get("banners?platform=web", "")
        return response.toJsonString()
    }
    
    public func createChannel(channel: String): String {
        let response = this.httpRequestConnector.post("channels.create", channel)
        return response.toJsonString()
    }
    
    public func addAllChannel(roomId: String, activeUsersOnly: Bool): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("activeUsersOnly", JsonBool(activeUsersOnly))
        
        let response = this.httpRequestConnector.post("channels.addAll", data.toString())
        return response.toJsonString()
    }

    public func addLeaderChannel(roomId: String,userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("userId", JsonString(userId))

        let response = this.httpRequestConnector.post("channels.addLeader", data.toString())
        return response.toJsonString()
    }

    public func addModeratorChannel(roomId: String,userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("channels.addModerator", data.toString())
        return response.toJsonString()
    }

    public func addOwnerChannel(roomId: String,userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("channels.addOwner", data.toString())
        return response.toJsonString()
    }

    public func counterChannel(roomId: String): String {
        let response = this.httpRequestConnector.get("channels.counters?roomId=${roomId}" , "")
        return response.toJsonString()
    }

    public func getUserAllMentionByChannel(roomId: String): String {
        let response = this.httpRequestConnector.get("channels.getAllUserMentionsByChannel?roomId=${roomId}","")
        return response.toJsonString()
    }

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

    public func historyChannel(roomId: String, optionalParams: JsonValue): String {
        var url = "channels.history?roomId=" + roomId
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
            }else {
                url += "&inclusive=" + "false"
            }
        }

        if (params.get("offset").isSome()) {
            url += "&offset=" + ((params.get("offset").getOrThrow() as JsonInt).getOrThrow().getValue()).toString()
        }else {
            url += "&offset=0"
        }

        if (params.get("count").isSome()) {
            url += "&count=" + ((params.get("count").getOrThrow() as JsonInt).getOrThrow().getValue()).toString()
        }else {
            url += "&count=20"
        }

        if (params.get("unreads").isSome()) {
            if ((params.get("unreads").getOrThrow() as JsonBool).getOrThrow().getValue()) {
                url += "&unreads=" + "true"
            }else {
                url += "&unreads=" + "false"
            }
        }

        let response = this.httpRequestConnector.get(url,"")
        return response.toJsonString()
    }

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

    public func inviteChannel(roomId: String,userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("userId", JsonString(userId))
        let response = this.httpRequestConnector.post("channels.invite", data.toString())
        return response.toJsonString()
    }

    public func joinChannel(roomId: String, joinCode: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("joinCode", JsonString(joinCode))
        
        let response = this.httpRequestConnector.post("channels.join", data.toString())
        return response.toJsonString()
    }

    public func kickChannel(roomId: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("userId", JsonString(userId))
        
        let response = this.httpRequestConnector.post("channels.kick", data.toString())
        return response.toJsonString()
    }

    public func leaveChannel(roomId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        
        let response = this.httpRequestConnector.post("channels.leave", data.toString())
        
        return response.toJsonString()
    }

    public func listChannel(): String {
        let response = this.httpRequestConnector.get("channels.list", "")
        
        return response.toJsonString()
    }

    public func joinListChannel(): String {
        let response = this.httpRequestConnector.get("channels.list.joined", "")
        
        return response.toJsonString()
    }

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

    public func messageChannel(roomId: String, roomName: String): String {
        let channelData: String
        if (roomId.size > 0) {
            channelData = "channels.messages?roomId=" + roomId
        } else {
            channelData = "channels.messages?roomName=" + roomName
        }
        
        let response = this.httpRequestConnector.get(channelData, "")
        return response.toJsonString()
    }

    public func onlineChannel(roomId: String): String {
        let id = JsonObject()
        id.put("_id", JsonString(roomId))
        
        let response = this.httpRequestConnector.get("channels.online?query=" + id.toString(), "")
       
        return response.toJsonString()
    }

    public func openChannel(roomId: String): String {
        let channel = JsonObject()
        channel.put("roomId", JsonString(roomId))
        
        let response = this.httpRequestConnector.post("channels.open", channel.toString())      
        return response.toJsonString()
    }

    public func renameChannel(roomId: String, name: String): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("name", JsonString(name))
        
        let response = this.httpRequestConnector.post("channels.rename", channelData.toString())
        
        return response.toJsonString()
    }

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

    public func setAnnouncementChannel(roomId: String, announcement: String): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("announcement", JsonString(announcement))
        
        let response = this.httpRequestConnector.post("channels.setAnnouncement", channelData.toString())
        
        return response.toJsonString()
    }

    public func setCustomFieldsChannel(roomId: String, roomName: String, customField: JsonObject): String {
        let channelData = JsonObject()
        if (roomId.size > 0) {
            channelData.put("roomId", JsonString(roomId))
        } else {
            channelData.put("roomName", JsonString(roomName))
        }
        channelData.put("customFields", customField)
        
        let response = this.httpRequestConnector.post("channels.setCustomFields", channelData.toString())
        
        return response.toJsonString()
    }

    public func setJoinCodeChannel(roomId: String, joinCode: String): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("joinCode", JsonString(joinCode))
        
        let response = this.httpRequestConnector.post("channels.setJoinCode", channelData.toString())
        
        return response.toJsonString()
    }

    public func setPurposeChannel(roomId: String, purpose: String): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("purpose", JsonString(purpose))
        
        let response = this.httpRequestConnector.post("channels.setPurpose", channelData.toString())
        
        return response.toJsonString()
    }

    public func setTopicChannel(roomId: String, topic: String): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("topic", JsonString(topic))
        
        let response = this.httpRequestConnector.post("channels.setTopic", channelData.toString())
        
        return response.toJsonString()
    }

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

    public func archiveChannel(roomId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        
        let response = this.httpRequestConnector.post("channels.archive", data.toString())
        
        return response.toJsonString()
    }

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

    public func groupAddLeader(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        
        let response = this.httpRequestConnector.post("groups.addLeader", data.toString())
        
        return response.toJsonString()
    }

    public func groupAddModerator(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        
        let response = this.httpRequestConnector.post("groups.addModerator", data.toString())
        
        return response.toJsonString()
    }

    public func groupArchive(groupID: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        
        let response = this.httpRequestConnector.post("groups.archive", data.toString())
        
        return response.toJsonString()
    }

    public func groupUnArchive(groupID: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        
        let response = this.httpRequestConnector.post("groups.unarchive", data.toString())
        
        return response.toJsonString()
    }

    public func groupCreate(group: String): String {
        let response = this.httpRequestConnector.post("groups.create", group.toString())
        
        return response.toJsonString()
    }

    public func groupInvite(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        
        let response = this.httpRequestConnector.post("groups.invite", data.toString())
        
        return response.toJsonString()
    }

    public func groupRename(name: String, groupID: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("name", JsonString(name))
        
        let response = this.httpRequestConnector.post("groups.rename", data.toString())
        
        return response.toJsonString()
    }

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

    public func groupAddAll(groupID: String, activeUsersOnly: Bool): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("activeUsersOnly", JsonBool(activeUsersOnly))
        
        let response = this.httpRequestConnector.post("groups.addAll", data.toString())
        
        return response.toJsonString()
    }

    public func groupAddOwner(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        
        let response = this.httpRequestConnector.post("groups.addOwner", data.toString())
        
        return response.toJsonString()
    }

    public func groupRemoveOwner(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        
        let response = this.httpRequestConnector.post("groups.removeOwner", data.toString())
        
        return response.toJsonString()
    }

    public func groupRemoveModerator(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        
        let response = this.httpRequestConnector.post("groups.removeModerator", data.toString())
        
        return response.toJsonString()
    }

    public func groupSetPurpose(groupID: String, groupPurpose: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("purpose", JsonString(groupPurpose))
        
        let response = this.httpRequestConnector.post("groups.setPurpose", data.toString())
        
        return response.toJsonString()
    }

    public func groupSetDescription(groupID: String, groupDescription: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("description", JsonString(groupDescription))
        
        let response = this.httpRequestConnector.post("groups.setDescription", data.toString())
        
        return response.toJsonString()
    }

    public func groupOpen(groupID: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        
        let response = this.httpRequestConnector.post("groups.open", data.toString())
        
        return response.toJsonString()
    }

    public func groupClose(groupID: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        
        let response = this.httpRequestConnector.post("groups.close", data.toString())
        
        return response.toJsonString()
    }

    public func groupKick(groupID: String, userId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("userId", JsonString(userId))
        
        let response = this.httpRequestConnector.post("groups.kick", data.toString())
        
        return response.toJsonString()
    }

    public func groupLeave(groupID: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        
        let response = this.httpRequestConnector.post("groups.leave", data.toString())
        
        return response.toJsonString()
    }

    public func groupSetReadOnly(groupID: String, readOnly: Bool): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("readOnly", JsonBool(readOnly))
        
        let response = this.httpRequestConnector.post("groups.setReadOnly", data.toString())
        
        return response.toJsonString()
    }

    public func groupSetTopic(groupID: String, groupTopic: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("topic", JsonString(groupTopic))
        
        let response = this.httpRequestConnector.post("groups.setTopic", data.toString())
        
        return response.toJsonString()
    }

    public func groupSetType(groupID: String, groupType: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(groupID))
        data.put("type", JsonString(groupType))
        
        let response = this.httpRequestConnector.post("groups.setType", data.toString())
        return response.toJsonString()
    }

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

    public func groupIntegrations(roomId: String): String {
        let response = this.httpRequestConnector.get("groups.getIntegrations?roomId=" + roomId, "")
        
        return response.toJsonString()
    }

    public func groupList(): String {
        let response = this.httpRequestConnector.get("groups.list", "")
        return response.toJsonString()
    }

    public func groupHistory(roomId: String, optionalParams: JsonValue): String {
        var url = "groups.history?roomId=" + roomId
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
            }else {
                url += "&inclusive=" + "false"
            }
        }

        if (params.get("offset").isSome()) {
            url += "&offset=" + ((params.get("offset").getOrThrow() as JsonInt).getOrThrow().getValue()).toString()
        }else {
            url += "&offset=0"
        }

        if (params.get("count").isSome()) {
            url += "&count=" + ((params.get("count").getOrThrow() as JsonInt).getOrThrow().getValue()).toString()
        }else {
            url += "&count=20"
        }

        if (params.get("unreads").isSome()) {
            if ((params.get("unreads").getOrThrow() as JsonBool).getOrThrow().getValue()) {
                url += "&unreads=" + "true"
            }else {
                url += "&unreads=" + "false"
            }
        }
        
        let response = this.httpRequestConnector.get(url, "")
        
        return response.toJsonString()
    }

    public func me(): String {
        let response = this.httpRequestConnector.get("me", "")
        return response.toJsonString()
    }

    public func logout(): String {
        let response = this.httpRequestConnector.get("logout", "")
        
        return response.toJsonString()
    }

    public func loggedIn(): Bool {
        return this.httpRequestConnector.loggedIn()
    }

    public func closeChannel(roomId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        
        let response = this.httpRequestConnector.post("channels.close", data.toString())
        
        return response.toJsonString()
    }

    public func removeLeaderChannel(roomId: String, userId: String): String {
        let leaderData = JsonObject()
        leaderData.put("roomId", JsonString(roomId))
        leaderData.put("userId", JsonString(userId))
        
        let response = this.httpRequestConnector.post("channels.removeLeader", leaderData.toString())
        return response.toJsonString()
    }

    public func removeModeratorChannel(roomId: String, userId: String): String {
        let moderatorData = JsonObject()
        moderatorData.put("roomId", JsonString(roomId))
        moderatorData.put("userId", JsonString(userId))
        
        let response = this.httpRequestConnector.post("channels.removeModerator", moderatorData.toString())
        
        return response.toJsonString()
    }

    public func removeOwnerChannel(roomId: String, userId: String): String {
        let ownerData = JsonObject()
        ownerData.put("roomId", JsonString(roomId))
        ownerData.put("userId", JsonString(userId))
        
        let response = this.httpRequestConnector.post("channels.removeOwner", ownerData.toString())
        
        return response.toJsonString()
    }

    public func setDefaultChannel(roomId: String, isDefault: Bool): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("default", JsonBool(isDefault))
        
        let response = this.httpRequestConnector.post("channels.setDefault", channelData.toString())
        
        return response.toJsonString()
    }

    public func setReadOnlyChannel(roomId: String, readOnly: Bool): String {
        let channelData = JsonObject()
        channelData.put("roomId", JsonString(roomId))
        channelData.put("readOnly", JsonBool(readOnly))
        
        let response = this.httpRequestConnector.post("channels.setReadOnly", channelData.toString())
        
        return response.toJsonString()
    }

    public func usersList(query: String,fields: String,sort: String,count: Int64,offset:Int64): String {
        var url = "users.list?query=${query}&fields=${fields}&sort=${sort}&offset=${offset}&count=${count}"
        
        let response = this.httpRequestConnector.get(url, "")
        
        return response.toJsonString()
    }

    public func userCreate(data: String): String {
        let response = this.httpRequestConnector.post("users.create", data)
        
        return response.toJsonString()
    }

    public func usersInfo(user_id: String, userName: String): String {
        let endpoint: String
        if (user_id.size > 0) {
            endpoint = "users.info?userId=" + user_id
        } else {
            endpoint = "users.info?username=" + userName
        }
        
        let response = this.httpRequestConnector.get(endpoint, "")
        
        return response.toJsonString()
    }

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

    public func setAvatar(avatarUrl: String): String {
        let data = JsonObject()
        data.put("avatarUrl", JsonString(avatarUrl))
        let response = this.httpRequestConnector.post("users.setAvatar", data.toString())
        
        return response.toJsonString()
    }

    public func userDelete(userId: String,confirmRelinquish: Bool): String {
        let data = JsonObject()
        data.put("userId", JsonString(userId))
        data.put("confirmRelinquish", JsonBool(confirmRelinquish))
        let response = this.httpRequestConnector.post("users.delete", data.toString())
        
        return response.toJsonString()
    }

    public func settings(): String {
        let response = this.httpRequestConnector.get("settings.public", "")
        
        return response.toJsonString()
    }

    public func unArchiveChannel(roomId: String): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        
        let response = this.httpRequestConnector.post("channels.unarchive", data.toString())
        
        return response.toJsonString()
    }

    public func getIntegrationChannel(roomId: String): String {
        let response = this.httpRequestConnector.get("channels.getIntegrations?roomId=" + roomId, "")
        
        return response.toJsonString()
    }

    public func postMessageChat(postMessageData: String): String {
        let response = this.httpRequestConnector.post("chat.postMessage", postMessageData)
        
        return response.toJsonString()
    }

    public func updateMessageChat(updateMsg: String): String {
        let response = this.httpRequestConnector.post("chat.update", updateMsg)
        
        return response.toJsonString()
    }

    public func deleteMessageChat(roomId: String, msgId: String, asUser: Bool): String {
        let data = JsonObject()
        data.put("roomId", JsonString(roomId))
        data.put("msgId", JsonString(msgId))
        data.put("asUser", JsonBool(asUser))
        
        let response = this.httpRequestConnector.post("chat.delete", data.toString())
        
        return response.toJsonString()
    }    
}