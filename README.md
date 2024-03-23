# 鸿蒙add-to-app示例
该示例演示了如何将Flutter嵌入到「鸿蒙」原生工程中，以及如何接入[FlutterBoost](https://github.com/alibaba/flutter_boost)。

![image](https://github.com/0xZOne/ohos-flutter-add2app/assets/26625149/f30d9ba7-e7ff-4bc0-ade1-28b6ca10c02c)
其中，`simple_flutter_page`是一个简单flutter页面的示例，而，`flutter_boost_page`标签则包含flutterboost插件的接入代码。

## 如何运行
下载源码，进入`my_flutter_module`目录，执`flutter run`即可运行示例。

## 运行效果
https://github.com/0xZOne/ohos-flutter-add2app/assets/26625149/6c5afc47-bc04-4c33-b502-ff759690b532

## 目录结构
ohos-flutter-add2app示例代码的工程结构如下：
```
ohos-flutter-add2app    //示例根目录
├── my_flutter_module   //flutter工程目录
│   └── .ohos           //符号链接到宿主工程
└── ohos_app            //鸿蒙宿主工程目录
    ├── AppScope
    ├── entry           //主模块
    └── flutter_module  //flutter模块
        └── har
            ├── flutter_boost.har  //FlutterBoost插件
            └── flutter.har        //flutter引擎
```

其中，「flutter工程」与「鸿蒙宿主工程」属于兄弟节点，处于同一个目录下。

### flutter工程
为了将Flutter应用到现有的鸿蒙应用中，需要将flutter工程创建为module类型，例如：
```bash
flutter create -t module --org com.example.add2app my_flutter_module
```
创建好的Flutter模块（my_flutter_module）中有一个隐藏的.ohos文件夹，它包含了一个简单的嵌入了Flutter模块的鸿蒙项目。

为了将Flutter工程与鸿蒙宿主工程联动，将.ohos链接到外面的鸿蒙宿主工程：
```bash
rm -rf .ohos
ln -s ../ohos_app .ohos
```
关联宿主工程后，在Flutter模块工程修改Dart代码，然后执行`flutter run`便可以更新宿主工程的flutter_module，例如，将相关的har包拷贝到flutter_module/har/目录。

Flutter鸿蒙社区版本，运行`flutter run`时会删除.ohos并通过模版重新生成目录，导致之前创建的软链接失效。可以通过修改以下代码解决：
```diff
diff --git a/packages/flutter_tools/lib/src/project.dart b/packages/flutter_tools/lib/src/project.dart
index 069e6ee00a..3e51e5a42b 100644
--- a/packages/flutter_tools/lib/src/project.dart
+++ b/packages/flutter_tools/lib/src/project.dart
@@ -2,6 +2,7 @@
 // Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.

+import 'dart:io' as io;
 import 'package:meta/meta.dart';
 import 'package:xml/xml.dart';
 import 'package:yaml/yaml.dart';
@@ -1000,6 +1001,12 @@ class OhosProject extends FlutterProjectPlatform {
   }

   bool _shouldRegenerateFromTemplate() {
+    // Do not re-generate .ohos when it already exists and is a symbolic link.
+    if (ephemeralDirectory.existsSync() &&
+        io.FileSystemEntity.isLinkSync(ephemeralDirectory.path)) {
+      return false;
+    }
+
     return globals.fsUtils.isOlderThanReference(
           entity: ephemeralDirectory,
           referenceFile: parent.pubspecFile,
```

### 鸿蒙宿主工程
鸿蒙宿主工程中，增加一个Library类型的Module，在主模块中添加依赖：
```json
{
  "name": "entry",
  "version": "1.0.0",
  "description": "Please describe the basic information.",
  "main": "",
  "author": "",
  "license": "",
  "dependencies": {
    "@ohos/flutter_module": "../flutter_module"
  }
}
```

### 接入FlutterBoost

FlutterBoost 从4.5.0开始支持鸿蒙，接口与Android基本保持一致，接入方式也类似，详细接入流程请戳👇 [链接](https://github.com/alibaba/flutter_boost/blob/task/4.4.2-support-ohos/docs/install.md#ohos%E9%83%A8%E5%88%86)，或者直接看该示例代码。
