package rocketChat4cj
import encoding.json.*
import std.collection.*
main() {
    let token = "vU_ip7uGU6bOe_yzns020L00t6xggU5BKcXDLNTzNRO"

    let str_pageData:String  = ##"
{
  "token": "iNKE8a6k6cjbqWhWd",
  "rid": "vp3D9H8ud6HYvRpvq",
  "pageInfo": {
    "change": "url",
    "title": "",
    "location": {
      "href": "http://localhost:3000/packages/rocketchat_livechat/assets/demo.html#page-4"
    }
  }
}"##

    let str_visitor:String  = ##"
{
  "visitor": {
    "name": "Livechat Visitor",
    "email": "visitor@rocket.chat",
    "department": "Livechat Visitor",
    "token": "iNKE8a6k6cjbqWhWd",
    "phone": "55 51 5555-5555",
    "customFields": [
      {
        "key": "address",
        "value": "Rocket.Chat street",
        "overwrite": true
      }
    ]
  }
}"##


    let str_visitor_status:String  = ##"
{
  "token": "iNKE8a6k6cjbqWhWd",
  "status": "busy"
}"##


    let str_Channel_data:String  = ##"{
  "name": "channelnameaaaa",
  "members": [
    "rocket.cat"
  ],
  "readOnly": true,
  "excludeSelf": true,
  "customFields": {
    "type": "default"
  },
  "extraData": {
    "broadcast": true,
    "encrypted": false,
    "teamId": ""
  }
}"##

    let groupCreate_data:String  = ##"
{
  "name": "groupname",
  "members": [
    "rocket.cat"
  ],
  "readOnly": true,
  "excludeSelf": true,
  "customFields": {
    "type": "default"
  },
  "extraData": {
    "broadcast": true,
    "encrypted": false,
    "teamId": "658441562dd9f928ad9951aa"
  }
}"##

    let api = RestAPI("http://localhost:8888/api/v1/","yxh","123456789")
    println("ret = ${api.login()}")
    // println("ret = ${api.loginWithAuthToken("7X4blSVuAo39rqL7LCoLUo1k6u1s36G27xdHvFG4_Vq")}")
    // println("ret = ${api.pageVisited(str_pageData)}")
    // println("ret = ${api.visitorRegistration(str_visitor)}")
    // println("ret = ${api.visitor("iNKE8a6k6cjbqWhWd")}")
    // println("ret = ${api.setVisitorStatus(str_visitor_status)}")
    // println("ret = ${api.visitorDelete("iNKE8a6k6cjbqWhWd")}")
    // println("ret = ${api.bannersEndPoint(111)}")
    // println("ret = ${api.getBanners()}")
    println("ret = ${api.createChannel(str_Channel_data)}")
    // println("ret = ${api.addAllChannel("6748145404ef477e6268331f",true)}")
    // println("ret = ${api.addLeaderChannel("6748145404ef477e6268331f","4DKgtWH2Zg5urJzmA")}")
    // println("ret = ${api.messageChannel("6748145404ef477e6268331f","4DKgtWH2Zg5urJzmA")}")
    // println("ret = ${api.groupCreate(groupCreate_data)}")
    
    

}