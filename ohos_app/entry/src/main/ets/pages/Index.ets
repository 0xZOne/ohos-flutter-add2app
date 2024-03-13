import { hilog } from '@kit.PerformanceAnalysisKit';
import { FlutterBoost } from '@ohos/flutter_module';
import router from '@ohos.router';

const TAG: string = "xlog-Index";
@Entry
@Component
struct Index {
  @State message: string = 'Flutter Add2App Demo';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(28)
          .fontColor(Color.Red)
          .fontWeight(FontWeight.Bold)
          .decoration({ type: TextDecorationType.Underline, color: Color.Yellow })
          .margin({ bottom: 100 })
        Button('打开Flutter页面')
          .margin({ bottom: 10 })
          .onClick(() => {
            try {
              // router.pushUrl({ url: 'pages/FirstFlutterPage' })
              FlutterBoost.getInstance().open('flutterPage', {})
            } catch (err) {
              hilog.info(0x0000, TAG, '%{public}s', 'Failed to 打开Flutter页面');
            }
          })
        Button('打开Native页面')
          .margin({ bottom: 10 })
          .onClick(() => {
            try {
              router.pushUrl({ url: 'pages/NativePage' })
            } catch (err) {
              hilog.info(0x0000, TAG, '%{public}s', 'Failed to 打开Native页面');
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}