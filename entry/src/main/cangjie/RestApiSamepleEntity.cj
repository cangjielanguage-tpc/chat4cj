/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import serialization.serialization.*
import encoding.json.*
import ohos.hilog.Hilog

public class PageData <: Serializable<PageData> {
    var token: String = ""
    var rid: String = ""
    var pageInfo: PageInfo = PageInfo()

    init(token: String, rid: String, pageInfo: PageInfo) {
        this.token = token
        this.rid = rid
        this.pageInfo = pageInfo
    }

    public func setPageInfo(pageInfo: PageInfo) {
        this.pageInfo = pageInfo
    }

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("token", token))
            .add(field<String>("rid", rid))
            .add(field<PageInfo>("pageInfo", pageInfo))
    }

    public static func deserialize(dm: DataModel): PageData {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        return PageData(String.deserialize(dms.get("token")), String.deserialize(dms.get("rid")),
            PageInfo.deserialize(dms.get("pageInfo")))
    }
}

public class PageInfo <: Serializable<PageInfo> {
    var change: String = "";
    var title: String = "";
    var location: Location = Location()

    init() {
    }

    init(change: String, title: String, location: Location) {
        this.change = change
        this.title = title
        this.location = location
    }

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("change", change))
            .add(field<String>("title", title))
            .add(field<Location>("location", location))
    }

    public static func deserialize(dm: DataModel): PageInfo {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        return PageInfo(String.deserialize(dms.get("change")), String.deserialize(dms.get("title")),
            Location.deserialize(dms.get("location")))
    }
}

public class Location <: Serializable<Location> {
    var href: String = ""

    init() {
    }

    init(href: String) {
        this.href = href
    }

    public func serialize(): DataModel {
        return DataModelStruct().add(field<String>("href", href))
    }

    public static func deserialize(dm: DataModel): Location {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        return Location(String.deserialize(dms.get("change")))
    }
}

public class VisitorInfo <: Serializable<VisitorInfo> {
    var visitor: Visitor = Visitor()

    init() {
    }

    public VisitorInfo(visitor: Visitor) {}

    public func setVisitor(visitor: Visitor) {
        this.visitor = visitor
    }

    public func serialize(): DataModel {
        return DataModelStruct().add(field<Visitor>("visitor", visitor))
    }

    public static func deserialize(dm: DataModel): VisitorInfo {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        return VisitorInfo(Visitor.deserialize(dms.get("visitor")))
    }
}

public class Visitor <: Serializable<Visitor> {
    var name: String = "";
    var email: String = "";
    var token: String = "";
    var phone: String = "";
    var customFields: Array<CustomFields> = []

    init() {
    }

    init(name: String, email: String, token: String, phone: String, customFields: Array<CustomFields>) {
        this.name = name
        this.email = email
        this.token = token
        this.phone = phone
        this.customFields = customFields
    }

    public func setCustomFields(customFields: Array<CustomFields>) {
        this.customFields = customFields
    }

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("name", name))
            .add(field<String>("email", email))
            .add(field<String>("token", token))
            .add(field<String>("phone", phone))
            .add(field<Array<CustomFields>>("customFields", customFields))
    }

    public static func deserialize(dm: DataModel): Visitor {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        return Visitor(String.deserialize(dms.get("name")), String.deserialize(dms.get("email")),
            String.deserialize(dms.get("token")), String.deserialize(dms.get("phone")),
            Array<CustomFields>.deserialize(dms.get("customFields")))
    }
}

public class CustomFields <: Serializable<CustomFields> {
    var key: String = "";
    var value: String = "";
    var overwrite: Bool = true

    init() {}

    public init(key: String, value: String, overwrite: Bool) {
        this.key = key
        this.value = value
        this.overwrite = overwrite
    }

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("key", key))
            .add(field<String>("value", value))
            .add(field<Bool>("overwrite", overwrite))
    }

    public static func deserialize(dm: DataModel): CustomFields {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        return CustomFields(String.deserialize(dms.get("key")), String.deserialize(dms.get("value")),
            Bool.deserialize(dms.get("overwrite")))
    }
}

public class OptionalParams <: Serializable<OptionalParams> {
    var latest: String = "";
    var oldest: String = "";
    var inclusive: Bool = false;
    var offset: Int64 = 0;
    var count: Int64 = 0;
    var unreads: Bool = false;
    public OptionalParams(latest: String, oldest: String, inclusive: Bool, offset: Int64, count: Int64, unreads: Bool) {}

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("latest", latest))
            .add(field<String>("oldest", oldest))
            .add(field<Bool>("inclusive", inclusive))
            .add(field<Int64>("offset", offset))
            .add(field<Int64>("count", count))
            .add(field<Bool>("unreads", unreads))
    }

    public static func deserialize(dm: DataModel): OptionalParams {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        return OptionalParams(String.deserialize(dms.get("latest")), String.deserialize(dms.get("oldest")),
            Bool.deserialize(dms.get("inclusive")), Int64.deserialize(dms.get("offset")),
            Int64.deserialize(dms.get("count")), Bool.deserialize(dms.get("unreads")))
    }
}

public class CustomField <: Serializable<CustomField> {
    var organization: String = ""
    public CustomField(organization: String) {
        this.organization = organization
    }

    public func serialize(): DataModel {
        return DataModelStruct().add(field<String>("organization", organization))
    }

    public static func deserialize(dm: DataModel): CustomField {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        return CustomField(String.deserialize(dms.get("organization")))
    }
}

