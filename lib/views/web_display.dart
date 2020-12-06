import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  String title;
  String url;

  WebPage({Key key, @required this.url, @required this.title})
      : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage>{

  String returnURL = 'return.example.com';
  String cancelURL= 'cancel.example.com';
  WebViewController _controller;
  bool isLoading=true;

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios, color: Colors.black87,),
              onTap: (){
                // widget.onFinish(null);
                Navigator.pop(context);
              }
          ),
          title: Text(widget.title, style: TextStyle(
            color: Colors.black87
          ),),
        ),
        body: Stack(
          children: [
            WebView(

              initialUrl: widget.url,
              // initialUrl: "http://mobileapitest.islamicly.com/Paypal/Checkout",
              // initialUrl: "https://www.sandbox.paypal.com/checkoutnow?locale.x=en_US&fundingSource=paypal&sessionID=4083b88994_mta6mzu6mtq&buttonSessionID=fe69b515e4_mta6mzu6mtq&env=sandbox&fundingOffered=paypal&logLevel=warn&sdkMeta=eyJ1cmwiOiJodHRwczovL3d3dy5wYXlwYWxvYmplY3RzLmNvbS9hcGkvY2hlY2tvdXQuanMifQ%3D%3D&uid=a230d729c3&version=4&token=EC-7W325709LB9728353&xcomponent=1",
              javascriptMode: JavascriptMode.unrestricted,
              gestureNavigationEnabled: true,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
              },
              onPageFinished: (_) {
                setState(() {
                  isLoading = false;
                });
                _controller.currentUrl().then(
                      (url) {
                        print("Url - ${url.toString()}");
                    if (url.contains("Success")) {
                      Navigator.of(context).pop({'status': "Success",});
                      // var token = url.split('recon?')[1];
                      // _prefs.setString('token', token);
                    }else if(url.contains("Failure")){
                      Navigator.of(context).pop({'status': "Fail",});
                    }
                        // _controller.clearCache();
                  },
                );
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.contains(returnURL)) {
              /*    final uri = Uri.parse(request.url);
                  final payerID = uri.queryParameters['PayerID'];
                  if (payerID != null) {
                    services
                        .executePayment(executeUrl, payerID, accessToken)
                        .then((id) {
                      widget.onFinish(id);
                      Navigator.of(context).pop();
                    });
                  } else {
                    widget.onFinish(null);
                    Navigator.of(context).pop();
                  }*/

                  Navigator.of(context).pop();
                }
                if (request.url.contains(cancelURL)) {
                  // widget.onFinish(null);
                  Navigator.of(context).pop();
                }
                return NavigationDecision.navigate;
              },
            ),
            isLoading ? Center( child: CircularProgressIndicator(),)
                : Stack(),
          ],
        ),
      );

  }
}