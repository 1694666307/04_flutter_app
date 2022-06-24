import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    Key? key,
    this.colors,
    this.width,
    this.height,
    this.onPressed,
    this.borderRadius,
    required this.child,
  }) : super(key: key);

  // 渐变色数组
  final List<Color>? colors;

  // 按钮宽高
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  //点击回调
  final GestureTapCallback? onPressed;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    //确保colors数组不空
    List<Color> _colors =
        colors ?? [theme.primaryColor, theme.primaryColorDark];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _colors),
        borderRadius: borderRadius,
        //border: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          splashColor: _colors.last,
          highlightColor: Colors.transparent,
          borderRadius: borderRadius,
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: height, width: width),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DefaultTextStyle(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class NewRoute extends StatelessWidget {
  var textToDisplay = "Text To Display";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("A Route Of tomato"),
      ),
      body: Center(
        child: GestureDetector(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.blue
            ),
            alignment: Alignment.center,
            child: Wrap(
              direction: Axis.vertical,
              spacing: 8.0,
              // 主轴(水平)方向间距
              runSpacing: 4.0,
              // 纵轴（垂直）方向间距
              alignment: WrapAlignment.center,
              //沿主轴方向居中
              children: <Widget>[
                Align(
                  widthFactor: 2,
                  heightFactor: 2,
                  alignment: Alignment.center,
                  child: const Text(
                    "Here is a Wrap Layout",
                    textAlign: TextAlign.center,
                  ),
                ),

                Chip(
                  avatar:
                  CircleAvatar(backgroundColor: Colors.blue, child: Text('A')),
                  label: Text('Hamilton'),
                ),
                Chip(
                  avatar:
                  CircleAvatar(backgroundColor: Colors.blue, child: Text('M')),
                  label: Text('Lafayette'),
                ),
                Chip(
                  avatar:
                  CircleAvatar(backgroundColor: Colors.blue, child: Text('H')),
                  label: Text('Mulligan'),
                ),
                Chip(
                  avatar:
                  CircleAvatar(backgroundColor: Colors.blue, child: Text('J')),
                  label: Text('Laurens'),
                ),
                GradientButton(
                  colors: const [Colors.orange, Colors.red],
                  height: 50.0,
                  child: const Text("Download And Show"),
                  onPressed: () async => {
                    textToDisplay = "text",
                  },
                ),
                Text("$textToDisplay")
              ],
            ),
          ),

          onTap: ()=>{
            print("taped")
          },
          onHorizontalDragUpdate: (DragUpdateDetails details)=>{
            print(details)
          },
        )
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String textToShow = "Text To display";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  request() async {
    print("download");
    Dio dio = Dio();
    Response response;
    response = await dio.get("https://raw.githubusercontent.com/1694666307/04_flutter_app/main/to_download.txt");
    setState(() {
      textToShow = response.data;
    });
  }

  Future<void> testSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', _counter);
  }

  Future<void> testLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? t = prefs.getInt('counter');
    if(t != null){
      setState(() {
        _counter = 0;
      });
    }else{
      setState(() {
        _counter = t!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            color: Colors.greenAccent
          ),
          child: Wrap(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            direction: Axis.vertical,
            spacing: 8.0,
            // 主轴(水平)方向间距
            runSpacing: 4.0,
            // 纵轴（垂直）方向间距
            alignment: WrapAlignment.center,
            //沿主轴方向居中
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              ElevatedButton(
                child: const Text("Flutter widgets demo"),
                onPressed: () {
                  //导航到新路由
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return NewRoute();
                    }),
                  );
                },
              ),
              ElevatedButton(
                child: const Text("Download and show"),
                onPressed: () {
                  print("loading");
                  request();
                },
              ),
              Text("$textToShow"),
              ElevatedButton(
                child: const Text("Save"),
                onPressed: () {
                  print("save");
                  testSave();

                },
              ),
              ElevatedButton(
                child: const Text("Load"),
                onPressed: () {
                  print("load");
                  testLoad();

                },
              ),
            ],
          ),
        )
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
