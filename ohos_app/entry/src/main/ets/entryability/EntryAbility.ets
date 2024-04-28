
import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import {
  FlutterManager,
  FlutterBoost,
  FlutterBoostDelegate,
  FlutterBoostRouteOptions,
  FlutterBoostSetupOptionsBuilder,
  GeneratedPluginRegistrant
} from '@ohos/flutter_module';

import router from '@ohos.router';

const TAG: string = "xlog-EntryAbility";
export default class EntryAbility extends UIAbility implements FlutterBoostDelegate {
  // 打开原生
  pushNativeRoute(options: FlutterBoostRouteOptions) {
    router.pushUrl({ url: 'pages/NativePage' })
  }

  // 打开flutter
  pushFlutterRoute(options: FlutterBoostRouteOptions) {
    hilog.info(0x0000, TAG, '%{public}s', '#pushFlutterRoute: ' + options.getPageName());
    router.pushUrl({
      url: 'pages/FlutterUI', params: {
        uri: options.getPageName(),
        params: options.getArguments(),
      }
    }).then(() => {
      hilog.info(0x0000, TAG, '%{public}s', 'Succeeded in jumping to: ' + options.getPageName());
    })
  }

  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    FlutterManager.getInstance().pushUIAbility(this)
  }

  onDestroy(): void {
    FlutterManager.getInstance().popUIAbility(this)
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onWindowStageCreate');
    FlutterManager.getInstance().pushWindowStage(this, windowStage);

    const optionsBuilder: FlutterBoostSetupOptionsBuilder = new FlutterBoostSetupOptionsBuilder()
    FlutterBoost.getInstance().setup(this, this.context, (engine) => {
      hilog.info(0x0000, TAG, '%{public}s', '引擎初始化成功 ~~~');

      // Register plugins
      GeneratedPluginRegistrant.registerWith(engine);

      windowStage.loadContent('pages/Index', (err, data) => {
        if (err.code) {
          hilog.error(0x0000, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
          return;
        }
        hilog.info(0x0000, TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
      });
    }, optionsBuilder.build())
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onCreate');
  }

  onWindowStageDestroy(): void {
    FlutterManager.getInstance().popWindowStage(this)
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onBackground');
  }
}