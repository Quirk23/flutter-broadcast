import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _localRenderer = new RTCVideoRenderer();
  final _localRenderer2 = new RTCVideoRenderer();

  MediaStream _localStream;
  @override
  dispose() {
    _localStream.dispose();
    _localRenderer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initRenderers();
    _getUserMedia();
    super.initState();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _localRenderer2.initialize();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'mandatory': {
          // 'Width': '200',
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '200',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      },
    };

    _localStream = await navigator.getUserMedia(mediaConstraints);

    _localRenderer.srcObject = _localStream;
    _localRenderer2.srcObject = _localStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Row(
            children: [
              Container(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: 640,
                  height: 480,
                  child: RTCVideoView(_localRenderer, mirror: true),
                  decoration: BoxDecoration(color: Colors.black54),
                ),
              ),
              Container(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: 640,
                  height: 480,
                  child: RTCVideoView(_localRenderer2, mirror: true),
                  decoration: BoxDecoration(color: Colors.black54),
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          );
        },
      ),
    );
  }
}
