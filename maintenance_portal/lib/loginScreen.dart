import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maintenance_portal/notification.dart';
import 'notification.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _user = TextEditingController();
  TextEditingController _password = TextEditingController();

  Future getData(String user, String password) async {
    var json = {"user": user, "pass": password};
    http.Response response = await http.post(
      "http://10.0.2.2:5000/login",
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(json),
    );
    var final_res = jsonDecode(response.body);
    return final_res["status"];
    // return final_res["status"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KAAR TECHNOLOGIES",
            // ignore: unnecessary_const
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontFamily: 'Mukta',
            )),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
                textTheme: TextTheme().apply(bodyColor: Colors.black),
                dividerColor: Colors.black,
                iconTheme: IconThemeData(color: Colors.white)),
            child: PopupMenuButton<int>(
              color: Colors.white,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                    value: 1,
                    child: Text("Privacy Policy page",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mukta',
                        ))),
                PopupMenuDivider(),
              ],
              onSelected: (item) => SelectedItem(context, item),
            ),
          ),
        ],
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // const SizedBox(height: 50),
                        Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.redAccent,
                              radius: 47,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: AssetImage("assets/kaar.jpg"),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "MAINTENANCE PORTAL LOGIN",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Mukta',
                                  color: Colors.black,
                                  fontSize: 23),
                            )
                          ],
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "User Id",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Mukta',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              // const SizedBox(height: 10),
                              Container(
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      const BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 6,
                                          offset: const Offset(0, 2))
                                    ]),
                                height: 60,
                                child: TextField(
                                  controller: _user,
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Mukta',
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefixIcon: Icon(
                                      Icons.account_circle_rounded,
                                      size: 35,
                                      color: Colors.redAccent,
                                    ),
                                    hintText: "User Id",
                                    hintStyle: TextStyle(
                                      fontFamily: 'Mukta',
                                      color: Colors.black38,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )
                            ]),
                        // const SizedBox(height: 10),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Password",
                                style: const TextStyle(
                                    fontFamily: 'Mukta',
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              // const SizedBox(height: 10),
                              Container(
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      const BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 6,
                                          offset: const Offset(0, 2))
                                    ]),
                                height: 60,
                                child: TextField(
                                  controller: _password,
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Mukta',
                                  ),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(top: 14),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.redAccent,
                                        size: 35,
                                      ),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontFamily: 'Mukta',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      )),
                                ),
                              )
                            ]),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () async {
                              showAlertDialog(context);
                              var user = _user.text;
                              var password = _password.text;
                              var status = await getData(user, password);
                              if (status == "SUCCESS") {
                                _user.text = "";
                                _password.text = "";
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.greenAccent,
                                  content: const Text(
                                    'SUCCESSFULLY LOGGED IN!',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    textColor: Colors.black,
                                    onPressed: () {
                                      // Some code to undo the change.
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar,
                                );

                                Navigator.popAndPushNamed(
                                    context, "/workorder");
                              } else {
                                Navigator.pop(context);
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.red,
                                  content: const Text(
                                    'LOGIN FAILED!',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Mukta',
                                        fontSize: 20),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    textColor: Colors.black,
                                    onPressed: () {
                                      // Some code to undo the change.
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar,
                                );
                              }
                              // getData(user, password);
                            },
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Colors.redAccent,
                            child: const Text(
                              "LOGIN",
                              style: TextStyle(
                                  fontFamily: 'Mukta',
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

void SelectedItem(BuildContext context, item) {
  switch (item) {
    case 1:
      print("Privacy Clicked");
      break;
  }
}

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(" Authenticating",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Mukta',
                ))),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
