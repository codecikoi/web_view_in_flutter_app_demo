import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


enum MenuOptions {
  clearCache,
  clearCookies,
}

class WebViewPageDemo extends StatefulWidget {
  const WebViewPageDemo({Key? key}) : super(key: key);

  @override
  State<WebViewPageDemo> createState() => _WebViewPageDemoState();
}

class _WebViewPageDemoState extends State<WebViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView Demo'),
        centerTitle: true,
        backgroundColor: Colors.black54,
        actions: [
          IconButton(
            onPressed: () async {},
            icon: Icon(Icons.arrow_back_ios),
          ),
          IconButton(
            onPressed: () async {},
            icon: Icon(Icons.arrow_forward_ios),
          ),
          IconButton(
            onPressed: () async {
              print('najal');
            },
            icon: Icon(Icons.replay),
          ),
        ],
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.next_plan,
          size: 32.0,
        ),
      ),
    );
  }
}
