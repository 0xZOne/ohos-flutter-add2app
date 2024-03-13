import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

import 'case/counter_demo.dart';
import 'case/hero_animation.dart';
import 'case/media_query.dart';
import 'flutter_page.dart';

void main(List<String> args) {
  PageVisibilityBinding.instance
      .addGlobalObserver(AppGlobalPageVisibilityObserver());
  CustomFlutterBinding();
  runApp(MyApp());
  print('dartEntrypointArgs: $args');
}

class AppGlobalPageVisibilityObserver extends GlobalPageVisibilityObserver {
  @override
  void onPagePush(Route<dynamic> route) {
    Logger.log(
        'boost_lifecycle: AppGlobalPageVisibilityObserver.onPageCreate route:${route.settings.name}');
  }

  @override
  void onPageShow(Route<dynamic> route) {
    Logger.log(
        'boost_lifecycle: AppGlobalPageVisibilityObserver.onPageShow route:${route.settings.name}');
  }

  @override
  void onPageHide(Route<dynamic> route) {
    Logger.log(
        'boost_lifecycle: AppGlobalPageVisibilityObserver.onPageHide route:${route.settings.name}');
  }

  @override
  void onPagePop(Route<dynamic> route) {
    Logger.log(
        'boost_lifecycle: AppGlobalPageVisibilityObserver.onPageDestroy route:${route.settings.name}');
  }

  @override
  void onForeground(Route route) {
    Logger.log(
        'boost_lifecycle: AppGlobalPageVisibilityObserver.onForeground route:${route.settings.name}');
  }

  @override
  void onBackground(Route<dynamic> route) {
    Logger.log(
        'boost_lifecycle: AppGlobalPageVisibilityObserver.onBackground route:${route.settings.name}');
  }
}

class CustomFlutterBinding extends WidgetsFlutterBinding
    with BoostFlutterBinding {}

class CustomInterceptor1 extends BoostInterceptor {
  @override
  void onPrePush(
      BoostInterceptorOption option, PushInterceptorHandler handler) {
    Logger.log('CustomInterceptor#onPrePush1~~~, $option');
    // Add extra arguments
    option.arguments!['CustomInterceptor1'] = "1";
    super.onPrePush(option, handler);
  }

  @override
  void onPostPush(
      BoostInterceptorOption option, PushInterceptorHandler handler) {
    Logger.log('CustomInterceptor#onPostPush1~~~, $option');
    handler.next(option);
  }
}

class CustomInterceptor2 extends BoostInterceptor {
  @override
  void onPrePush(
      BoostInterceptorOption option, PushInterceptorHandler handler) {
    Logger.log('CustomInterceptor#onPrePush2~~~, $option');
    // Add extra arguments
    option.arguments!['CustomInterceptor2'] = "2";
    if (!option.isFromHost! && option.name == "interceptor") {
      handler.resolve(<String, dynamic>{'result': 'xxxx'});
    } else {
      handler.next(option);
    }
  }

  @override
  void onPostPush(
      BoostInterceptorOption option, PushInterceptorHandler handler) {
    Logger.log('CustomInterceptor#onPostPush2~~~, $option');
    handler.next(option);
  }
}

class CustomInterceptor3 extends BoostInterceptor {
  @override
  void onPrePush(
      BoostInterceptorOption option, PushInterceptorHandler handler) {
    Logger.log('CustomInterceptor#onPrePush3~~~, $option');
    // Replace arguments
    // option.arguments = <String, dynamic>{'CustomInterceptor3': '3'};
    handler.next(option);
  }

  @override
  void onPostPush(
      BoostInterceptorOption option, PushInterceptorHandler handler) {
    Logger.log('CustomInterceptor#onPostPush3~~~, $option');
    handler.next(option);
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static Map<String, FlutterBoostRouteFactory> routerMap = {
    'counter': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (_, __, ___) =>
              const CounterPage(title: "Counter Demo"));
    },
    'hero_animation': (settings, uniqueId) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const HeroAnimation());
    },
    'mediaquery': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (_, __, ___) => MediaQueryRouteWidget(
                params: settings.arguments as Map<dynamic, dynamic>?,
                uniqueId: uniqueId,
              ));
    },

    ///可以在native层通过 getContainerParams 来传递参数
    'flutterPage': (settings, uniqueId) {
      debugPrint('flutterPage settings:$settings, uniqueId:$uniqueId');
      return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => FlutterIndexRoute(
          params: settings.arguments as Map<dynamic, dynamic>?,
          uniqueId: uniqueId,
        ),
        // transitionsBuilder: (BuildContext context, Animation<double> animation,
        //     Animation<double> secondaryAnimation, Widget child) {
        //   return SlideTransition(
        //     position: Tween<Offset>(
        //       begin: const Offset(1.0, 0),
        //       end: Offset.zero,
        //     ).animate(animation),
        //     child: SlideTransition(
        //       position: Tween<Offset>(
        //         begin: Offset.zero,
        //         end: const Offset(-1.0, 0),
        //       ).animate(secondaryAnimation),
        //       child: child,
        //     ),
        //   );
        // },
      );
    },
  };

  Route<dynamic>? routeFactory(RouteSettings settings, String? uniqueId) {
    FlutterBoostRouteFactory? func = routerMap[settings.name!];
    if (func == null) {
      return null;
    }
    return func(settings, uniqueId);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(routeFactory,
        // 如果自定了appBuilder，需要将传入的参数添加到widget层次结构中去，
        // 否则会导致FluttBoost初始化失败。
        appBuilder: (child) => MaterialApp(
              home: child,
            ),
        interceptors: [
          CustomInterceptor1(),
          CustomInterceptor2(),
          CustomInterceptor3(),
        ]);
  }
}
