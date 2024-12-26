/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.prompt_action.PromptAction
import std.math.*
import std.core.*
import ohos.prompt_action.*
import ohos.resource_manager.*
import encoding.json.*
import cj_res_entry.app
import std.time.*
import rocketlib.*


var restAPI:RestAPI = RestAPI("", "", "");

var authToken:String = "";
var rid:String = "";
var userId:String = "";
var channelId:String = "";
var roomName:String = "";
var groupID:String = "";
var messageId:String = "";
var user_id:String = "";
var channelName:String = "";
var otherUserId:String = "LnxXdiShd3WTLovPa"; // Create a new user or get list of user, put the desired user id.
class OnClickUserDeleteData{
  var userId  : String = "";
  var username  : String = "";
  var confirmRelinquish  : Bool = false
}

class OnClickUsersPresenceData{
    public OnClickUsersPresenceData(userId: String, userName: String) {}
}

@Entry
@Component
class RestApiSample {
  var scroller: Scroller = Scroller();
  @State var email: String = "";
  @State var userPassword: String = "";
  @State var userName: String = "";
  @State var presenceUserId: String = "";
  @State var createUserName: String = "";
  @State var createUserPreferredName: String = "";
  @State var createUserEmail: String = "";
  @State var createUserPassword: String = "";
  @State var visitorName: String = "";
  @State var visitorEmail: String = "";
  @State var visitorToken: String = "";
  @State var visitorPhone: String = "";
  @State var visitorAddress: String = "";
  @State var channelName: String = "";
  @State var groupName: String = "";

  func build() {
    Stack(Alignment.TopStart) {
      Scroll(this.scroller) {
        Flex(FlexParams(wrap: FlexWrap.Wrap)) {

          TextInput(placeholder: 'Username')
            .setType(InputType.Normal)
            .placeholderColor(Color.BLUE)
            .placeholderFont(size: 40, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal )
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.BLUE)
            .width(90.percent)
            .height(60)
            .maxLength(20)
            .margin(5)
            .onChange({ value: String =>
              this.email = value
            })

          TextInput(placeholder: 'Password')
            .setType(InputType.Password)
            .placeholderColor(Color.BLUE)
            .placeholderFont(size: 40, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal )
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.GREEN)
            .width(90.percent)
            .height(60)
            .maxLength(20)
            .margin(5)
            .onChange({ value: String =>
              this.userPassword = value
            })

          Column() {
            Text("Login!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickLogin();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("LoginWithAuthToken!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickLoginWithAuthToken();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Me!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickMe();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Users List!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickUsersList();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("User's Info!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickUsersInfo();
              })
          }.margin(5).align(Alignment.Center);


          TextInput(placeholder: 'Username' )
            .setType(InputType.Normal)
            .placeholderColor(Color.BLUE)
            .placeholderFont(size: 40, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal )
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.GREEN)
            .width(90.percent)
            .height(60)
            .maxLength(20)
            .margin(5)
            .onChange({ value: String =>
              this.userName = value
            })

          TextInput(placeholder: 'User Id' )
            .setType(InputType.Normal)
            .placeholderColor(Color.BLUE)
            .placeholderFont(size: 40, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal )
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.GREEN)
            .width(90.percent)
            .height(60)
            .maxLength(20)
            .margin(5)
            .onChange({ value: String =>
              this.presenceUserId = value
            })

