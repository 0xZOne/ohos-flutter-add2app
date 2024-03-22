import { hilog } from '@kit.PerformanceAnalysisKit';
import { FlutterBoost } from '@ohos/flutter_module';
import router from '@ohos.router';
import { FlutterUIComponent } from './FlutterUI';

const TAG: string = "xlog-Index";
@Entry
@Component
struct Index {
  @State message: string = 'Flutter Add2App Demo';
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()

  @Builder tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.currentIndex === index ? 1 : 0)
    }.width('100%')
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
        TabContent() {
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
        }.tabBar(this.tabBuilder(0, '首页'))

        TabContent() {
          FlutterUIComponent({ uri: 'flutterPage' })
        }.tabBar(this.tabBuilder(1, 'flutterPage'))

        TabContent() {
          FlutterUIComponent({ uri: 'counter' })
        }.tabBar(this.tabBuilder(2, 'counter'))

        TabContent() {
          FlutterUIComponent({ uri: 'mediaquery' })
        }.tabBar(this.tabBuilder(3, 'mediaquery'))
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .barWidth(360)
      .barHeight(56)
      .animationDuration(400)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .width('100%')
      .height('100%')
    }.width('100%')
  }
}