/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.prompt_action.PromptAction
import std.time.DateTime
import serialization.serialization.DataModel
import ohos.hilog.Hilog
import ohos.concurrency.launch
import encoding.json.*
import std.random.*
import chat.*

@Entry
@Component
class RestApiSample {
    var restAPI: RestAPI = RestAPI("https://your-rocket-chat-server", "username", "password")

    func build() {
        Scroll() {
            Column(5) {
                /*
                 * 用户登录
                 * 使用用户名/邮箱和密码登录
                 * 返回登录结果(JSON字符串)
                 * func login(): String
                 */
                Button('login')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
                    .id("login")
                    .onClick {
                        =>
                        // 需要使用spawn开线程调用RestAPI
                        spawn {
                            // 注意：频繁调用login接口后，服务器会触发防刷保护，导致接口返回失败
                            let res = restAPI.login()
                            Hilog.info(0, "RestAPI", "res:${res}")
                        }
                    }

                /*
                 * 使用认证令牌登录
                 * 参数authToken-认证令牌
                 * 返回登录结果(JSON字符串)
                 * func loginWithAuthToken(authToken: String): String
                 */
                Button('loginWithAuthToken')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("loginWithAuthToken")
                    .onClick {
                        => spawn {
                            // 先调用login获取authToken
                            let res0 = restAPI.login()
                            let resJson = JsonValue.fromStr(res0).asObject()
                            let success0 = (resJson.get("success").getOrThrow() as JsonBool).getOrThrow().getValue()
                            if (success0) {
                                let bodyObj = (resJson.get("body").getOrThrow() as JsonObject).getOrThrow()
                                let data = (bodyObj.get("data").getOrThrow() as JsonObject).getOrThrow()
                                let authToken = (data.get("authToken").getOrThrow() as JsonString).getOrThrow().getValue()
                                let res = restAPI.loginWithAuthToken(authToken)
                                Hilog.info(0, "RestAPI", "res:${res}")
                            }
                        }
                    }
                /*
                 * 获取当前登录用户信息
                 * 返回用户信息(JSON字符串)
                 * func me(): String
                 */
                Button('me')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("me")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            let res = restAPI.me()
                            Hilog.info(0, "RestAPI", "res:${res}")
                        }
                    }
                /*
                 * 创建新用户
                 * 参数data-用户数据(JSON字符串)
                 * 返回创建结果(JSON字符串)
                 * func userCreate(data: String): String
                 */
                Button('userCreate')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("userCreate")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建两个新用户xiaoqiang和xiaozhou
                            let createName = "qiangqiang"
                            let createUserEmail: String = "88754564566@xxx.com"
                            let createUserPassword: String = "123";
                            let createUserName: String = "xiaoqiang";
                            var active: Bool = true; // 用户是否激活.true用户可以登录.false用户被禁用（无法登录）
                            var roles: Array<String> = ["user"]; // 用户的角色
                            var joinDefaultChannels: Bool = true; // 新用户是否自动加入默认公共频道
                            var requirePasswordChange: Bool = false; // 用户首次登录时是否强制修改密码
                            var sendWelcomeEmail: Bool = false; // 创建用户后是否发送欢迎邮件
                            var verified: Bool = false; // 邮箱是否验证通过
                            let data: OnClickUsersCreate = OnClickUsersCreate(createName, createUserEmail,
                                createUserPassword, createUserName, active, roles, joinDefaultChannels,
                                requirePasswordChange, sendWelcomeEmail, verified)
                            // 注意：返回res返回结果的等待时间可能较长
                            let res: String = restAPI.userCreate(
                                data.serialize().toJson().asObject().toJsonString())
                            Hilog.info(0, "RestAPI", " res:${res}")
                            let createName2 = "zhouzhou"
                            let createUserEmail2: String = "1111111111@xxx.com"
                            let createUserPassword2: String = "123";
                            let createUserName2: String = "xiaozhou";
                            var active2: Bool = true;
                            var roles2: Array<String> = ["user"];
                            var joinDefaultChannels2: Bool = true;
                            var requirePasswordChange2: Bool = false;
                            var sendWelcomeEmail2: Bool = false;
                            var verified2: Bool = false;
                            let data2: OnClickUsersCreate = OnClickUsersCreate(createName2, createUserEmail2,
                                createUserPassword2, createUserName2, active2, roles2, joinDefaultChannels2,
                                requirePasswordChange2, sendWelcomeEmail2, verified2)
                            let res2: String = restAPI.userCreate(
                                data2.serialize().toJson().asObject().toJsonString())
                            Hilog.info(0, "RestAPI", " res2:${res2}")
                        }
                    }

                /*
                 * 获取用户列表
                 * 参数query-查询条件 例如"{\"username\":{\"$regex\":\"xiao\"}}"  表示筛选username字段的值包含"xiao"的结果
                 * 参数fields-返回字段 设置返回的数据要包含的字段，1表示包含该字段，0表示不包含.但是很多字段服务器不支持不包含，服务器会报返回无效设置参数。"{\"lastLogin\":0,\"username\":1}"表示不包含lastLogin字段,但包含username字段
                 * 参数sort-排序方式  1升序 -1降序 格式 ："{\"active\":1,\"name\":1}"  active和name只是返回数据中的某个key值，也可以换成别的.用例中表示先按active排序（1升序），如果active一样就按name再排序（-1降序）
                 * 参数count-返回数量。指的是返回的查询结果个数
                 * 参数offset-偏移量。offset 表示 跳过前面多少条记录。配合 count（每页条数）使用，可以分批获取用户列表
                 * 返回用户列表(JSON字符串)
                 * func usersList(query: String, fields: String, sort: String, count: Int64, offset: Int64): String
                 */
                Button('usersList')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("usersList")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            let regexObj = JsonObject()
                            regexObj.put("$regex", JsonString("xiao"))
                            let query = JsonObject()
                            query.put("username", regexObj)
                            let fields = JsonObject()
                            fields.put("lastLogin", JsonInt(0))
                            fields.put("username", JsonInt(1))
                            let sort = JsonObject()
                            sort.put("active", JsonInt(1))
                            sort.put("name", JsonInt(-1))
                            let count = 3
                            let offset = 0
                            let res = restAPI.usersList(query.toString(), fields.toString(), sort.toString(),
                                count, offset)
                            Hilog.info(0, "RestAPI", "res:${res}")
                        }
                    }
                /*
                 * 获取用户信息
                 * 参数userId-用户ID
                 * 参数userName-用户名(当userId为空时使用)
                 * 返回用户信息(JSON字符串)
                 * func usersInfo(userId: String, userName: String): String
                 */
                Button('usersInfo')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("usersInfo")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 从me里获取当前用户的userId和username用于usersInfo测试
                            let res1 = restAPI.me()
                            let bodyObj1 = (JsonValue.fromStr(res1).asObject().get("body").getOrThrow() as JsonObject)
                                .getOrThrow()
                            let userId = (bodyObj1.get("_id").getOrThrow() as JsonString).getOrThrow().getValue()
                            let userName = (bodyObj1.get("username").getOrThrow() as JsonString).getOrThrow()
                                .getValue()
                            let res = restAPI.usersInfo(userId, "")
                            Hilog.info(0, "RestAPI", "res:${res}")
                            let res2 = restAPI.usersInfo("", userName)
                            Hilog.info(0, "RestAPI", "res2:${res2}")
                        }
                    }
                /*
                 * 获取用户在线状态
                 * 参数userId-用户ID
                 * 参数userName-用户名(当userId为空时使用)
                 * 返回在线状态(JSON字符串)
                 * func usersPresence(userId: String, userName: String): String
                 */
                Button('usersPresence')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("usersPresence")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 从me里获取当前用户的userId和username用于usersInfo测试
                            let res1 = restAPI.me()
                            let bodyObj1 = (JsonValue.fromStr(res1).asObject().get("body").getOrThrow() as JsonObject)
                                .getOrThrow()
                            let userId = (bodyObj1.get("_id").getOrThrow() as JsonString).getOrThrow().getValue()
                            let userName = (bodyObj1.get("username").getOrThrow() as JsonString).getOrThrow()
                                .getValue()
                            let res = restAPI.usersPresence(userId, "")
                            Hilog.info(0, "RestAPI", "res:${res}")
                            let res2 = restAPI.usersPresence("", userName)
                            Hilog.info(0, "RestAPI", "res2:${res2}")
                        }
                    }
                /*
                 * 设置用户头像
                 * 参数avatarUrl-头像URL
                 * 返回设置结果(JSON字符串)
                 * func setAvatar(avatarUrl: String): String
                 */
                Button('setAvatar')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("setAvatar")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            let avatarUrl = "https://gitee.com/harmonyos-cases/cases/raw/ff424b3f9a54b5f2ea7a608ccd088b1f2d751d86/CommonAppDevelopment/feature/multiplefilesdownload/src/main/resources/base/media/stop.png"
                            // 实际效果为用户头像修改了
                            let res = restAPI.setAvatar(avatarUrl)
                            Hilog.info(0, "RestAPI", " res:${res}")
                        }
                    }

                /*
                 * 获取系统公共设置
                 * 返回设置信息(JSON字符串)
                 * func settings(): String
                 */
                Button('settings')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("settings")
                    .onClick {
                        => spawn {
                            let res = restAPI.settings()
                            Hilog.info(0, "RestAPI", " res:${res}")
                        }
                    }
                /*
                 * 记录访客页面访问数据
                 * 参数pageData-页面访问数据(JSON字符串)
                 * 返回记录结果(JSON字符串)
                 * func pageVisited(pageData: String): String
                 */
                Button('pageVisited')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("pageVisited")
                    .onClick {
                        => spawn {

                            // 这里虚拟一条的页面访问信息：第一个参数固定写死"url"，第二个参数当前页面的标题，第三个参数是当前浏览的网页地址
                            let pageInfo: PageInfo = PageInfo("url", "网页标题xxx",Location("https://image.baidu.com/"))
                            let pageData: PageData = PageData("需填真实的访客token","需填真实的Livechat会话房间ID", pageInfo)
                            let data = pageData.serialize().toJson().asObject().toJsonString()
                            let res = restAPI.pageVisited(data)
                            Hilog.info(0, "RestAPI", " res:${res}")
                        }
                    }
                /*
                 * 注册访客
                 * 参数visitor-访客信息(JSON字符串)
                 * 返回注册结果(JSON字符串)
                 * func visitorRegistration(visitor: String): String
                 */
                Button('visitorRegistration')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("visitorRegistration")
                    .onClick {
                        => spawn {
                            let visitorName = "访客小明"
                            let visitorEmail = "111111111@xx.com"
                            let visitorToken = "aaa"
                            let visitorPhone = "13611111111"
                            let visitorAddress = "A省B市C区XXX"
                            let visitor = Visitor(visitorName, visitorEmail, visitorToken, visitorPhone,
                                [CustomFields("address", visitorAddress, true)])
                            let visitorInfo: VisitorInfo = VisitorInfo()
                            visitorInfo.setVisitor(visitor)
                            let res = restAPI.visitorRegistration(
                                visitorInfo.serialize().toJson().asObject().toJsonString())
                            Hilog.info(0, "RestAPI", " res:${res}")
                        }
                    }
                /*
                 * 获取访客信息
                 * 参数token-访客token
                 * 返回访客信息(JSON字符串)
                 * func visitor(token: String): String
                 */
                Button('visitor')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("visitor")
                    .onClick {
                        => spawn {
                            // 需要先注册一个访客
                            let visitor = Visitor("访客1", "222222@xx.com", "aaa", "13611111111",
                                [CustomFields("address", "A省B市C区XXX", true)])
                            let visitorInfo: VisitorInfo = VisitorInfo()
                            visitorInfo.setVisitor(visitor)
                            let res0 = restAPI.visitorRegistration(
                                visitorInfo.serialize().toJson().asObject().toJsonString())
                            // 获取实际的访客token
                            let success0 = (JsonValue.fromStr(res0).asObject().get("success").getOrThrow() as JsonBool)
                                .getOrThrow().getValue()
                            if (success0) {
                                let bodyObj1 = (JsonValue.fromStr(res0).asObject().get("body").getOrThrow() as JsonObject)
                                    .getOrThrow()
                                let visitor = (bodyObj1.get("visitor").getOrThrow() as JsonObject).getOrThrow()
                                let visitorToken = (visitor.get("token").getOrThrow() as JsonString).getOrThrow()
                                    .getValue()
                                // 注意需要先调用visitorRegistration注册访客后，visitor才能找到
                                let res = restAPI.visitor(visitorToken)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 设置访客状态
                 * 参数visitor-访客状态信息(JSON字符串)
                 * 返回设置结果(JSON字符串)
                 * func setVisitorStatus(visitor: String): String
                 */
                Button('setVisitorStatus')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("setVisitorStatus")
                    .onClick {
                        => spawn {
                            // 需要先注册一个访客，拿到实际的访客token
                            let visitor = Visitor("访客1", "222222@xx.com", "aaa", "13611111111",
                                [CustomFields("address", "A省B市C区XXX", true)])
                            let visitorInfo: VisitorInfo = VisitorInfo()
                            visitorInfo.setVisitor(visitor)
                            let res0 = restAPI.visitorRegistration(
                                visitorInfo.serialize().toJson().asObject().toJsonString())
                            let success0 = (JsonValue.fromStr(res0).asObject().get("success").getOrThrow() as JsonBool)
                                .getOrThrow().getValue()
                            if (success0) {
                                let bodyObj1 = (JsonValue.fromStr(res0).asObject().get("body").getOrThrow() as JsonObject)
                                    .getOrThrow()
                                let visitor = (bodyObj1.get("visitor").getOrThrow() as JsonObject).getOrThrow()
                                let visitorToken = (visitor.get("token").getOrThrow() as JsonString).getOrThrow()
                                    .getValue()
                                let visitorStatus = JsonObject()
                                visitorStatus.put("token", JsonString(visitorToken))
                                visitorStatus.put("status", JsonString("busy"))
                                let res = restAPI.setVisitorStatus(visitorStatus.toString())
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 删除访客
                 * 参数token-访客token
                 * 返回删除结果(JSON字符串)
                 * func visitorDelete(token: String): String
                 */
                Button('visitorDelete')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("visitorDelete")
                    .onClick {
                        => spawn {
                            // 先注册一个访客，拿到实际的访客token
                            let visitor = Visitor("访客2", "33333@xx.com", "bbbb", "1361333312",
                                [CustomFields("address", "A省B市C区XXX", true)])
                            let visitorInfo: VisitorInfo = VisitorInfo()
                            visitorInfo.setVisitor(visitor)
                            let res0 = restAPI.visitorRegistration(
                                visitorInfo.serialize().toJson().asObject().toJsonString())
                            let success0 = (JsonValue.fromStr(res0).asObject().get("success").getOrThrow() as JsonBool)
                                .getOrThrow().getValue()
                            if (success0) {
                                let bodyObj1 = (JsonValue.fromStr(res0).asObject().get("body").getOrThrow() as JsonObject)
                                    .getOrThrow()
                                let visitor = (bodyObj1.get("visitor").getOrThrow() as JsonObject).getOrThrow()
                                let visitorToken = (visitor.get("token").getOrThrow() as JsonString).getOrThrow()
                                    .getValue()
                                let res = restAPI.visitorDelete(visitorToken)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 获取指定横幅信息
                 * 参数id-横幅ID
                 * 返回横幅信息(JSON字符串)
                 * func bannersEndPoint(id: Int64): String
                 */
                Button('bannersEndPoint')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("bannersEndPoint")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            let res = restAPI.bannersEndPoint(0)
                            Hilog.info(0, "RestAPI", " res:${res}")
                        }
                    }

                /*
                 * 获取所有横幅列表
                 * 返回横幅列表(JSON字符串)
                 * func getBanners(): String
                 */
                Button('getBanners')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("getBanners")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            let res = restAPI.getBanners()
                            Hilog.info(0, "RestAPI", " res:${res}")
                        }
                    }
                /*
                 * 创建新频道
                 * 参数channel-频道信息(JSON字符串)，包含:
                 *   - name: 频道名称
                 *   - members: 成员列表(可选)
                 *   - readOnly: 是否只读(可选)只有 频道管理员。只读：拥有特定权限的用户 可以发消息。其他成员只能阅读消息，不能发送
                 *   - customFields: 自定义字段(可选)
                 * 返回创建结果(JSON字符串)
                 * func createChannel(channel: String): String
                 */
                Button('createChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("createChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            let channelName = "pindao" + Random().nextUInt64().toString()
                            let reqData = JsonObject()
                            reqData.put("name", JsonString(channelName))
                            let members = JsonArray()
                            members.add(JsonString("xiaoming"))
                            members.add(JsonString("xiaozhou"))
                            reqData.put("members", members)
                            reqData.put("readOnly", JsonBool(false))
                            let customFields = JsonObject()
                            customFields.put("aaa", JsonString("bbb"))
                            reqData.put("customFields", customFields)
                            let res = restAPI.createChannel(reqData.toString())
                            Hilog.info(0, "RestAPI", " res:${res}")
                        }
                    }
                // 频道管理 API
                /*
                 * 关闭频道
                 * 参数roomId-频道ID
                 * 返回关闭结果(JSON字符串)
                 * func closeChannel(roomId: String): String
                 */
                Button('closeChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("closeChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 先创建一个频道,获取channelId
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let res = restAPI.closeChannel(channelId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 打开频道
                 * 参数roomId-频道ID
                 * 返回操作结果(JSON字符串)
                 * func openChannel(roomId: String): String
                 */
                Button('openChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("openChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 先创建一个频道,获取channelId
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                restAPI.closeChannel(channelId)
                                let res = restAPI.openChannel(channelId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 设置频道类型
                 * 参数roomId-频道ID
                 * 参数roomName-频道名称(当roomId为空时使用)
                 * 参数channelType-频道类型  c代表频道，p代表私人频道
                 * 返回设置结果(JSON字符串)
                 * func setTypeChannel(roomId: String, roomName: String, channelType: String): String
                 */
                Button('setTypeChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("setTypeChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 先创建一个频道,获取channelId
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            let channelName = channelInfo[1]
                            if (channelInfo.size > 0) {
                                let channelType = "p";
                                let res = restAPI.setTypeChannel(channelId, "", channelType)
                                Hilog.info(0, "RestAPI", " res:${res}")
                                let channelType2 = "c";
                                // 注意：第二次调用setTypeChannel会发现找不到，是因为前面频道类型改过了，导致后面从已有类型的频道中已经找不到了
                                let res2 = restAPI.setTypeChannel("", channelName, channelType2)
                                Hilog.info(0, "RestAPI", " res2:${res2}")
                            }
                        }
                    }
                /*
                 * 发送聊天消息 往指定的房间频道发一条消息
                 * 参数postMessageData-消息数据(JSON字符串)
                 * 返回发送结果(JSON字符串)
                 * func postMessageChat(postMessageData: String): String
                 */
                Button('postMessageChat')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("postMessageChat")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 先创建一个频道,获取channelId
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            let channelName = channelInfo[1]
                            if (channelInfo.size > 0) {
                                // postMessageChat中传attachments，返回空attachments[]
                                // channel 频道名称
                                // emoji 表情符号 消息发送者的头像会显示为这个 emoji
                                // roomId 对应房间或者频道ID
                                // text 发送的消息
                                // attachments 消息附件，可以带颜色、标题、图片、超链接等富文本内容
                                let attachments = [
                                    Attachments(
                                        "http://www.w3schools.com/tags/horse.mp3", // 附件里的音频文件链接
                                        "https://avatars.githubusercontent.com/u/850391?v=3", // 显示在作者名字旁边的图标（小头像）
                                        "https://www.baidu.com", // 点击作者名字时跳转的链接
                                        "xiaoming", // 附件的作者名字
                                        false, // 是否默认折叠附件
                                        "#ff0000", // 附件左边的竖条颜色，用于分类/提示
                                        // 在附件里以小块的形式展示一些结构化数据
                                        [Fields(true, "Test", "Testing out something or other"),
                                            Fields(true, "Another Test", "[Link](http://www.w3schools.com) something and this and this.")],
                                        "https://avatars.githubusercontent.com/u/850391?v=3",
                                        "http://www.w3schools.com", // 点击消息时跳转到的链接
                                        "Yay for gruggy!", // 附件正文
                                        "https://avatars.githubusercontent.com/u/850391?v=3", // 缩略图（显示在附件右边的小图）
                                        "Attachment Example", // 附件标题文字
                                        "http://www.w3schools.com", // 点击标题时跳转的链接
                                        true, // 点击标题链接时是否强制下载文件
                                        "2016-12-09T16:53:06.761Z", // 附件的时间标记（右上角显示时间）
                                        "http://www.w3schools.com/tags/movie.mp4" // 附件里的视频链接
                                    )
                                ]
                                let postMessageData: PostMessageData = PostMessageData("#" + channelName,
                                    ":smirk:", channelId, "Hello111111111", attachments)
                                let dataStr = postMessageData.serialize().toJson().asObject().toJsonString();
                                let res = restAPI.postMessageChat(dataStr)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 更新聊天消息
                 * 参数updateMsg-更新的消息数据(JSON字符串)
                 * 返回更新结果(JSON字符串)
                 * func updateMessageChat(updateMsg: String): String
                 */
                Button('updateMessageChat')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("updateMessageChat")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道,发送消息
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            let channelName = channelInfo[1]
                            if (channelInfo.size > 0) {
                                let attachments = [
                                    Attachments(
                                        "http://www.w3schools.com/tags/horse.mp3", // 附件里的音频文件链接
                                        "https://avatars.githubusercontent.com/u/850391?v=3", // 显示在作者名字旁边的图标（小头像）
                                        "https://www.baidu.com", // 点击作者名字时跳转的链接
                                        "xiaoming", // 附件的作者名字
                                        false, // 是否默认折叠附件
                                        "#ff0000", // 附件左边的竖条颜色，用于分类/提示
                                        // 在附件里以小块的形式展示一些结构化数据
                                        [Fields(true, "Test", "Testing out something or other"),
                                            Fields(true, "Another Test", "[Link](http://www.w3schools.com) something and this and this.")],
                                        "https://avatars.githubusercontent.com/u/850391?v=3",
                                        "http://www.w3schools.com", // 点击消息时跳转到的链接
                                        "Yay for gruggy!", // 附件正文
                                        "https://avatars.githubusercontent.com/u/850391?v=3", // 缩略图（显示在附件右边的小图）
                                        "Attachment Example", // 附件标题文字
                                        "http://www.w3schools.com", // 点击标题时跳转的链接
                                        true, // 点击标题链接时是否强制下载文件
                                        "2016-12-09T16:53:06.761Z", // 附件的时间标记（右上角显示时间）
                                        "http://www.w3schools.com/tags/movie.mp4" // 附件里的视频链接
                                    )
                                ]
                                let postMessageData: PostMessageData = PostMessageData("#" + channelName,
                                    ":smirk:", channelId, "Hello111111111", attachments)
                                let dataStr = postMessageData.serialize().toJson().asObject().toJsonString();
                                let res1 = restAPI.postMessageChat(dataStr)
                                let success = (JsonValue.fromStr(res1).asObject().get("success").getOrThrow() as JsonBool)
                                    .getOrThrow().getValue()
                                if (success) {
                                    let bodyObj = (JsonValue.fromStr(res1).asObject().get("body").getOrThrow() as JsonObject)
                                        .getOrThrow()
                                    let message = (bodyObj.get("message").getOrThrow() as JsonObject).getOrThrow()
                                    let messageId = (message.get("_id").getOrThrow() as JsonString).getOrThrow()
                                        .getValue()
                                    let text = "Hello Everyone!!"
                                    let reqData = JsonObject()
                                    reqData.put("roomId", JsonString(channelId))
                                    reqData.put("msgId", JsonString(messageId))
                                    reqData.put("text", JsonString(text))
                                    let res = restAPI.updateMessageChat(reqData.toString())
                                    Hilog.info(0, "RestAPI", " res:${res}")
                                }
                            }
                        }
                    }
                /*
                 * 删除聊天消息
                 * 参数roomId-房间ID
                 * 参数msgId-消息ID
                 * 参数asUser-是否以用户身份删除
                 * 返回删除结果(JSON字符串)
                 * func deleteMessageChat(roomId: String, msgId: String, asUser: Bool): String
                 */
                Button('deleteMessageChat')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("deleteMessageChat")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道,发送消息
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            let channelName = channelInfo[1]
                            if (channelInfo.size > 0) {
                                let attachments = [
                                    Attachments(
                                        "http://www.w3schools.com/tags/horse.mp3", // 附件里的音频文件链接
                                        "https://avatars.githubusercontent.com/u/850391?v=3", // 显示在作者名字旁边的图标（小头像）
                                        "https://www.baidu.com", // 点击作者名字时跳转的链接
                                        "xiaoming", // 附件的作者名字
                                        false, // 是否默认折叠附件
                                        "#ff0000", // 附件左边的竖条颜色，用于分类/提示
                                        // 在附件里以小块的形式展示一些结构化数据
                                        [Fields(true, "Test", "Testing out something or other"),
                                            Fields(true, "Another Test", "[Link](http://www.w3schools.com) something and this and this.")],
                                        "https://avatars.githubusercontent.com/u/850391?v=3",
                                        "http://www.w3schools.com", // 点击消息时跳转到的链接
                                        "Yay for gruggy!", // 附件正文
                                        "https://avatars.githubusercontent.com/u/850391?v=3", // 缩略图（显示在附件右边的小图）
                                        "Attachment Example", // 附件标题文字
                                        "http://www.w3schools.com", // 点击标题时跳转的链接
                                        true, // 点击标题链接时是否强制下载文件
                                        "2016-12-09T16:53:06.761Z", // 附件的时间标记（右上角显示时间）
                                        "http://www.w3schools.com/tags/movie.mp4" // 附件里的视频链接
                                    )
                                ]
                                let postMessageData: PostMessageData = PostMessageData("#" + channelName,
                                    ":smirk:", channelId, "Hello111111111", attachments)
                                let dataStr = postMessageData.serialize().toJson().asObject().toJsonString();
                                let res1 = restAPI.postMessageChat(dataStr)
                                let success = (JsonValue.fromStr(res1).asObject()
                                    .get("success").getOrThrow() as JsonBool).getOrThrow().getValue()
                                if (success) {
                                    let bodyObj = (JsonValue.fromStr(res1).asObject().get("body")
                                        .getOrThrow() as JsonObject).getOrThrow()
                                    let message = (bodyObj.get("message").getOrThrow() as JsonObject).getOrThrow()
                                    let messageId = (message.get("_id").getOrThrow() as JsonString)
                                        .getOrThrow().getValue()
                                    let res = restAPI.deleteMessageChat(channelId, messageId, false)
                                    Hilog.info(0, "RestAPI", " res:${res}")
                                }
                            }
                        }
                    }
                /*
                 * 邀请用户加入频道
                 * 参数roomId-频道ID
                 * 参数userId-被邀请用户ID
                 * 返回邀请结果(JSON字符串)
                 * func inviteChannel(roomId: String, userId: String): String
                 */
                Button('inviteChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("inviteChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 前提：前面已经手动创建一个用户xiaoqiang ，查询xiaoqiang的用户id
                            let xiaoqiangId = getUserIdByUsername("xiaoqiang")
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let res = restAPI.inviteChannel(channelId, xiaoqiangId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 添加频道领导者
                 * 参数roomId-频道ID
                 * 参数userId-用户ID
                 * 返回操作结果(JSON字符串)
                 * func addLeaderChannel(roomId: String, userId: String): String
                 */
                Button('addLeaderChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("addLeaderChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 前提：前面已经手动创建一个用户xiaoqiang ，查询xiaoqiang的用户id
                            let xiaoqiangId = getUserIdByUsername("xiaoqiang")
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                restAPI.inviteChannel(channelId, xiaoqiangId)
                                let res = restAPI.addLeaderChannel(channelId, xiaoqiangId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 移除频道领导者
                 * 参数roomId-频道ID
                 * 参数userId-用户ID
                 * 返回操作结果(JSON字符串)
                 * func removeLeaderChannel(roomId: String, userId: String): String
                 */
                Button('removeLeaderChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("removeLeaderChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 前提：前面已经手动创建一个用户xiaoqiang ，查询xiaoqiang的用户id
                            let xiaoqiangId = getUserIdByUsername("xiaoqiang")
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                restAPI.inviteChannel(channelId, xiaoqiangId)
                                restAPI.addLeaderChannel(channelId, xiaoqiangId)
                                let res = restAPI.removeLeaderChannel(channelId, xiaoqiangId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 添加频道管理员角色
                 * 参数roomId-频道ID
                 * 参数userId-用户ID
                 * 返回操作结果(JSON字符串)
                 * func addModeratorChannel(roomId: String, userId: String): String
                 */
                Button('addModeratorChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("addModeratorChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 前提：前面已经手动创建一个用户xiaoqiang ，查询xiaoqiang的用户id
                            let xiaoqiangId = getUserIdByUsername("xiaoqiang")
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                restAPI.inviteChannel(channelId, xiaoqiangId)
                                let res = restAPI.addModeratorChannel(channelId, xiaoqiangId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 移除频道管理员角色
                 * 参数roomId-频道ID
                 * 参数userId-用户ID
                 * 返回操作结果(JSON字符串)
                 * func removeModeratorChannel(roomId: String, userId: String): String
                 */
                Button('removeModeratorChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("removeModeratorChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 前提：前面已经手动创建一个用户xiaoqiang ，查询xiaoqiang的用户id
                            let xiaoqiangId = getUserIdByUsername("xiaoqiang") // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                restAPI.inviteChannel(channelId, xiaoqiangId)
                                restAPI.addModeratorChannel(channelId, xiaoqiangId)
                                let res = restAPI.removeModeratorChannel(channelId, xiaoqiangId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 添加频道所有者
                 * 参数roomId-频道ID
                 * 参数userId-用户ID
                 * 返回操作结果(JSON字符串)
                 * func addOwnerChannel(roomId: String, userId: String): String
                 */
                Button('addOwnerChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("addOwnerChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 前提：前面已经手动创建一个用户xiaoqiang ，查询xiaoqiang的用户id
                            let regexObj = JsonObject()
                            regexObj.put("$regex", JsonString("xiaoqiang"))
                            let query = JsonObject()
                            query.put("username", regexObj)
                            let xiaoqiangId = getUserIdByUsername("xiaoqiang") // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                restAPI.inviteChannel(channelId, xiaoqiangId)
                                let res = restAPI.addOwnerChannel(channelId, xiaoqiangId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 移除频道所有者
                 * 参数roomId-频道ID
                 * 参数userId-用户ID
                 * 返回操作结果(JSON字符串)
                 * func removeOwnerChannel(roomId: String, userId: String): String
                 */
                Button('removeOwnerChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("removeOwnerChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 前提：前面已经手动创建一个用户xiaoqiang ，查询xiaoqiang的用户id
                            let xiaoqiangId = getUserIdByUsername("xiaoqiang")
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                restAPI.inviteChannel(channelId, xiaoqiangId)
                                restAPI.addOwnerChannel(channelId, xiaoqiangId)
                                let res = restAPI.removeOwnerChannel(channelId, xiaoqiangId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 设置频道用途说明
                 * 参数roomId-频道ID
                 * 参数purpose-用途说明
                 * 返回设置结果(JSON字符串)
                 * func setPurposeChannel(roomId: String, purpose: String): String
                 */
                Button('setPurposeChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("setPurposeChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let res = restAPI.setPurposeChannel(channelId, "频道说明11111111111111")
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 设置频道只读状态
                 * 参数roomId-频道ID
                 * 参数readOnly-是否只读
                 * 返回设置结果(JSON字符串)
                 * func setReadOnlyChannel(roomId: String, readOnly: Bool): String
                 */
                Button('setReadOnlyChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("setReadOnlyChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let readOnly = true;
                                let res = restAPI.setReadOnlyChannel(channelId, readOnly)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 归档频道 就是把它“封存”起来：不能再发新消息（频道变成只读状态），历史消息和文件依然保留，所有成员还可以进去看
                 * 参数roomId-频道ID
                 * 返回归档结果(JSON字符串)
                 * func archiveChannel(roomId: String): String
                 */
                Button('archiveChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("archiveChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let res = restAPI.archiveChannel(channelId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 取消频道归档
                 * 参数roomId-频道ID
                 * 返回取消归档结果(JSON字符串)
                 * func unArchiveChannel(roomId: String): String
                 */
                Button('unArchiveChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("unArchiveChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                restAPI.archiveChannel(channelId)
                                let res = restAPI.unArchiveChannel(channelId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 获取某个频道的统计信息
                 * 参数roomId-频道ID
                 * 返回计数信息(JSON字符串)
                 * func counterChannel(roomId: String): String
                 */
                Button('counterChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("counterChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let res = restAPI.counterChannel(channelId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 获取频道文件列表
                 * 参数roomId-频道ID
                 * 参数roomName-频道名称(当roomId为空时使用)
                 * 返回文件列表(JSON字符串)
                 * func filesChannel(roomId: String, roomName: String): String
                 */
                Button('filesChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("filesChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            let channelName = channelInfo[1]
                            if (channelInfo.size > 0) {
                                // 客户端上上传一个文件可以看到实际统计数据
                                let res = restAPI.filesChannel(channelId, "")
                                Hilog.info(0, "RestAPI", " res:${res}")
                                let res2 = restAPI.filesChannel("", channelName)
                                Hilog.info(0, "RestAPI", " res2:${res2}")
                            }
                        }
                    }
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
                 * func historyChannel(roomId: String, optionalParams: JsonValue): String
                 */
                Button('historyChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("historyChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            let channelName = channelInfo[1]
                            if (channelInfo.size > 0) {
                                let inclusive = true;
                                let offset = 2;
                                let count = 100;
                                let unreads = true;
                                let latest = DateTime.nowUTC()
                                let oldest = DateTime.ofUTC(year: 2022, month: 3, dayOfMonth: 29)
                                let optionalParams: OptionalParams = OptionalParams(latest.toString(),
                                    oldest.toString(), inclusive, offset, count, unreads)
                                // 可以发个附件来测
                                let res = restAPI.historyChannel(channelId, "",JsonValue.fromStr(
                                    optionalParams.serialize().toJson().asObject().toJsonString()))
                                Hilog.info(0, "RestAPI", " res:${res}")
                                let res2 = restAPI.historyChannel("", channelName,JsonValue.fromStr(
                                    optionalParams.serialize().toJson().asObject().toJsonString()))
                                Hilog.info(0, "RestAPI", " res2:${res2}")
                            }
                        }
                    }

                /*
                 * 获取频道信息
                 * 参数roomId-频道ID
                 * 参数roomName-频道名称(当roomId为空时使用)
                 * 返回频道信息(JSON字符串)
                 * func infoChannel(roomId: String, roomName: String): String
                 */
                Button('infoChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("infoChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            let channelName = channelInfo[1]
                            if (channelInfo.size > 0) {
                                let res = restAPI.infoChannel(channelId, "")
                                Hilog.info(0, "RestAPI", " res:${res}")
                                let res2 = restAPI.infoChannel("", channelName)
                                Hilog.info(0, "RestAPI", " res2:${res2}")
                            }
                        }
                    }

                /*
                 * 加入频道
                 * 参数roomId-频道ID
                 * 参数joinCode-加入码(如果需要)
                 * 返回加入结果(JSON字符串)
                 * func joinChannel(roomId: String, joinCode: String): String
                 */
                Button('joinChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("joinChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            let channelName = channelInfo[1]
                            if (channelInfo.size > 0) {
                                let joinCode = "xxxxxx"; // 加入码可以通过setJoinCodeChannel设置
                                let res = restAPI.joinChannel(channelId, joinCode)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 将用户踢出频道
                 * 参数roomId-频道ID
                 * 参数userId-被踢用户ID
                 * 返回操作结果(JSON字符串)
                 * func kickChannel(roomId: String, userId: String): String
                 */
                Button('kickChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("kickChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录login
                            let regexObj = JsonObject()
                            regexObj.put("$regex", JsonString("xiaozhou"))
                            let query = JsonObject()
                            query.put("username", regexObj)
                            let res1 = restAPI.usersList(query.toString(), "", "", 1, 0)
                            let resJson = JsonValue.fromStr(res1).asObject()
                            let bodyObj = (resJson.get("body").getOrThrow() as JsonObject).getOrThrow()
                            if (let Some(users) <- bodyObj.get("users")) {
                                let xiaozhouId = (((users as JsonArray).getOrThrow().get(0)
                                    .getOrThrow() as JsonObject).getOrThrow().get("_id")
                                    .getOrThrow() as JsonString).getOrThrow().getValue()
                                // 创建频道
                                let channelInfo = createTestChannel()
                                let channelId = channelInfo[0]
                                if (channelInfo.size > 0) {
                                    let res = restAPI.kickChannel(channelId, xiaozhouId)
                                    Hilog.info(0, "RestAPI", " res:${res}")
                                }
                            }
                        }
                    }

                /*
                 * 离开频道
                 * 参数roomId-频道ID
                 * 返回离开结果(JSON字符串)
                 * func leaveChannel(roomId: String): String
                 */
                Button('leaveChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("leaveChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            let regexObj = JsonObject()
                            regexObj.put("$regex", JsonString("xiaozhou"))
                            let query = JsonObject()
                            query.put("username", regexObj)
                            let res1 = restAPI.usersList(query.toString(), "", "", 1, 0)
                            let resJson = JsonValue.fromStr(res1).asObject()
                            let bodyObj = (resJson.get("body").getOrThrow() as JsonObject).getOrThrow()
                            if (let Some(users) <- bodyObj.get("users")) {
                                let xiaozhouId = (((users as JsonArray).getOrThrow().get(0).getOrThrow() as JsonObject)
                                    .getOrThrow().get("_id").getOrThrow() as JsonString).getOrThrow().getValue()
                                // 创建频道
                                let channelInfo = createTestChannel()
                                let channelId = channelInfo[0]
                                if (channelInfo.size > 0) {
                                    // 把xiaozhou设置为Owner，然后再离开
                                    restAPI.addOwnerChannel(channelId, xiaozhouId)
                                    let res = restAPI.leaveChannel(channelId)
                                    Hilog.info(0, "RestAPI", " res:${res}")
                                }
                            }
                        }
                    }
                /*
                 * 获取所有频道列表
                 * 返回频道列表(JSON字符串)
                 * func listChannel(): String
                 */
                Button('listChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("listChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录login
                            let res = restAPI.listChannel()
                            Hilog.info(0, "RestAPI", " res:${res}")
                        }
                    }
                /*
                 * 获取已加入的频道列表
                 * 返回频道列表(JSON字符串)
                 * func joinListChannel(): String
                 */
                Button('joinListChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("joinListChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录login
                            let res = restAPI.joinListChannel()
                            Hilog.info(0, "RestAPI", " res:${res}")
                        }
                    }
                /*
                 * 获取频道成员列表
                 * 参数roomId-频道ID
                 * 参数roomName-频道名称(当roomId为空时使用)
                 * 返回成员列表(JSON字符串)
                 * func membersChannel(roomId: String, roomName: String): String
                 */
                Button('membersChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("membersChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录login
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            let channelName = channelInfo[1]
                            if (channelInfo.size > 0) {
                                let res = restAPI.membersChannel(channelId, "")
                                Hilog.info(0, "RestAPI", " res:${res}")
                                let res2 = restAPI.membersChannel("", channelName)
                                Hilog.info(0, "RestAPI", " res2:${res2}")
                            }
                        }
                    }
                /*
                 * 获取频道当前在线用户
                 * 参数roomId-频道ID
                 * 返回在线用户列表(JSON字符串)
                 * func onlineChannel(roomId: String): String
                 */
                Button('onlineChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("onlineChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录login
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let res = restAPI.onlineChannel(channelId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 获取频道中@用户的所有消息 (获取的是别人@的信息，不能获取自己@别人的信息)
                 * 参数roomId-频道ID
                 * 返回提及信息列表(JSON字符串)
                 * func getUserAllMentionByChannel(roomId: String): String
                 */
                Button('getUserAllMentionByChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("getUserAllMentionByChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录login
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let res = restAPI.getUserAllMentionByChannel(channelId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 重命名频道
                 * 参数roomId-频道ID
                 * 参数name-新名称
                 * 返回重命名结果(JSON字符串)
                 * func renameChannel(roomId: String, name: String): String
                 */
                Button('renameChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("renameChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录login
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let name = "Newpindao" + Random().nextUInt64().toString()
                                let res = restAPI.renameChannel(channelId, name)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 获取频道角色列表
                 * 参数roomId-频道ID
                 * 参数roomName-频道名称(当roomId为空时使用)
                 * 返回角色列表(JSON字符串)
                 * func rolesChannel(roomId: String, roomName: String): String
                 */
                Button('rolesChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("rolesChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录login
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            let channelName = channelInfo[1]
                            if (channelInfo.size > 0) {
                                let res = restAPI.rolesChannel(channelId, "")
                                Hilog.info(0, "RestAPI", " res:${res}")
                                let res2 = restAPI.rolesChannel("", channelName)
                                Hilog.info(0, "RestAPI", " res2:${res2}")
                            }
                        }
                    }
                /*
                 * 设置频道公告
                 * 参数roomId-频道ID
                 * 参数announcement-公告内容
                 * 返回设置结果(JSON字符串)
                 * func setAnnouncementChannel(roomId: String, announcement: String): String
                 */
                Button('setAnnouncementChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("setAnnouncementChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录login
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let announcement = "hello6666";
                                let res = restAPI.setAnnouncementChannel(channelId, announcement)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 设置频道加入码
                 * 参数roomId-频道ID
                 * 参数joinCode-加入码
                 * 返回设置结果(JSON字符串)
                 * func setJoinCodeChannel(roomId: String, joinCode: String): String
                 */
                Button('setJoinCodeChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("setJoinCodeChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录login
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let joinCode = "998"
                                let res = restAPI.setJoinCodeChannel(channelId, joinCode)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 获取频道集成列表
                 * 参数roomId-频道ID
                 * 返回集成列表(JSON字符串)
                 * func getIntegrationChannel(roomId: String): String
                 */
                Button('getIntegrationChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("getIntegrationChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录login
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let res = restAPI.getIntegrationChannel(channelId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 设置默认频道
                 * 参数roomId-频道ID
                 * 参数isDefault-是否为默认频道
                 * 返回设置结果(JSON字符串)
                 * func setDefaultChannel(roomId: String, isDefault: Bool): String
                 */
                Button('setDefaultChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("setDefaultChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let isDefault = true;
                                let res = restAPI.setDefaultChannel(channelId, isDefault)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 将所有用户添加到指定频道
                 * 参数roomId-频道ID
                 * 参数activeUsersOnly-是否仅添加活跃用户
                 * 返回操作结果(JSON字符串)
                 * func addAllChannel(roomId: String, activeUsersOnly: Bool): String
                 */
                Button('addAllChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("addAllChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let activeUsersOnly = true;
                                let res = restAPI.addAllChannel(channelId, activeUsersOnly)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 获取频道消息
                 * 参数 roomId - 频道 ID（必填）
                 * 参数 count - 返回的消息条数（可选，默认 50）
                 * 参数 sort - 排序方式（可选，默认 {"ts": -1}，按时间降序）
                 * 参数 offset - 跳过前几条消息（可选，默认 0）
                 * 返回消息列表 (JSON 字符串)
                 * func messageChannel(roomId: String, roomName: String): String
                 */
                Button('messageChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("messageChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let sort = JsonObject()
                                sort.put("ts", JsonInt(1))
                                let res = restAPI.messageChannel(channelId, count: 3, sort: sort.toString(),
                                    offset: 1)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 设置频道自定义字段
                 * 参数roomId-频道ID
                 * 参数customField-自定义字段(JSON对象)
                 * 返回设置结果(JSON字符串)
                 * func setCustomFieldsChannel(roomId: String, roomName: String, customField: JsonObject): String
                 */
                Button('setCustomFieldsChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("setCustomFieldsChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let customField: CustomField = CustomField("tra-la-la");
                                let res = restAPI.setCustomFieldsChannel(channelId,
                                    customField.serialize().toJson().asObject())
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 设置频道主题
                 * 参数roomId-频道ID
                 * 参数topic-主题内容
                 * 返回设置结果(JSON字符串)
                 * func setTopicChannel(roomId: String, topic: String): String
                 */
                Button('setTopicChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("setTopicChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let topic = "Test" + Random().nextUInt64().toString()
                                let res = restAPI.setTopicChannel(channelId, topic)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 删除一个频道（永久移除）
                 * 参数roomId-频道ID
                 * 参数roomName-频道名称(当roomId为空时使用)
                 * 返回删除结果
                 * public func deleteChannel(roomId: String, roomName: String): String
                 */
                Button('deleteChannel')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("deleteChannel")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            // 创建频道
                            let channelInfo = createTestChannel()
                            let channelId = channelInfo[0]
                            if (channelInfo.size > 0) {
                                let res = restAPI.deleteChannel(channelId, "")
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                            let channelInfo2 = createTestChannel()
                            let channelName = channelInfo2[1]
                            if (channelInfo2.size > 0) {
                                let res2 = restAPI.deleteChannel("", channelName)
                                Hilog.info(0, "RestAPI", " res2:${res2}")
                            }
                        }
                    }
                /*
                 * 创建新群组
                 * 参数group-群组信息(JSON字符串)，包含:
                 *   - name: 群组名称
                 *   - members: 成员列表(可选)
                 *   - readOnly: 是否只读(可选)
                 *   - customFields: 自定义字段(可选)
                 * 返回创建结果(JSON字符串)
                 * func groupCreate(group: String): String
                 */
                Button('groupCreate')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupCreate")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            let groupName = "Group" + Random().nextUInt64().toString()
                            let reqData = JsonObject()
                            reqData.put("name", JsonString(groupName))
                            let members = JsonArray()
                            members.add(JsonString("xiaozhou"))
                            reqData.put("members", members)
                            reqData.put("readOnly", JsonBool(false))
                            let customFields = JsonObject()
                            customFields.put("aaa", JsonString("bbb"))
                            reqData.put("customFields", customFields)
                            let res = restAPI.groupCreate(reqData.toString())
                            Hilog.info(0, "RestAPI", " res:${res}")
                        }
                    }
                /*
                 * 邀请用户加入群组
                 * 参数groupID-群组ID
                 * 参数userId-被邀请用户ID
                 * 返回邀请结果(JSON字符串)
                 * func groupInvite(groupID: String, userId: String): String
                 */
                Button('groupInvite')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupInvite")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                // 前提：前面已经手动创建一个用户xiaoqiang ，查询xiaoqiang的用户id
                                let xiaoqiangId = getUserIdByUsername("xiaoqiang")
                                let res = restAPI.groupInvite(groupID, xiaoqiangId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 重命名群组
                 * 参数name-新名称
                 * 参数groupID-群组ID
                 * 返回重命名结果(JSON字符串)
                 * func groupRename(name: String, groupID: String): String
                 */
                Button('groupRename')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupRename")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let newGroup = "NewGroup" + Random().nextUInt64().toString()
                                let res = restAPI.groupRename(newGroup, groupID)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 设置群组只读状态
                 * 参数groupID-群组ID
                 * 参数readOnly-是否只读
                 * 返回设置结果(JSON字符串)
                 * func groupSetReadOnly(groupID: String, readOnly: Bool): String
                 */
                Button('groupSetReadOnly')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupSetReadOnly")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let res = restAPI.groupSetReadOnly(groupID, true)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 设置群组主题
                 * 参数groupID-群组ID
                 * 参数groupTopic-主题内容
                 * 返回设置结果(JSON字符串)
                 * func groupSetTopic(groupID: String, groupTopic: String): String
                 */
                Button('groupSetTopic')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupSetTopic")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let readOnly = false;
                                let res = restAPI.groupSetTopic(groupID, "Topic111111111111")
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                // 群组相关 API
                /*
                 * 添加群组领导者
                 * 参数groupID-群组ID
                 * 参数userId-用户ID
                 * 返回操作结果(JSON字符串)
                 * func groupAddLeader(groupID: String, userId: String): String
                 */
                Button('groupAddLeader')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupAddLeader")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let xiaozhouId = getUserIdByUsername("xiaozhou")
                                let res = restAPI.groupAddLeader(groupID, xiaozhouId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 获取群组信息
                 * 参数roomId-群组ID
                 * 参数roomName-群组名称(当roomId为空时使用)
                 * 返回群组信息(JSON字符串)
                 * func groupInfo(roomId: String, roomName: String): String
                 */
                Button('groupInfo')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupInfo")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let res = restAPI.groupInfo(groupID, "")
                                Hilog.info(0, "RestAPI", " res:${res}")
                                let res2 = restAPI.groupInfo("", roomName)
                                Hilog.info(0, "RestAPI", " res2:${res2}")
                            }
                        }
                    }
                /*
                 * 获取群组列表
                 * 返回群组列表(JSON字符串)
                 * func groupList(): String
                 */
                Button('groupList')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupList")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            let res = restAPI.groupList()
                            Hilog.info(0, "RestAPI", " res:${res}")
                        }
                    }
                /*
                 * 添加群组管理员
                 * 参数groupID-群组ID
                 * 参数userId-用户ID
                 * 返回操作结果(JSON字符串)
                 * func groupAddModerator(groupID: String, userId: String): String
                 */
                Button('groupAddModerator')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupAddModerator")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let xiaozhouId = getUserIdByUsername("xiaozhou")
                                let res = restAPI.groupAddModerator(groupID, xiaozhouId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 移除群组管理员
                 * 参数groupID-群组ID
                 * 参数userId-用户ID
                 * 返回操作结果(JSON字符串)
                 * func groupRemoveModerator(groupID: String, userId: String): String
                 */
                Button('groupRemoveModerator')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupRemoveModerator")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let xiaozhouId = getUserIdByUsername("xiaozhou")
                                let res = restAPI.groupRemoveModerator(groupID, xiaozhouId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 设置群组描述
                 * 参数groupID-群组ID
                 * 参数groupDescription-描述内容
                 * 返回设置结果(JSON字符串)
                 * func groupSetDescription(groupID: String, groupDescription: String): String
                 */
                Button('groupSetDescription')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupSetDescription")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let res = restAPI.groupSetDescription(groupID, "SetDescription11111")
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 归档群组
                 * 参数groupID-群组ID
                 * 返回归档结果(JSON字符串)
                 * func groupArchive(groupID: String): String
                 */
                Button('groupArchive')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupArchive")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let res = restAPI.groupArchive(groupID)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 取消群组归档
                 * 参数groupID-群组ID
                 * 返回取消归档结果(JSON字符串)
                 * func groupUnArchive(groupID: String): String
                 */
                Button('groupUnArchive')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupUnArchive")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                restAPI.groupArchive(groupID)
                                let res = restAPI.groupUnArchive(groupID)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 获取群组集成列表
                 * 参数roomId-群组ID
                 * 返回集成列表(JSON字符串)
                 * func groupIntegrations(roomId: String): String
                 */
                Button('groupIntegrations')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupIntegrations")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let res = restAPI.groupIntegrations(groupID)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 关闭群组
                 * 参数groupID-群组ID
                 * 返回关闭结果(JSON字符串)
                 * func groupClose(groupID: String): String
                 */
                Button('groupClose')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupClose")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let res = restAPI.groupClose(groupID)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 打开群组
                 * 参数groupID-群组ID
                 * 返回打开结果(JSON字符串)
                 * func groupOpen(groupID: String): String
                 */
                Button('groupOpen')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupOpen")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                restAPI.groupClose(groupID)
                                let res = restAPI.groupOpen(groupID)
                            }
                        }
                    }
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
                 * func groupHistory(roomId: String, optionalParams: JsonValue): String
                 */
                Button('groupHistory')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupHistory")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let inclusive = true;
                                let offset = 2;
                                let count = 100;
                                let unreads = true;
                                let latest = DateTime.nowUTC()
                                let oldest = DateTime.ofUTC(year: 2022, month: 3, dayOfMonth: 29)
                                let optionalParams: OptionalParams = OptionalParams(latest.toString(),
                                    oldest.toString(), inclusive, offset, count, unreads)
                                let res = restAPI.groupHistory(
                                    groupID,
                                    JsonValue.fromStr(
                                        optionalParams.serialize().toJson().asObject().toJsonString())
                                )
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 设置群组类型
                 * 参数groupID-群组ID
                 * 参数groupType-群组类型
                 * 返回设置结果(JSON字符串)
                 * func groupSetType(groupID: String, groupType: String): String
                 */
                Button('groupSetType')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupSetType")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                // create-c：需要这个权限才能把 私有群组(p) 改成 公共频道(c)
                                // create-p：需要这个权限才能把 公共频道(c) 改成 私有群组(p)
                                // create-team-channel：当目标是 团队房间 时，把 团队的私有频道 → 公共频道 需要此权限
                                // create-team-group：当目标是 团队房间 时，把 团队的公共频道 → 私有群组 需要此权限
                                let res = restAPI.groupSetType(groupID, 'c')
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 设置群组用途 (purpose)
                 * 参数 roomId       - 群组 ID
                 * 参数 groupPurpose - 群组用途或简介文本
                 * 返回设置结果 (JSON 字符串)，success 为 true 表示设置成功
                 * func groupSetPurpose(roomId: String, groupPurpose: String): String
                 */
                Button('groupSetPurpose')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupSetPurpose")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let res = restAPI.groupSetPurpose(groupID, "groupSetPurpose1111111111")
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 将用户踢出群组
                 * 参数groupID-群组ID
                 * 参数userId-被踢用户ID
                 * 返回操作结果(JSON字符串)
                 * func groupKick(groupID: String, userId: String): String
                 */
                Button('groupKick')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupKick")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let xiaozhouId = getUserIdByUsername("xiaozhou")
                                let res = restAPI.groupKick(groupID, xiaozhouId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 将所有用户添加到群组
                 * 参数groupID-群组ID
                 * 参数activeUsersOnly-是否仅添加活跃用户
                 * 返回操作结果(JSON字符串)
                 * func groupAddAll(groupID: String, activeUsersOnly: Bool): String
                 */
                Button('groupAddAll')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupAddAll")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let activeUsersOnly = false
                                let res = restAPI.groupAddAll(groupID, activeUsersOnly)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }

                /*
                 * 添加群组所有者
                 * 参数groupID-群组ID
                 * 参数userId-用户ID
                 * 返回操作结果(JSON字符串)
                 * func groupAddOwner(groupID: String, userId: String): String
                 */
                Button('groupAddOwner')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupAddOwner")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let xiaozhouId = getUserIdByUsername("xiaozhou")
                                let res = restAPI.groupAddOwner(groupID, xiaozhouId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 移除群组所有者
                 * 参数groupID-群组ID
                 * 参数userId-用户ID
                 * 返回操作结果(JSON字符串)
                 * func groupRemoveOwner(groupID: String, userId: String): String
                 */
                Button('groupRemoveOwner')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupRemoveOwner")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let xiaozhouId = getUserIdByUsername("xiaozhou")
                                restAPI.groupAddOwner(groupID, xiaozhouId)

                                let res = restAPI.groupRemoveOwner(groupID, xiaozhouId)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 离开群组
                 * 参数groupID-群组ID
                 * 返回离开结果(JSON字符串)
                 * func groupLeave(groupID: String): String
                 */
                Button('groupLeave')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupLeave")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let xiaozhouId = getUserIdByUsername("xiaozhou")
                                restAPI.groupAddOwner(groupID, xiaozhouId)
                                let res = restAPI.groupLeave(groupID)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 删除群组（私有群组）
                 * 参数 roomId   - 群组 ID（必填，如果提供则优先使用）
                 * 参数 roomName - 群组名称（可选，当未提供 roomId 时使用）
                 * 返回删除操作结果 (JSON 字符串)，success 为 true 表示删除成功
                 * func groupDelete(roomId: String, roomName: String): String
                 */
                Button('groupDelete')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("groupDelete")
                    .onClick {
                        => spawn {
                            // 先创建一个群组,获取groupID
                            let groupInfo = createTestGroup()
                            let groupID = groupInfo[0]
                            let roomName = groupInfo[1]
                            if (groupInfo.size > 0) {
                                let res = restAPI.groupDelete(groupID, "")
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                            let groupInfo2 = createTestGroup()
                            let groupID2 = groupInfo2[0]
                            let roomName2 = groupInfo2[1]
                            if (groupInfo2.size > 0) {
                                let res2 = restAPI.groupDelete("", roomName2)
                                Hilog.info(0, "RestAPI", " res2:${res2}")
                            }
                        }
                    }

                /*
                 * 删除用户
                 * 参数userId-用户ID
                 * 参数confirmRelinquish-确认放弃所有权
                 * 返回删除结果(JSON字符串)
                 * func userDelete(userId: String, confirmRelinquish: Bool): String
                 */
                Button('userDelete')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("userDelete")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            let xiaozhouId = getUserIdByUsername("xiaozhou")
                            if (xiaozhouId != "") {
                                let res = restAPI.userDelete(xiaozhouId, true)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            } else {
                                Hilog.info(0, "RestAPI", "[userDelete]:xiaozhouId not exist")
                            }
                            let xiaoqiangId = getUserIdByUsername("xiaoqiang")
                            if (xiaoqiangId != "") {
                                let res = restAPI.userDelete(xiaoqiangId, true)
                                Hilog.info(0, "RestAPI", " res:${res}")
                            }
                        }
                    }
                /*
                 * 用户退出登录
                 * 无参数
                 * 返回退出结果(JSON字符串)，success 为 true 表示退出成功
                 * func logout(): String
                 */
                Button('logout')
                    .width(90.percent)
                    .height(35)
                    .shape(ShapeType.Normal)
                    .backgroundColor(Color.GREEN)
					.id("logout")
                    .onClick {
                        => spawn {
                            // 需要先登录
                            let res = restAPI.logout()
                            Hilog.info(0, "RestAPI", " res:${res}")
                        }
                    }
            }.width(100.percent)
        }.width(100.percent).height(100.percent)
    }

    // 创建测试用频道
    func createTestChannel(): Array<String> {
        let channelName = "pindao" + Random().nextUInt64().toString()
        let reqData = JsonObject()
        reqData.put("name", JsonString(channelName))
        let members = JsonArray()
        members.add(JsonString("xiaoming"))
        members.add(JsonString("xiaozhou"))
        reqData.put("members", members)
        reqData.put("readOnly", JsonBool(false))
        let customFields = JsonObject()
        customFields.put("aaa", JsonString("bbb"))
        reqData.put("customFields", customFields)
        let res = restAPI.createChannel(reqData.toString())
        let resJson = JsonValue.fromStr(res).asObject()
        let success = (JsonValue.fromStr(res).asObject().get("success").getOrThrow() as JsonBool).getOrThrow().getValue()
        if (success) {
            let bodyObj = (resJson.get("body").getOrThrow() as JsonObject).getOrThrow()
            let data = (bodyObj.get("channel").getOrThrow() as JsonObject).getOrThrow()
            let channelId = (data.get("_id").getOrThrow() as JsonString).getOrThrow().getValue()
            let channelName = (data.get("fname").getOrThrow() as JsonString).getOrThrow().getValue()
            Hilog.info(0, "RestAPI", "createTestChannel channelId:${channelId}  channelName:${channelName} ")
            return [channelId, channelName]
        }
        return []
    }

    // 创建测试用群组
    func createTestGroup(): Array<String> {
        // 需要先登录login
        let groupName = "Group" + Random().nextUInt64().toString()
        let reqData = JsonObject()
        reqData.put("name", JsonString(groupName))
        let members = JsonArray()
        members.add(JsonString("xiaozhou"))
        reqData.put("members", members)
        reqData.put("readOnly", JsonBool(false))
        let customFields = JsonObject()
        customFields.put("aaa", JsonString("bbb"))
        reqData.put("customFields", customFields)
        let res = restAPI.groupCreate(reqData.toString())
        let resJson = JsonValue.fromStr(res).asObject()
        let success = (JsonValue.fromStr(res).asObject().get("success").getOrThrow() as JsonBool).getOrThrow().getValue()
        if (success) {
            let bodyObj = (resJson.get("body").getOrThrow() as JsonObject).getOrThrow()
            let data = (bodyObj.get("group").getOrThrow() as JsonObject).getOrThrow()
            let groupID = (data.get("_id").getOrThrow() as JsonString).getOrThrow().getValue()
            let roomName = (data.get("fname").getOrThrow() as JsonString).getOrThrow().getValue()
            Hilog.info(0, "RestAPI", "createTestGroup groupID:${groupID}  roomName:${roomName} ")
            return [groupID, roomName]
        }
        return []
    }

    // 根据用户名查询用户ID
    func getUserIdByUsername(username: String): String {
        let regexObj = JsonObject()
        regexObj.put("$regex", JsonString(username))
        let query = JsonObject()
        query.put("username", regexObj)
        let res1 = restAPI.usersList(query.toString(), "", "", 1, 0)
        let resJson1 = JsonValue.fromStr(res1).asObject()
        let success1 = (resJson1.get("success").getOrThrow() as JsonBool).getOrThrow().getValue()
        if (success1) {
            let resJson = JsonValue.fromStr(res1).asObject()
            let bodyObj = (resJson.get("body").getOrThrow() as JsonObject).getOrThrow()
            if (let Some(users) <- bodyObj.get("users")) {
                if ((users as JsonArray).getOrThrow().size() > 0) {
                    let userId = (((users as JsonArray).getOrThrow().get(0).getOrThrow() as JsonObject).getOrThrow()
                        .get("_id").getOrThrow() as JsonString).getOrThrow().getValue()
                    return userId
                }
            }
        }
        return ""
    }
}
