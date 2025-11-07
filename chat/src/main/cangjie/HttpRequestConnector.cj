/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package chat

import std.sync.*
import std.regex.*
import std.collection.*
import httpclient4cj.*
import encoding.json.*
import net.http.*
import std.time.*

public class HttpRequestConnector {
    private var serverUrl: String
    private var authToken: String
    private var userID: String
    private var headers: Header = Header()
    private var clientbuilder: HttpClientBuilder
    private let DEFAULT_TIMEOUT: Int = 60000
    private let DEFAULT_WRITE_TIMEOUT: Int = 1000000

    // 构造函数
    public init(url: String) {
        this.serverUrl = url
        this.authToken = ""
        this.userID = ""
        this.clientbuilder = HttpClient.builder()
        this.headers.add("Content-Type", "application/json")
        this.headers.add("X-Auth-Token", "")
        this.headers.add("X-User-Id", "")
    }

    // 创建HTTP客户端
    private func createHttpClient(): HttpClient {
        return HttpClient
            .builder()
            .connectTimeout(Duration.millisecond * DEFAULT_TIMEOUT)
            .readTimeout(Duration.millisecond * DEFAULT_TIMEOUT)
            .writeTimeout(Duration.millisecond * DEFAULT_WRITE_TIMEOUT)
            .build()
    }

    // 执行HTTP请求的通用方法
    private func executeRequest(endpoint: String, method: String, data: String, auth!: Bool = true): JsonValue {
        let url = this.serverUrl + endpoint
        let client = createHttpClient()
        let requestBuilder = Request.builder().url(url).header(this.headers)
        // 根据HTTP方法设置请求体
        match (method) {
            case "GET" => requestBuilder.get()
            case "POST" => requestBuilder.post(
                RealRequestBody.create(MediaType.get("application/json; charset=utf-8"), data))
            case "PUT" => requestBuilder.put(
                RealRequestBody.create(MediaType.get("application/json; charset=utf-8"), data))
            case "DELETE" => requestBuilder.delete(
                RealRequestBody.create(MediaType.get("application/json; charset=utf-8"), data))
            case _ => throw Exception("Unsupported HTTP method: ${method}")
        }
        let request = requestBuilder.build()
        try {
            let response = client.newCall(request).execute()
            let jsonData = JsonValue.fromStr(response.getBody().getOrThrow().getString())
            // 构造返回数据
            let responseData = JsonObject()
            let success = response.isSuccess()
            responseData.put("success", JsonBool(success))
            responseData.put("code", JsonInt(response.getCode()))
            if (success) {
                responseData.put("body", jsonData)
            } else {
                if (jsonData.asObject().get("message").isSome()) {
                    responseData.put("errmsg", jsonData.asObject().get("message").getOrThrow())
                } else if (jsonData.asObject().get("error").isSome()) {
                    responseData.put("errmsg", jsonData.asObject().get("error").getOrThrow())
                } else {
                    responseData.put("errmsg", JsonString("unknown"))
                }
            }
            return responseData
        } catch (e: Exception) {
            let response = JsonObject()
            response.put("success", JsonBool(false))
            response.put("code", JsonInt(0))
            response.put("errmsg", JsonString(e.message))
            return response
        }
    }

    // POST请求
    public func post(endpoint: String, data: String, auth!: Bool = true): JsonValue {
        return executeRequest(endpoint, "POST", data, auth: auth)
    }

    // GET请求
    public func get(endpoint: String, data: String, auth!: Bool = true): JsonValue {
        return executeRequest(endpoint, "GET", data, auth: auth)
    }

    // DELETE请求
    public func delete(endpoint: String, data: String, auth!: Bool = true): JsonValue {
        return executeRequest(endpoint, "DELETE", data, auth: auth)
    }

    // PUT请求
    public func put(endpoint: String, data: String, auth!: Bool = true): JsonValue {
        return executeRequest(endpoint, "PUT", data, auth: auth)
    }

    // 设置用户认证数据
    public func setUserData(authToken: String, userID: String): Unit {
        var token: ArrayList<String> = ArrayList<String>(1)
        var id: ArrayList<String> = ArrayList<String>(1)
        token.append(authToken)
        this.headers.set("X-Auth-Token", token)
        id.append(userID)
        this.headers.set("X-User-Id", id)
    }
}
