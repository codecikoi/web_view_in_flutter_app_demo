import 'dart:math';
import 'dart:developer';
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
  late WebViewController _webViewController;
  double progress = 0;

  late bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
        } else {
          print('нет истории в записи');
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('WebView Demo'),
          centerTitle: true,
          backgroundColor: Colors.black54,
          actions: [
            IconButton(
              onPressed: () async {
                if (await _webViewController.canGoBack()) {
                  _webViewController.goBack();
                } else {
                  print('нет истории в записи');
                }
                return;
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            IconButton(
              onPressed: () async {
                if (await _webViewController.canGoForward()) {
                  _webViewController.goForward();
                } else {
                  print('нет истории в записи');
                }
                return;
              },
              icon: Icon(Icons.arrow_forward_ios),
            ),
            IconButton(
              onPressed: () async {
                _webViewController.reload();
              },
              icon: Icon(Icons.replay),
            ),
            PopupMenuButton<MenuOptions>(
              onSelected: (value) {
                switch (value) {
                  case MenuOptions.clearCache:
                    _onClearCache(_webViewController, context);
                    break;
                  case MenuOptions.clearCookies:
                    _onClearCookies(context);
                    break;
                }
              },
              itemBuilder: (context) => <PopupMenuItem<MenuOptions>>[
                PopupMenuItem(
                  value: MenuOptions.clearCache,
                  child: Text('Clear cache'),
                ),
                PopupMenuItem(
                  value: MenuOptions.clearCookies,
                  child: Text('Clear cookies'),
                ),
              ],
            )
          ],
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              color: Colors.red,
              backgroundColor: Colors.black54,
            ),
            Expanded(
              child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: 'https://flutter.dev',
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onProgress: (progress) {
                  this.progress = progress / 100;
                  setState(() {});
                },
                onPageStarted: (url) {
                  print('new site $url');
                },
                onPageFinished: (url) {
                  print('page loaded');
                  if (url.contains('https://facebook.com/')) {
                    if (isSubmitting) {
                      _webViewController.loadUrl('https://m.facebook.com/');
                      isSubmitting = false;
                    }
                  }
                },
                navigationDelegate: (request) {
                  if (request.url.startsWith('https://m.youtube.com')) {
                    print('navigation is blocked for $request');
                    return NavigationDecision.prevent;
                  }
                  print('Navigation is allowed $request');
                  return NavigationDecision.navigate;
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            const email = '';
            const pass = '';

            _webViewController.runJavascriptReturningResult(
              "document.getElementById('m_login_email').value='$email'",
            );
            _webViewController.runJavascriptReturningResult(
              "document.getElementById('m_login_password').value='$pass'",
            );

            await Future.delayed(Duration(seconds: 1));

            isSubmitting = true;

            await _webViewController.runJavascriptReturningResult(
              "document.forms[0].submit()",
            );
          },
          child: Icon(
            Icons.next_plan,
            size: 32.0,
          ),
        ),
      ),
    );
  }

  void _onClearCookies(BuildContext context) async {
    final bool hadCookies = await CookieManager().clearCookies();
    String message = "Cookies was cleared";
    if (!hadCookies) {
      message = 'All cookies was cleared';
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onClearCache(WebViewController controller, BuildContext context) async {
    await _webViewController.clearCache();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cache was cleared'),
      ),
    );
  }
}
