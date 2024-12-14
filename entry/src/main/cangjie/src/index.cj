/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_entry

import ohos.component.*
import ohos.base.LengthProp
import ohos.state_manage.SubscriberManager
import ohos.state_manage.LocalStorage
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.router.Router

@Entry
@Component
class EntryView {
    func build() {
        Flex(FlexParams(direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center)) {
          Button("RestAPI")
            .width(300)
            .height(45)
              .onClick({ evn =>
                Router.push(url: "RestApiSample" )
              })
            .margin(10)
        }
        .width(100.percent)
        .height(100.percent)
    }
}
