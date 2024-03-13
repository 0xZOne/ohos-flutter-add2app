import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class FlutterIndexRoute extends StatefulWidget {
  const FlutterIndexRoute({this.params, this.message, this.uniqueId});

  final Map? params;
  final String? message;
  final String? uniqueId;

  @override
  State<FlutterIndexRoute> createState() => _FlutterIndexRouteState();
}

class _FlutterIndexRouteState extends State<FlutterIndexRoute>
    with PageVisibilityObserver {
  static const String _kTag = 'page_visibility';
  bool withContainer = true;

  @override
  void initState() {
    super.initState();
    Logger.log('$_kTag#initState, ${widget.uniqueId}, $this');
  }

  @override
  void didChangeDependencies() {
    Logger.log('$_kTag#didChangeDependencies, ${widget.uniqueId}, $this');
    PageVisibilityBinding.instance.addObserver(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    PageVisibilityBinding.instance.removeObserver(this);
    Logger.log('$_kTag#dispose~, ${widget.uniqueId}, $this');
    super.dispose();
  }

  @override
  void onPageShow() {
    Logger.log('$_kTag#onPageShow, ${widget.uniqueId}, $this');
  }

  @override
  void onPageHide() {
    Logger.log('$_kTag#onPageHide, ${widget.uniqueId}, $this');
  }

  @override
  void onForeground() {
    Logger.log('$_kTag#onForeground, ${widget.uniqueId}, $this');
  }

  @override
  void onBackground() {
    Logger.log('$_kTag#onBackground, ${widget.uniqueId}, $this');
  }

  @override
  Widget build(BuildContext context) {
    Logger.log(
        '${MediaQuery.of(context).padding.top} uniqueId=${widget.uniqueId}');
    Logger.log(
        '${MediaQuery.of(context).padding.bottom} uniqueId=${widget.uniqueId}');
    Logger.log(
        '${MediaQuery.of(context).size.width} uniqueId=${widget.uniqueId}');
    Logger.log(
        '${MediaQuery.of(context).size.height} uniqueId=${widget.uniqueId}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterBoost Example'),
        actions: <Widget>[
          Switch(
            value: withContainer,
            onChanged: (value) {
              setState(() {
                withContainer = value;
              });
            },
            activeTrackColor: Colors.yellow,
            activeColor: Colors.orangeAccent,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: const Text(
                      'Pop with parameter',
                      style: TextStyle(fontSize: 22.0, color: Colors.blue),
                    )),
                onTap: () =>
                    Navigator.of(context).pop({'msg': 'I am from dart ...'}),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: const Text(
                      'Open native page',
                      style: TextStyle(fontSize: 22.0, color: Colors.blue),
                    )),
                onTap: () => BoostNavigator.instance.push("native").then(
                    (value) =>
                        debugPrint("Return from Native: ${value.toString()}")),
              ),
              InkWell(
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.yellow,
                      child: const Text(
                        'Counter demo',
                        style: TextStyle(fontSize: 22.0, color: Colors.black),
                      )),
                  onTap: () => BoostNavigator.instance
                      .push("counter", withContainer: withContainer)),
              InkWell(
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.yellow,
                      child: const Text(
                        'Hero Animation Demo',
                        style: TextStyle(fontSize: 22.0, color: Colors.black),
                      )),
                  onTap: () => BoostNavigator.instance
                      .push('hero_animation', withContainer: withContainer)),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: const Text(
                      'MediaQuery demo',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () => BoostNavigator.instance
                    .push("mediaquery", withContainer: withContainer)
                    .then((value) =>
                        debugPrint('xlog, mediaquery, Return Value:$value')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
