package ohos_app_cangjie_entry_test.LLT

import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import ohos.ui_test.*
import ohos.hilog.Hilog
import rocketlib.*

@Test
class TestExample {

    @TestCase
    func testlogin(): Unit {
        let driver = Driver.create()
        // 进入测试页面
        let componentButton01 = driver.findComponent(On().id("RestAPI"))
        componentButton01.click()
        driver.delayMs(1000)
        let componentButton02 = driver.findComponent(On().id("login"))
        componentButton02.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testloginWithAuthToken(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("loginWithAuthToken"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testme(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("me"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testuserCreate(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("userCreate"))
        componentButton.click()
        driver.delayMs(30000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testusersList(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("usersList"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testusersInfo(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("usersInfo"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testusersPresence(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("usersPresence"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testsetAvatar(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("setAvatar"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testsettings(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("settings"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testpageVisited(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("pageVisited"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testvisitorRegistration(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("visitorRegistration"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testvisitor(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("visitor"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testsetVisitorStatus(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("setVisitorStatus"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testvisitorDelete(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("visitorDelete"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testbannersEndPoint(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("bannersEndPoint"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgetBanners(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("getBanners"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testcreateChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("createChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testcloseChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("closeChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testopenChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("openChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testsetTypeChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("setTypeChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testpostMessageChat(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("postMessageChat"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testupdateMessageChat(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("updateMessageChat"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testdeleteMessageChat(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("deleteMessageChat"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testinviteChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("inviteChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testaddLeaderChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("addLeaderChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testremoveLeaderChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("removeLeaderChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testaddModeratorChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("addModeratorChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testremoveModeratorChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("removeModeratorChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testaddOwnerChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("addOwnerChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testremoveOwnerChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("removeOwnerChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testsetPurposeChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("setPurposeChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testsetReadOnlyChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("setReadOnlyChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testarchiveChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("archiveChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testunArchiveChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("unArchiveChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testcounterChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("counterChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testfilesChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("filesChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testhistoryChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("historyChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testinfoChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("infoChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testjoinChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("joinChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testkickChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("kickChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testleaveChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("leaveChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testlistChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("listChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testjoinListChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("joinListChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testmembersChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("membersChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testonlineChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("onlineChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgetUserAllMentionByChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("getUserAllMentionByChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testrenameChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("renameChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testrolesChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("rolesChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testsetAnnouncementChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("setAnnouncementChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testsetJoinCodeChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("setJoinCodeChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgetIntegrationChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("getIntegrationChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testsetDefaultChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("setDefaultChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testaddAllChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("addAllChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testmessageChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("messageChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testsetCustomFieldsChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("setCustomFieldsChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testsetTopicChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("setTopicChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testdeleteChannel(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("deleteChannel"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupCreate(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupCreate"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupInvite(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupInvite"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupRename(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupRename"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupSetReadOnly(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id(""))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupSetTopic(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupSetTopic"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupAddLeader(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupAddLeader"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupInfo(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupInfo"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupList(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupList"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupAddModerator(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupAddModerator"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupRemoveModerator(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupRemoveModerator"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupSetDescription(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupSetDescription"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupArchive(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupArchive"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupUnArchive(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupUnArchive"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupIntegrations(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupIntegrations"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupClose(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupClose"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupOpen(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupOpen"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupHistory(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupHistory"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupSetType(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupSetType"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupSetPurpose(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupSetPurpose"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupKick(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupKick"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupAddAll(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupAddAll"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupAddOwner(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupAddOwner"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupRemoveOwner(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupRemoveOwner"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupLeave(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupLeave"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testgroupDelete(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("groupDelete"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testuserDelete(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("userDelete"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }

    @TestCase
    func testlogout(): Unit {
        let driver = Driver.create()
        let componentButton = driver.findComponent(On().id("logout"))
        componentButton.click()
        driver.delayMs(2000)
        let text: UIComponent = driver.findComponent(On().id("testText"))
        @Assert(text.getText() , 'true')
    }
}
