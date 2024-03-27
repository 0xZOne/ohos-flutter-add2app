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

import curves from '@ohos.curves';
import router from '@ohos.router';

const TAG: string = "xlog-FlutterUI";

@Component
export struct FlutterUIComponent {
  @Prop uri: string;
  @Prop params: Record<string, Object>;

  private flutterEntry: FlutterBoostEntry | null = null;
  private flutterView?: FlutterView;
  private effect: object =
    TransitionEffect.OPACITY
      .combine(TransitionEffect.move(TransitionEdge.END)).animation({curve: curves.springMotion()});

  aboutToAppear() {
    this.flutterEntry = new FlutterBoostEntry(getContext(this), {
      uri: this.uri,
      params: this.params,
    });
    this.flutterEntry.aboutToAppear();
    this.flutterView = this.flutterEntry.getFlutterView();
    hilog.info(0x0000, TAG, 'Component(#%{public}s) aboutToAppear===', this.uri);
  }

  aboutToDisappear() {
    hilog.info(0x0000, TAG, 'Component(#%{public}s) aboutToDisappear===', this.uri);
    this.flutterEntry?.aboutToDisappear()
  }

  onPageShow() {
    hilog.info(0x0000, TAG, 'Component(#%{public}s) onPageShow===', this.uri);
    this.flutterEntry?.onPageShow()
  }
  // 1
  onPageHide() {
    hilog.info(0x0000, TAG, 'Component(#%{public}s) onPageHide===', this.uri);
    this.flutterEntry?.onPageHide()
  }

  build() {
    Stack() {
      FlutterPage({ viewId: this.flutterView?.getId() })
    }
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible) {
        setTimeout(() => {
          this.onPageShow();
        }, 0);
      } else {
        this.onPageHide();
      }
    })
    .transition(this.effect)
  }
}

@Entry
@Component
struct FlutterUIPage {
  private flutterEntry: FlutterBoostEntry | null = null;
  private flutterView?: FlutterView;
  private effect: object =
    TransitionEffect.OPACITY
      .combine(TransitionEffect.move(TransitionEdge.END)).animation({curve: curves.springMotion()});

  aboutToAppear() {
    this.flutterEntry = new FlutterBoostEntry(getContext(this), router.getParams());
    this.flutterEntry.aboutToAppear();
    this.flutterView = this.flutterEntry.getFlutterView();
    hilog.info(0x0000, TAG, "Page aboutToAppear===");
  }

  aboutToDisappear() {
    hilog.info(0x0000, TAG, "Page aboutToDisappear===");
    this.flutterEntry?.aboutToDisappear()
  }

  onPageShow() {
    hilog.info(0x0000, TAG, "Page onPageShow===");
    this.flutterEntry?.onPageShow()
  }
  // 1
  onPageHide() {
    hilog.info(0x0000, TAG, "Page onPageHide===");
    this.flutterEntry?.onPageHide()
  }

  build() {
    Stack() {
      FlutterPage({ viewId: this.flutterView?.getId() })
    }.transition(this.effect)
  }
}