          Column() {
            Text("User's Presence!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickUsersPresence();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("User Set Avatar!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickUserSetAvatar();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Settings!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickSettings();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Page Visited!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickPageVisited();
              })
          }.margin(5).align(Alignment.Center);


          TextInput( placeholder: 'Visitor Name' )
            .setType(InputType.Normal)
            .placeholderColor(Color.BLUE)
            .placeholderFont( size: 40, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal )
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.GREEN)
            .width(90.percent)
            .height(60)
            .maxLength(20)
            .margin(5)
            .inputFilter(value: '^[a-zA-Z0-9]+$', error: { info: String =>
                this.showToast(ResourceManager.getResourceManager(MainAbility().getStageContext()).getString(Int32(@r(app.string.only_numbers_and_English).id)))
            })
            .onChange({ value: String =>
              this.visitorName = value
            })

          TextInput( placeholder: 'Visitor Email(optional)' )
            .setType(InputType.Normal)
            .placeholderColor(Color.BLUE)
            .placeholderFont( size: 30, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal )
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.GREEN)
            .width(90.percent)
            .height(60)
            .maxLength(20)
            .margin(5)
            .onChange({ value: String =>
              this.visitorEmail = value
            })

          TextInput( placeholder: 'Visitor Token(optional)' )
            .setType(InputType.Normal)
            .placeholderColor(Color.BLUE)
            .placeholderFont( size: 30, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal )
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.GREEN)
            .width(90.percent)
            .height(60)
            .maxLength(20)
            .margin(5)
            .onChange({ value: String =>
              this.visitorToken = value
            })

          TextInput(placeholder: 'Phone(optional)' )
            .setType(InputType.Number)
            .placeholderColor(Color.BLUE)
            .placeholderFont(size: 30, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal)
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.GREEN)
            .width(90.percent)
            .height(60)
            .maxLength(20)
            .margin(5)
            .onChange({ value: String =>
              this.visitorPhone = value
            })


          TextInput(placeholder: 'Address(optional)' )
            .setType(InputType.Normal)
            .placeholderColor(Color.BLUE)
            .placeholderFont(size: 30, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal)
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.GREEN)
            .width(90.percent)
            .height(60)
            .maxLength(20)
            .margin(5)
            .onChange({ value: String =>
              this.visitorAddress = value
            })

          Column() {
            Text("Visitor Registration!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickVisitorRegistration();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Retrieve Visitor!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickRetrieveVisitor();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Set Visitor Status!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickSetVisitorStatus();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Visitor Delete!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickVisitorDelete();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Banners End Point!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickBannersEndPoint();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Get Banners!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGetBanners();
              })
          }.margin(5).align(Alignment.Center);


          TextInput(placeholder: 'Channel Name')
            .setType(InputType.Normal)
            .placeholderColor(Color.BLUE)
            .placeholderFont(size: 40, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal)
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.GREEN)
            .width(90.percent)
            .height(60)
            .maxLength(20)
            .margin(5)
            .inputFilter(value: '^[a-zA-Z0-9]+$', error: { info: String =>
                this.showToast(ResourceManager.getResourceManager(MainAbility().getStageContext()).getString(Int32(@r(app.string.only_numbers_and_English).id)))
            })
            .onChange({ value: String =>
              this.channelName = value
            })

          Column() {
            Text("Create Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickCreateChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Channel Post Message!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickPostMessageChat();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Channel Update Message!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickUpdateMessageChat();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Channel Delete Message!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickDeleteMessageChat();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Invite Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickInviteChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Add Leader Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickAddLeaderChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Remove Leader Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickRemoveLeaderChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Add Moderator Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickAddModeratorChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Remove Moderator Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickRemoveModeratorChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Add Owner Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickAddOwnerChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Remove Owner Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickRemoveOwnerChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Set Channel Purpose!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickSetPurposeChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Set Read Only Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickSetReadOnlyChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Archive Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickArchiveChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("UnArchive Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickUnArchiveChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Counter Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickCounterChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Files Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickFilesChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Get History Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickHistoryChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Info Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickInfoChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Join Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickJoinChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Kick Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickKickChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("List Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickListChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Join List Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickJoinListChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Members Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickMembersChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Online Channel Users!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickOnlineChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("User All Mention By Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGetUserAllMentionByChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Rename Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickRenameChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Roles Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickRolesChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Set Announcement Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickSetAnnouncementChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Set Join Code Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickSetJoinCodeChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Set Channel Topic!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickSetTopicChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Close Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickCloseChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Open Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickOpenChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Get Integrations Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGetIntegrationsChannel();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Set Default Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickSetDefaultChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Leave Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickLeaveChannel();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Delete Channel!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickDeleteChannel();
              })
          }.margin(5).align(Alignment.Center);

          TextInput( placeholder: 'Group Name' )
            .setType(InputType.Normal)
            .placeholderColor(Color.BLUE)
            .placeholderFont(size: 40, weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal)
            .enterKeyType(EnterKeyType.Next)
            .caretColor(Color.GREEN)
            .width(90.percent)
            .height(60)
            .maxLength(20)
            .margin(5)
            .inputFilter(value: '^[a-zA-Z0-9]+$', error: { info: String =>
                this.showToast(ResourceManager.getResourceManager(MainAbility().getStageContext()).getString(Int32(@r(app.string.only_numbers_and_English).id)))
            })
            .onChange({ value: String =>
              this.groupName = value
            })

          Column() {
            Text("Create a Group!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupCreate();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group Add All!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupAddAll();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group Invite!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupInvite();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group Add Moderator!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupAddModerator();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Group Remove Moderator!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupRemoveModerator();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Add Owner!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupAddOwner();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group Remove Owner!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupRemoveOwner();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group Info!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupInfo();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group List!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupList();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Set Description!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickSetDescription();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group History!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupHistory();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Set Purpose!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickSetPurpose();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Set Topic!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickSetTopic();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Group Close!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupClose();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group Open!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupOpen();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group Rename!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupRename();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group Kick!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupKick();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group Archive!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupArchive();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group Integrations!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupIntegrations();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group UnArchive!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupUnArchive();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group Leave!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupLeave();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Group Set ReadOnly!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickSetReadOnly();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Group Add Leader!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupAddLeader();
              })
          }.margin(5).align(Alignment.Center);


          Column() {
            Text("Delete Group!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickGroupDelete();
              })
          }.margin(5).align(Alignment.Center);

          Column() {
            Text("Logout!!")
              .width(90.percent)
              .height(40)
              .backgroundColor(0x5733FF)
              .textAlign(TextAlign.Center)
              .fontColor(Color.WHITE)
              .fontSize(22.vp)
              .onClick({ evt =>
                this.onClickLogout();
              })
          }.margin(5).align(Alignment.Center);

        }
      }
    }
  }

  func onClickLogin() {
    let that = this;
    restAPI = RestAPI("https://open.rocket.chat/api/v1/", this.email, this.userPassword);
    try {
        let res = restAPI.login();
        AppLog.info("onClickLogin data:" + res);
        let data = JsonValue.fromStr(res).asObject()
        authToken = (data.get("authToken").getOrThrow() as JsonString).getOrThrow().toJsonString()
        userId = (data.get("userId").getOrThrow() as JsonString).getOrThrow().toJsonString()
        AppLog.info("authToken data:" + authToken);
        AppLog.info("authToken userId:" + userId);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("onClickLogin error:" + e.message);
            // open.rocket.chat fail
    }
  }

 func onClickLoginWithAuthToken() {
    let that = this;
    try {
        let res = restAPI.loginWithAuthToken(authToken)
        AppLog.info("onClickLogin data:" + res);
        let data = JsonValue.fromStr(res).asObject()
        authToken = (data.get("authToken").getOrThrow() as JsonString).getOrThrow().toJsonString()
        userId = (data.get("userId").getOrThrow() as JsonString).getOrThrow().toJsonString()
        AppLog.info("authToken data:" + authToken);
        AppLog.info("authToken userId:" + userId);
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("onClickLogin error:" + e.message);
    }
  }

  func onClickMe() {
    let that = this;
    try {
         restAPI.me()
         that.showToast("Success")
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
    }
}


  func onClickUsersList() {
    let that = this;
     try {
        let res = restAPI.usersList("user", "name,emails", "name", 1, 1)
        AppLog.info("usersList:" + res)
        that.showToast("Success");
    } catch (e: Exception) {
       that.showToast("Error :" + e.message);
       AppLog.info("usersList:" +  e.message);
    }
  }

  func onClickUsersCreate() {
    let that = this;
    let data:OnClickUsersCreate = OnClickUsersCreate(that.createUserName, that.createUserEmail, that.createUserPassword, that.createUserPreferredName, true,
            ["user"],  true, false, false, false)
     try {
        let res: String = restAPI.userCreate(data.serialize().toJson().asObject().toJsonString())
        AppLog.info("userCreate:" + res);
        let json_data = JsonValue.fromStr(res).asObject()
        let data = (json_data.get("user").getOrThrow() as JsonObject).getOrThrow()
        userId = (data.get("_id").getOrThrow() as JsonString).getOrThrow().toJsonString()
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("userCreate:" +  e.message);
    }
  }

  func onClickPageVisited() {
    let that = this;
    //Add room id from realtime api or after creating channel
    let pageInfo:PageInfo = PageInfo("url", "", Location("https://open.rocket.chat/packages/rocketchat_livechat/assets/demo.html#page-4"))
    let pageData:PageData = PageData(authToken, "4Eyfj2XLKiRDboAjE", pageInfo)

    try {
        let data = restAPI.pageVisited(pageData.serialize().toJson().asObject().toJsonString())
        AppLog.info("pageData data:" + data);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("pageData error:" +  e.message);
    }
  }

  func onClickVisitorRegistration() {
    let that = this;
    let resourceManager = ResourceManager.getResourceManager(MainAbility().getStageContext())
    //Add a user defined token
    if(that.visitorName.isEmpty()) {
      this.showToast(resourceManager.getString(Int32(@r(app.string.visitor_name_cannot_empty).id)))
    } else {

      if(!that.visitorPhone.isEmpty() && ( that.visitorPhone.size != 11 || !that.visitorPhone.contains("1"))) {
        this.showToast(resourceManager.getString(Int32(@r(app.string.enter_correct_phone_number).id)))
      } else {
        if(!that.visitorEmail.isEmpty() && !that.visitorEmail.contains("@")) {
          this.showToast(resourceManager.getString(Int32(@r(app.string.enter_correct_email).id)))
        } else{
          let visitor = Visitor(this.visitorName, this.visitorEmail, this.visitorToken, this.visitorPhone, [CustomFields("address", that.visitorAddress, true)])
          let visitorInfo:VisitorInfo = VisitorInfo()
          visitorInfo.setVisitor(visitor)

            try {
                let data = restAPI.visitorRegistration(visitorInfo.serialize().toJson().asObject().toJsonString())
                AppLog.info("visitorRegistration data:" + data);
                that.showToast("Success");
            } catch (e: Exception) {
                that.showToast("Error :" + e.message);
                AppLog.info("visitorRegistration error:" +  e.message);
            }
        }
      }
    }
  }

  func onClickRetrieveVisitor() {
    let that = this;
    try {
        let data = restAPI.visitor(that.visitorToken)
        AppLog.info("visitor data:" + data);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("visitor error:" +  e.message);
    }
  }

  func onClickSetVisitorStatus() {
    let that = this;
    let visitorStatus = "{ \"token\": "+ that.visitorToken +",  \"status\": \"busy\" }"

    try {
        let data = restAPI.setVisitorStatus(visitorStatus)
        AppLog.info("visitorStatus data:" + data);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("visitorStatus error:" +  e.message);
    }
  }

  func onClickVisitorDelete() {
    let that = this;
    try {
        let data = restAPI.visitorDelete(that.visitorToken)
        AppLog.info("visitorDelete data:" + data);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("visitorDelete error:" +  e.message);
    }
  }

  func onClickBannersEndPoint() {
    let that = this;
    //Banner id if not available can pass null, as get bannerId or create banner id not available in api list
    try {
        let data = restAPI.bannersEndPoint(0)
        AppLog.info("bannersEndPoint data:" + data);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("bannersEndPoint error:" +  e.message);
    }
  }

  func onClickGetBanners() {
    let that = this;
    try {
        let data = restAPI.getBanners()
        AppLog.info("getBanners data:" + data);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("getBanners error:" +  e.message);
    }
  }

  func onClickCreateChannel() {
    let that = this;
    if(that.channelName.isEmpty()) {
        this.showToast(ResourceManager.getResourceManager(MainAbility().getStageContext()).getString(Int32(@r(app.string.channel_name_cannot_be_empty).id)))
    } else {
        try {
            let reqData = "{ \"name\": "+ that.channelName +", \"members\": ['userName1', 'userName2'], \"readOnly\": true }"
            let data = restAPI.createChannel(reqData)
            AppLog.info("createChannel data:" + data);
            that.showToast("Success");
        } catch (e: Exception) {
            that.showToast("Error :" + e.message);
            AppLog.info("createChannel error:" +  e.message);
        }
    }
  }

  func onClickAddAllChannel() {
    let that = this;
    let roomID = channelId;
    let activeUsersOnly = true;
    try {
        let data = restAPI.addAllChannel(channelId, activeUsersOnly)
        AppLog.info("AddAllChannel data:" + data);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("AddAllChannel error:" +  e.message);
    }
  }

  func onClickInviteChannel() {
    let that = this;
    //Add a userid of another user
    try {
        let res = restAPI.inviteChannel(channelId, otherUserId)
        AppLog.info("inviteChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("inviteChannel error:" +  e.message);
    }
  }

  func onClickAddLeaderChannel() {
    let that = this;
    try {
        let res = restAPI.addLeaderChannel(channelId, userId)
        AppLog.info("addLeaderChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("addLeaderChannel error:" +  e.message);
    }
  }

  func onClickAddModeratorChannel() {
    let that = this;
    try {
        let res = restAPI.addModeratorChannel(channelId, userId)
        AppLog.info("addModeratorChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("addModeratorChannel error:" +  e.message);
    }
  }

  func onClickAddOwnerChannel() {
    let that = this;
    try {
        let res = restAPI.addOwnerChannel(channelId, otherUserId)
        AppLog.info("addOwnerChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("addOwnerChannel error:" +  e.message);
    }
  }

  func onClickCounterChannel() {
    let that = this;
    let roomId = "snLhQqKN6NXLEfEey";
    let roomName = "TestRoomName"; //Pass an existing room name
    try {
        let res = restAPI.counterChannel(roomId)
        AppLog.info("counterChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("counterChannel error:" +  e.message);
    }
  }

  func onClickGetUserAllMentionByChannel() {
    let that = this;
    try {
        let res = restAPI.getUserAllMentionByChannel(channelId)
        AppLog.info("onClickGetUserAllMentionByChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("onClickGetUserAllMentionByChannel error:" +  e.message);
    }
  }

  func onClickFilesChannel() {
    let that = this;
    try {
        let res = restAPI.filesChannel(channelId, roomName)
        AppLog.info("filesChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("filesChannel error:" +  e.message);
    }
  }

  func onClickHistoryChannel() {
    let that = this;
    let inclusive = true;
    let offset = 2;
    let count = 100;
    let unreads = true;
    let latest = DateTime.nowUTC()

    let oldest = DateTime.ofUTC(year: 2022, month: 3, dayOfMonth: 29)

    let optionalParams:OptionalParams= OptionalParams(latest.toString(), oldest.toString(), inclusive, offset, count, unreads)
    try {
        let res = restAPI.historyChannel(channelId, JsonValue.fromStr(optionalParams.serialize().toJson().asObject().toJsonString()))
        AppLog.info("historyChannel data:" + res)
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("historyChannel error:" +  e.message);
    }
  }

  func onClickInfoChannel() {
    let that = this;
    let roomOptionalId = "";
    try {
        let res = restAPI.infoChannel(roomOptionalId, roomName)
        AppLog.info("infoChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("infoChannel error:" +  e.message);
    }
  }

  func onClickJoinChannel() {
    let that = this;
    let joinCode = "Rocket";
    try {
        let res = restAPI.joinChannel(channelId, joinCode)
        AppLog.info("joinChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("joinChannel error:" +  e.message);
    }
  }

  func onClickKickChannel() {
    let that = this;
    try {
        let res = restAPI.kickChannel(channelId, userId)
        AppLog.info("kickChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("kickChannel error:" +  e.message);
    }
  }

  func onClickLeaveChannel() {
    let that = this;
    try {
        let res = restAPI.leaveChannel(channelId)
        AppLog.info("leaveChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("leaveChannel error:" +  e.message);
    }
  }

  func onClickListChannel() {
    let that = this;
    try {
        let res = restAPI.listChannel()
        AppLog.info("listChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("listChannel error:" +  e.message);
    }
  }

  func onClickJoinListChannel() {
    let that = this;
    try {
        let res = restAPI.joinListChannel()
        AppLog.info("joinListChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("joinListChannel error:" +  e.message);
    }
  }

  func onClickMembersChannel() {
    let that = this;
    let roomOptionalId = "";
    try {
        let res = restAPI.membersChannel(roomOptionalId, roomName)
        AppLog.info("membersChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("membersChannel error:" +  e.message);
    }
  }

  func onClickMessageChannel() {
    let that = this;
    try {
        let res = restAPI.messageChannel(channelId, roomName)
        AppLog.info("messageChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("messageChannel error:" +  e.message);
    }
  }

  func onClickOnlineChannel() {
    let that = this;
    try {
        let res = restAPI.onlineChannel(channelId)
        AppLog.info("onlineChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("onlineChannel error:" +  e.message);
    }
  }

  func onClickRenameChannel() {
    let that = this;
    let name = "RenamedChannel2";
    try {
        let res = restAPI.renameChannel(channelId, name)
        AppLog.info("renameChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("renameChannel error:" +  e.message);
    }
  }

  func onClickRolesChannel() {
    let that = this;
    try {
        let res = restAPI.rolesChannel(channelId, roomName)
        AppLog.info("rolesChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("rolesChannel error:" +  e.message);
    }
  }

  func onClickSetAnnouncementChannel() {
    let that = this;
    let announcement = "hello";
    try {
        let res = restAPI.setAnnouncementChannel(channelId, announcement)
        AppLog.info("setAnnouncementChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("setAnnouncementChannel error:" +  e.message);
    }
  }

  func onClickSetCustomFieldsChannel() {
    let that = this;
    let customField:CustomField = CustomField("tra-la-la");
    // channelId can be replaced as first parameter instead of undefined in below api call
    try {
        let res = restAPI.setCustomFieldsChannel("", roomName, customField.serialize().toJson().asObject())
        AppLog.info("setCustomFieldsChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("setCustomFieldsChannel error:" +  e.message);
    }
  }

  func onClickSetJoinCodeChannel() {
    let that = this;
    let joinCode = "test";
    try {
        let res = restAPI.setJoinCodeChannel(channelId, joinCode)
        AppLog.info("setJoinCodeChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("setJoinCodeChannel error:" +  e.message);
    }
  }

  func onClickSetPurposeChannel() {
    let that = this;
    let purpose = "test";
    try {
        let res = restAPI.setPurposeChannel(channelId, purpose)
        AppLog.info("setPurposeChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("setPurposeChannel error:" +  e.message);
    }
  }

 func onClickSetTopicChannel() {
    let that = this;
    let topic = "Test";
    try {
        let res = restAPI.setTopicChannel(channelId, topic)
        AppLog.info("setTopicChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("setTopicChannel error:" +  e.message);
    }
  }

  func onClickSetTypeChannel() {
    let that = this;
    let channelType = "p";
    try {
        let res = restAPI.setTypeChannel(channelId, roomName, channelType)
        AppLog.info("setTypeChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("setTypeChannel error:" +  e.message);
    }
  }

  func onClickArchiveChannel() {
    let that = this;
    try {
        let res = restAPI.archiveChannel(channelId)
        AppLog.info("archiveChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("archiveChannel error:" +  e.message);
    }
  }

  func onClickDeleteChannel() {
    let that = this;
    try {
        let res = restAPI.deleteChannel(channelId, roomName)
        AppLog.info("deleteChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("deleteChannel error:" +  e.message);
    }
  }

  func onClickCloseChannel() {
    let that = this;
    try {
        let res = restAPI.closeChannel(channelId)
        AppLog.info("closeChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("closeChannel error:" +  e.message);
    }
  }

  func onClickOpenChannel() {
    let that = this;
    try {
        let res = restAPI.openChannel(channelId)
        AppLog.info("openChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("openChannel error:" +  e.message);
    }
  }

  func onClickRemoveLeaderChannel() {
    let that = this;
    try {
        let res = restAPI.removeLeaderChannel(channelId, userId)
        AppLog.info("removeLeaderChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("removeLeaderChannel error:" +  e.message);
    }
  }

  func onClickRemoveModeratorChannel() {
    let that = this;
    try {
        let res = restAPI.removeModeratorChannel(channelId, userId)
        AppLog.info("removeModeratorChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("removeModeratorChannel error:" +  e.message);
    }
  }

  func onClickRemoveOwnerChannel() {
    let that = this;
    try {
        let res = restAPI.removeOwnerChannel(channelId, otherUserId)
        AppLog.info("removeOwnerChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("removeOwnerChannel error:" +  e.message);
    }
  }

  func onClickSetReadOnlyChannel() {
    let that = this;
    let readOnly = false;
    try {
        let res = restAPI.setReadOnlyChannel(channelId, true)
        AppLog.info("setReadOnlyChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("setReadOnlyChannel error:" +  e.message);
    }
  }

  func onClickSetDefaultChannel() {
    let that = this;
    let isDefault = false;
    try {
        let res = restAPI.setDefaultChannel(channelId, isDefault)
        AppLog.info("setDefaultChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("setDefaultChannel error:" +  e.message);
    }
  }

  func onClickUnArchiveChannel() {
    let that = this;
    try {
        let res = restAPI.unArchiveChannel(channelId)
        AppLog.info("unArchiveChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("unArchiveChannel error:" +  e.message);
    }
  }

  func onClickGroupAddLeader() {
    let that = this;
    try {
        let res = restAPI.groupAddLeader(groupID, userId)
        AppLog.info("group Add Leader data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("group Add Leader error:" +  e.message);
    }
  }

  func onClickGroupAddModerator() {
    let that = this;
    try {
        let res = restAPI.groupAddModerator(groupID, userId)
        AppLog.info("group Add Moderator data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("group Add Moderator error:" +  e.message);
    }
  }

  func onClickGroupArchive() {
    let that = this;
    try {
        let res = restAPI.groupArchive(groupID)
        AppLog.info("groupArchive data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupArchive error:" +  e.message);
    }
  }

 func  onClickGroupUnArchive() {
    let that = this;
    try {
        let res = restAPI.groupUnArchive(groupID)
        AppLog.info("groupUnArchive data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupUnArchive error:" +  e.message);
    }
  }

  func onClickGroupCreate() {
    let that = this;
    let readOnly = true;
    let resourceManager = ResourceManager.getResourceManager(MainAbility().getStageContext())
    if(that.groupName.isEmpty()) {
      this.showToast(resourceManager.getString(Int32(@r(app.string.group_name_cannot_be_empty).id)))
    } else {
        try {
            let res = restAPI.groupCreate(that.groupName)
            AppLog.info("restApiSample groupCreate data:" + res);
            AppLog.info('groupCreate data:' + res);
            that.showToast("Success");
        } catch (e: Exception) {
            that.showToast("Error :" + e.message);
            AppLog.info("groupCreate error:" +  e.message);
        }
    }
  }

  func onClickGroupIntegrations() {
    let that = this;
    try {
        let res = restAPI.groupIntegrations(groupID)
        AppLog.info("groupIntegrations data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupIntegrations error:" +  e.message);
    }
  }

  func onClickGroupInvite() {
    let that = this;
    try {
        let res = restAPI.groupInvite(groupID, otherUserId)
        AppLog.info("groupInvite data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupInvite error:" +  e.message);
    }
  }

  func onClickGroupRename() {
    let that = this;
    try {
        let res = restAPI.groupRename("DevGroupRename26", groupID)
        AppLog.info("groupRename data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupRename error:" +  e.message);
    }
  }

  func onClickGroupDelete() {
    let that = this;
    try {
        let res = restAPI.groupDelete(groupID, roomName)
        AppLog.info("groupDelete data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupDelete error:" +  e.message);
    }
  }

  func onClickGroupAddAll() {
    let that = this;
    let activeUsersOnly = true;
    try {
        let res = restAPI.groupAddAll(groupID, activeUsersOnly)
        AppLog.info("groupAddAll data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupAddAll error:" +  e.message);
    }
  }

  func onClickGroupAddOwner() {
    let that = this;
    try {
        let res = restAPI.groupAddOwner(groupID, otherUserId)
        AppLog.info("groupAddOwner data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupAddOwner error:" +  e.message);
    }
  }

  func onClickGroupRemoveOwner() {
    let that = this;
    try {
        let res = restAPI.groupRemoveOwner(groupID, userId)
        AppLog.info("groups.removeOwner data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groups.removeOwner error:" +  e.message);
    }
  }

  func onClickGroupRemoveModerator() {
    let that = this;
    try {
        let res = restAPI.groupRemoveModerator(groupID, userId)
        AppLog.info("groupRemoveModerator data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupRemoveModerator error:" +  e.message);
    }
  }

  func onClickGroupInfo() {
    let that = this;
    let roomName = "";
    try {
        let res = restAPI.groupInfo(groupID, roomName)
        AppLog.info("groupInfo data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupInfo error:" +  e.message);
    }
  }

  func onClickGroupList() {
    let that = this;
    try {
        let res = restAPI.groupList()
        AppLog.info("groupList data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupList error:" +  e.message);
    }
  }

  func onClickGroupHistory() {
    let that = this;
    let inclusive = true;
    let offset = 2;
    let count = 100;
    let unreads = true;
    let latest = DateTime.nowUTC()
    let oldest = DateTime.ofUTC(year: 2022, month: 3, dayOfMonth: 29)
    let optionalParams:OptionalParams= OptionalParams(latest.toString(), oldest.toString(), inclusive, offset, count, unreads)
    try {
        let res = restAPI.groupHistory(groupID, JsonValue.fromStr(optionalParams.serialize().toJson().asObject().toJsonString()))
        AppLog.info("groupHistory data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupHistory error:" +  e.message);
    }
  }

  func onClickSetDescription() {
    let that = this;
    try {
        let res = restAPI.groupSetDescription(groupID, "SetDescription")
        AppLog.info("groupSetDescription data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupSetDescription error:" +  e.message);
    }
  }

  func onClickGroupOpen() {
    let that = this;
    try {
        let res = restAPI.groupOpen(groupID)
        AppLog.info("groupOpen data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupOpen error:" +  e.message);
    }
  }

  func onClickGroupClose() {
    let that = this;
    try {
        let res = restAPI.groupClose(groupID)
        AppLog.info("groupClose data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupClose error:" +  e.message);
    }
  }

  func onClickGroupKick() {
    let that = this;
    try {
        let res = restAPI.groupKick(groupID, userId)
        AppLog.info("groupKick data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupKick error:" +  e.message);
    }
  }

  func onClickGroupLeave() {
    let that = this;
    try {
        let res = restAPI.groupLeave(groupID)
        AppLog.info("groupLeave data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupLeave error:" +  e.message);
    }
  }

  func onClickSetPurpose() {
    let that = this;
    try {
        let res = restAPI.groupSetPurpose(groupID, "Test out everything")
        AppLog.info("groupSetPurpose data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupSetPurpose error:" +  e.message);
    }
  }

  func onClickSetReadOnly() {
    let that = this;
    let readOnly = false;
    try {
        let res = restAPI.groupSetReadOnly(groupID, false)
        AppLog.info("setReadOnly data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("setReadOnly error:" +  e.message);
    }
  }

  func onClickSetTopic() {
    let that = this;
    let readOnly = false;
    try {
        let res = restAPI.groupSetTopic(groupID, "GroupTopic")
        AppLog.info("groupSetTopic data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupSetTopic error:" +  e.message);
    }
  }

  func onClickSetType() {
    let that = this;
    try {
        let res = restAPI.groupSetType(groupID, 'c')
        AppLog.info("groupSetType data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("groupSetType error:" +  e.message);
    }
  }

  func onClickSettings() {
    let that = this;
    try {
        let res = restAPI.settings()
        AppLog.info("settings data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("settings error:" +  e.message);
    }
  }


  func onClickLogout() {
    let that = this;
    try {
        let res = restAPI.logout()
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
    }
  }

  func onClickPostMessageChat() {
        let attachments = [Attachments("http://www.w3schools.com/tags/horse.mp3",
                    "https://avatars.githubusercontent.com/u/850391 v=3",
                    "https://rocket.chat/",
                    "Bradley Hilton",
                    false,
                    Color.WHITE,
                    [Fields(true, "Test", "Testing out something or other"), Fields(true, "Another Test", "[Link](http://www.w3schools.com) something and this and that.")],
                    "http://www.w3schools.com",
                    "Yay for gruggy!",
                    "https://via.placeholder.com/300/09f/fff.png",
                    "Attachment Example",
                    "http://www.w3schools.com",
                    true,
                    "2016-12-09T16:53:06.761Z",
                    "http://www.w3schools.com/tags/movie.mp4")]
    let postMessageData:PostMessageData = PostMessageData("#" + roomName, ":smirk:", channelId, "Hello", attachments)
    let that = this;
    try {
         let dataStr = postMessageData.serialize().toJson().asObject().toJsonString();
        let res = restAPI.postMessageChat(dataStr)
        AppLog.info("postMessageChat data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("postMessageChat error:" + e.message);
    }
  }

  func onClickUpdateMessageChat() {
    let that = this;
    try {
        let res = restAPI.updateMessageChat("Hello Everyone!!")
        AppLog.info("updateMessageChat data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("updateMessageChat error:" + e.message);
    }
  }

  func onClickDeleteMessageChat() {
    let that = this;
    try {
        let res = restAPI.deleteMessageChat(channelId, messageId, false)
        AppLog.info("deleteMessageChat data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("deleteMessageChat error:" + e.message);
    }
  }

  func onClickUserSetAvatar() {
    let avatarUrl = "https://via.placeholder.com/300/09f/fff.png"
    try {
        let res = restAPI.setAvatar(avatarUrl)
        AppLog.info("setAvatar:" + res);
        this.showToast("Success");
    } catch (e: Exception) {
        this.showToast("Error :" + e.message);
        AppLog.info("setAvatar:" + e.message);
    }
  }

  func onClickGetIntegrationsChannel() {
    let that = this;
    try {
        let res = restAPI.getIntegrationChannel(channelId)
        AppLog.info("getIntegrationsChannel data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("getIntegrationsChannel:" + e.message);
    }
  }

  func onClickUsersInfo() {
    let that = this;
    try {
        let res = restAPI.usersInfo(user_id, "")
        AppLog.info("usersInfo data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("usersInfo:" + e.message);
    }
  }

  func onClickUsersPresence() {
    let that = this;
    try {
        let res = restAPI.usersPresence(presenceUserId, userName)
        AppLog.info("usersPresence data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("usersPresence:" + e.message);
    }
  }

  func onClickUserDelete() {
    let that = this;
    try {
        let res = restAPI.userDelete(user_id, false)
        AppLog.info("userDelete data:" + res);
        that.showToast("Success");
    } catch (e: Exception) {
        that.showToast("Error :" + e.message);
        AppLog.info("userDelete:" + e.message);
    }
  }

  func showToast(message:String) {
    PromptAction.showToast(message: message, duration: 3000)
  }
}