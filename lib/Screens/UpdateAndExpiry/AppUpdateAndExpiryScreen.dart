import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';

class AppUpdateAndExpiryScreen extends StatelessWidget {
  final bool isAppExpire;

  const AppUpdateAndExpiryScreen({Key? key, required this.isAppExpire})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: isAppExpire ? Text("App Expire") : Text("App Update"),
            ),
            body: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.yellow,
                    size: 40,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  isAppExpire
                      ? Text(
                          "Your account has expired. Please contact your institute's administrator to have your access extended",
                          style: TextStyle(color: Colors.black, fontSize: 22),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        )
                      : Text(
                          "A New Update is Available Please update your app for new feature new module",
                          style: TextStyle(color: Colors.black, fontSize: 22),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  if (!isAppExpire)
                    RaisedButton(
                      child: Text(
                        "Update",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        StoreRedirect.redirect(
                            androidAppId: "com.example.elearning",
                            iOSAppId: "284882215");
                      },
                      textColor: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      color: Colors.blue,
                    )
                ],
              ),
            )));
  }
}
