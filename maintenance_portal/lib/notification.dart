import 'package:flutter/material.dart';
import 'workorder.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({Key? key}) : super(key: key);

  @override
  State<NotifyScreen> createState() => _NotifyScreenState();
}

enum SampleItem { Logout }

Future<List> getData() async {
  http.Response response = await http.post(
    "http://10.0.2.2:5000/notification",
    headers: {"Content-Type": "application/json"},
    body: "",
  );
  var final_res = jsonDecode(response.body);
  return final_res["_return"];
}

class _NotifyScreenState extends State<NotifyScreen> {
  @override
  Widget build(BuildContext context) {
    SampleItem? selectedMenu;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_left_rounded,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.popAndPushNamed(context, "/workorder");
                });
          },
        ),
        title: Text(
          "NOTIFICATIONS",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.work,
              color: Colors.white,
            ),
            onPressed: () async {
              Navigator.popAndPushNamed(context, "/workorder");
            },
          ),
          PopupMenuButton<SampleItem>(
            initialValue: selectedMenu,
            // Callback that sets the selected popup menu item.
            onSelected: (SampleItem item) {
              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
              PopupMenuItem<SampleItem>(
                value: SampleItem.Logout,
                child: Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                onTap: () => Future.delayed(Duration.zero, () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/login", (route) => false);
                }),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data as List;
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text(
                      "NOTIFICATION : ${num.parse(data[index]['NOTIFICAT'].toString()).toInt()}",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          fontFamily: 'Mukta'),
                    ),
                    subtitle: Text(
                      "DESCRIPTION : ${data[index]['DESCRIPT']}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: 'Mukta'),
                    ),
                    children: [
                      Text(
                        "NOTIFICATION TYPE : ${data[index]['NOTIF_TYPE']}",
                        style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        "FUNC LOC DES : ${data[index]['FUNCLDESCR']}",
                        style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        "STATUS : ${data[index]['S_STATUS']}",
                        style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        "NOTIFICATION DATE : ${data[index]['NOTIFDATE']}",
                        style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        "NOTIFICATION TIME : ${data[index]['NOTIFTIME']}",
                        style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ],
                    leading: Icon(
                      Icons.notifications_active,
                      color: Colors.redAccent,
                    ),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.centerLeft,
                    childrenPadding: EdgeInsets.all(20),
                  );
                },
                itemCount: data.length,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          future: getData(),
        ),
      ),
    );
  }
}
