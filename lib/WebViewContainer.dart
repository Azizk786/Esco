import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class WebViewContainer extends StatefulWidget {
  final url;
  final String strTitle;
  WebViewContainer(this.url,this.strTitle);
  @override
  createState() => _WebViewContainerState(this.url,this.strTitle);
}
class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final String strTitle;
  final _key = UniqueKey();
  num _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }
  _WebViewContainerState(this._url,this.strTitle);


  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(strTitle, style: TextStyle(fontFamily: 'Demi',),textAlign: TextAlign.center),
        ),
        body: IndexedStack(
          index: _stackToView,
          children: [
            Column(
              children: < Widget > [
                Expanded(
                    child: WebView(
                      key: _key,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: _url,
                      onPageFinished: _handleLoad,
                    )
                ),
              ],
            ),
            Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        )
    );
  }

}