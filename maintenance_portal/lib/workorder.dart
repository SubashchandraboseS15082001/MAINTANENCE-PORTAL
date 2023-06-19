import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'notification.dart';

class WorkOrder extends StatefulWidget {
  const WorkOrder({Key? key}) : super(key: key);

  @override
  State<WorkOrder> createState() => _WorkOrderState();
}

enum SampleItem { Logout }

Future<List> getData() async {
  http.Response response = await http.post(
    "http://10.0.2.2:5000/workorder",
    headers: {"Content-Type": "application/json"},
    body: "",
  );
  var final_res = jsonDecode(response.body);
  return final_res["_return"];
}

class _WorkOrderState extends State<WorkOrder> {
  @override
  Widget build(BuildContext context) {
    SampleItem? selectedMenu;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "WORK ORDER LIST",
          style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 25,
              color: Colors.white,
              fontFamily: 'Mukta'),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () async {
              Navigator.popAndPushNamed(context, "/notification");
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
                      "ORDER ID : ${num.parse(data[index]['ORDERID'].toString()).toInt()}",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          fontFamily: 'Mukta'),
                    ),
                    subtitle: Text(
                      "DESCRIPTION : ${data[index]['DESCRIPTION']}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: 'Mukta'),
                    ),
                    children: [
                      Text(
                        "WORK CENTER : ${data[index]['WORK_CNTR']}",
                        style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        "CONTROL KEY : ${data[index]['CONTROL_KEY']}",
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
                        "ORDER_TYPE : ${data[index]['ORDER_TYPE']}",
                        style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ],
                    leading: Icon(
                      Icons.work,
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
