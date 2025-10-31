/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package ohos_app_cangjie_entry

internal import ohos.base.LengthProp
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.Router

@Entry
@Component
class EntryView {
    func build() {
        Flex(FlexParams(direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center)
        ) {
            Button("RestAPI").width(300).height(45).id("RestAPI").onClick({
                evn => Router.push(url: "RestApiSample")
            }).margin(10)
        }.width(100.percent).height(100.percent)
    }
}