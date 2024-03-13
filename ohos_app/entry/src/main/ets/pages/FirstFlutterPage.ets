/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import hilog from '@ohos.hilog';
import { FlutterBoostEntry, FlutterView, FlutterPage } from '@ohos/flutter_module';

import router from '@ohos.router';

const TAG: string = "xlog-FirstFlutterPage";
@Entry
@Component
struct FirstFlutterPage {
  private flutterEntry: FlutterBoostEntry | null = null;
  private flutterView?: FlutterView

  aboutToAppear() {
    this.flutterEntry = new FlutterBoostEntry(getContext(this), router.getParams());
    this.flutterEntry.aboutToAppear();
    this.flutterView = this.flutterEntry.getFlutterView();
    hilog.info(0x0000, TAG, "Index aboutToAppear===");
  }

  aboutToDisappear() {
    hilog.info(0x0000, TAG, "Index aboutToDisappear===");
    this.flutterEntry?.aboutToDisappear()
  }

  onPageShow() {
    hilog.info(0x0000, TAG, "Index onPageShow===");
    this.flutterEntry?.onPageShow()
  }
  // 1
  onPageHide() {
    hilog.info(0x0000, TAG, "Index onPageHide===");
    this.flutterEntry?.onPageHide()
  }

  build() {
    Stack() {
      FlutterPage({ viewId: this.flutterView?.getId() })
    }
  }
}