public class PostMessageData <: Serializable<PostMessageData> {
    var channel: String = "";
    var emoji: String = "";
    var roomId: String = "";
    var text: String = "";
    var attachments: Array<Attachments> = []
    init(channel: String, emoji: String, roomId: String, text: String, attachments: Array<Attachments>) {
        this.channel = channel
        this.emoji = emoji
        this.roomId = roomId
        this.text = text
        this.attachments = attachments
    }
    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("channel", channel))
            .add(field<String>("emoji", emoji))
            .add(field<String>("roomId", roomId))
            .add(field<String>("text", text))
            .add(field<Array<Attachments>>("attachments", attachments))
    }
    public static func deserialize(dm: DataModel): PostMessageData {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = PostMessageData(String.deserialize(dms.get("channel")), String.deserialize(dms.get("emoji")),
            String.deserialize(dms.get("roomId")), String.deserialize(dms.get("text")),
            Array<Attachments>.deserialize(dms.get("attachments")))
        return result
    }
}

public class Attachments <: Serializable<Attachments> {
    var audio_url: String = "";
    var author_icon: String = "";
    var author_link: String = "";
    var author_name: String = "";
    var collapsed: Bool = false;
    var color: String = "#ffffff";
    var fields: Array<Fields> = [];
    var image_url: String = "";
    var message_link: String = "";
    var text: String = "";
    var thumb_url: String = "";
    var title: String = "";
    var title_link: String = "";
    var title_link_download: Bool = true;
    var ts: String = "";
    var video_url: String = ""

    init() {
    }

    init(audio_url: String, author_icon: String, author_link: String, author_name: String, collapsed: Bool,
        color: String, fields: Array<Fields>, image_url: String, message_link: String, text: String, thumb_url: String,
        title: String, title_link: String, title_link_download: Bool, ts: String, video_url: String) {
        this.audio_url = audio_url
        this.author_icon = author_icon
        this.author_link = author_link
        this.author_name = author_name
        this.collapsed = collapsed
        this.color = color
        this.fields = fields
        this.image_url = image_url
        this.message_link = message_link
        this.text = text
        this.thumb_url = thumb_url
        this.title = title
        this.title_link = title_link
        this.title_link_download = title_link_download
        this.ts = ts
        this.video_url = video_url
    }

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("audio_url", audio_url))
            .add(field<String>("author_icon", author_icon))
            .add(field<String>("author_link", author_link))
            .add(field<String>("author_name", author_name))
            .add(field<Bool>("collapsed", collapsed))
            .add(field<String>("color", color))
            .add(field<Array<Fields>>("fields", fields))
            .add(field<String>("image_url", image_url))
            .add(field<String>("message_link", message_link))
            .add(field<String>("text", text))
            .add(field<String>("thumb_url", thumb_url))
            .add(field<String>("title", title))
            .add(field<String>("title_link", title_link))
            .add(field<Bool>("title_link_download", title_link_download))
            .add(field<String>("ts", ts))
            .add(field<String>("video_url", video_url))
    }

    public static func deserialize(dm: DataModel): Attachments {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = Attachments()
        return result
    }
}

public class Fields <: Serializable<Fields> {
    var short: Bool = true;
    var title: String = "";
    var value: String = "";
    init() {
    }

    init(short: Bool, title: String, value: String) {
        this.short = short
        this.title = title
        this.value = value
    }

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<Bool>("short", short))
            .add(field<String>("title", title))
            .add(field<String>("value", value))
    }

    public static func deserialize(dm: DataModel): Fields {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = Fields(Bool.deserialize(dms.get("short")), String.deserialize(dms.get("title")),
            String.deserialize(dms.get("value")))
        return result
    }
}

public class Query {
    var active: Bool = false;
    var types: Array<String> = []
    init() {
    }
    Query(active: Bool, types: Array<String>) {}
}

public class OnClickUsersCreate <: Serializable<OnClickUsersCreate> {
    var name: String = "";
    var email: String = "";
    var password: String = "";
    var username: String = "";
    var active: Bool = true;
    var roles: Array<String> = [];
    var joinDefaultChannels: Bool = true;
    var requirePasswordChange: Bool = false;
    var sendWelcomeEmail: Bool = false;
    var verified: Bool = false;

    public init() {
    }
    public init(name: String, email: String, password: String, username: String, active: Bool, roles: Array<String>,
        joinDefaultChannels: Bool, requirePasswordChange: Bool, sendWelcomeEmail: Bool, verified: Bool) {
        this.name = name
        this.email = email
        this.password = password
        this.username = username
        this.active = active
        this.roles = roles
        this.joinDefaultChannels = joinDefaultChannels
        this.requirePasswordChange = requirePasswordChange
        this.sendWelcomeEmail = sendWelcomeEmail
        this.verified = verified
    }

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("name", name))
            .add(field<String>("email", email))
            .add(field<String>("password", password))
            .add(field<String>("username", username))
            .add(field<Bool>("active", active))
            .add(field<Array<String>>("roles", roles))
            .add(field<Bool>("joinDefaultChannels", joinDefaultChannels))
            .add(field<Bool>("requirePasswordChange", requirePasswordChange))
            .add(field<Bool>("sendWelcomeEmail", sendWelcomeEmail))
            .add(field<Bool>("verified", verified))
    }

    public static func deserialize(dm: DataModel): OnClickUsersCreate {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var result = OnClickUsersCreate()
        return result
    }
}
