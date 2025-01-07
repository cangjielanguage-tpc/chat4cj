/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package rocketlib

import std.sync.*
import std.regex.*
import std.collection.*
import httpclient4cj.*
import encoding.json.*
import net.http.*
import std.time.*

public struct Authdata {
    let authToken: String = ""
    let userId: String = ""
}
// 登录结果API接口定义
public struct LoginResultAPI {
    let status: String = ""
    let data: Authdata = Authdata()
}

// 登录凭证结构定义
public struct LoginCredentials {
    let username: String = ""
    let password: String = ""
}

private struct Currentlogin {
    let username: String = ""
    let userId: String = ""
    let authToken: String = ""
    let result: Option<LoginResultAPI> = Option<LoginResultAPI>.None
}

public class HttpRequestConnector {
    private var serverUrl: String
    private var authToken: String
    private var userID: String
    private var currentLogin: Option<Currentlogin> = Option<Currentlogin>.None
    private var headers: Header = Header()
    private var clientbuilder: HttpClientBuilder
    private let DEFAULT_TIMEOUT: Int = 60000
    private let DEFAULT_WRITE_TIMEOUT: Int = 100000

    // 构造函数
    public init(url: String) {
        this.serverUrl = url
        this.authToken = ""
        this.userID = ""
        this.clientbuilder = HttpClient.builder()
        this.headers.add("Content-Type", "application/json")
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
        
        let requestBuilder = Request
            .builder()
            .url(url)
            .header(this.headers)

        // 根据HTTP方法设置请求体
        match (method) {
            case "GET" => requestBuilder.get()
            case "POST" => requestBuilder.post(RealRequestBody.create(MediaType.get("application/json; charset=utf-8"), data))
            case "PUT" => requestBuilder.put(RealRequestBody.create(MediaType.get("application/json; charset=utf-8"), data))
            case "DELETE" => requestBuilder.delete(RealRequestBody.create(MediaType.get("application/json; charset=utf-8"), data))
            case _ => throw Exception("Unsupported HTTP method: ${method}")
        }

        let request = requestBuilder.build()
        // println("sending '${method} request to ${url} with body ${data}")
        // println("request is ${request.toString()}")
        let response = client.newCall(request).execute()
        

        let jsonData = JsonValue.fromStr(response.getBody().getOrThrow().getString())
        return handleResponse(jsonData)
    }

    // POST请求
    public func post(endpoint: String, data: String, auth!: Bool = true): JsonValue {
        return executeRequest(endpoint, "POST", data, auth:auth)
    }

    // GET请求
    public func get(endpoint: String, data: String, auth!: Bool = true): JsonValue {
        return executeRequest(endpoint, "GET", data, auth:auth)
    }

    // DELETE请求
    public func delete(endpoint: String, data: String, auth!: Bool = true): JsonValue {
        return executeRequest(endpoint, "DELETE", data, auth:auth)
    }

    // PUT请求
    public func put(endpoint: String, data: String, auth!: Bool = true): JsonValue {
        return executeRequest(endpoint, "PUT", data, auth:auth)
    }

    // 设置用户认证数据
    public func setUserData(authToken: String, userID: String): Unit {
        this.authToken = authToken
        this.userID = userID
        this.headers.add("Content-Type", "application/json")
        this.headers.add("X-Auth-Token", this.authToken)
        this.headers.add("X-User-Id", this.userID)
    }

    // 检查登录状态
    public func loggedIn(): Bool {
        return this.currentLogin.isSome()
    }

    // 处理API响应的通用函数
    private func handleResponse(response: JsonValue): JsonValue {
        let jsonData = response.asObject()

        // Check if response contains success field
        if (jsonData.get("success").isSome()) {
            let success = (jsonData.get("success").getOrThrow() as JsonBool).getOrThrow()
            if (!success.getValue()) {
                // Get error message if available
                if (jsonData.get("error").isSome()) {
                    let error = (jsonData.get("error").getOrThrow() as JsonString).getOrThrow()
                    return JsonString(error.getValue())
                }
                return JsonString("Unknown error occurred")
            }
        }
        
        return response
    }
}
