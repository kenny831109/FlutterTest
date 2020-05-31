import 'dart:convert';
import 'dart:async';
import 'package:Test/krtcPage.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class Krtc {
  final String stationUID;
  final String stationID;
  final StationNameType stationName;
  final String stationAddress;
  final bool bikeAllowOnHoliday;

  Krtc(
      {this.stationID,
      this.stationUID,
      this.stationName,
      this.stationAddress,
      this.bikeAllowOnHoliday});

  factory Krtc.fromJson(Map<String, dynamic> json) {
    return Krtc(
      stationUID: json['StationUID'],
      stationID: json['StationID'],
      stationName: StationNameType.fromJson(json['StationName']),
      stationAddress: json['StationAddress'],
      bikeAllowOnHoliday: json['BikeAllowOnHoliday'],
    );
  }
}

class StationNameType {
  final String zhTw;
  final String en;
  StationNameType({this.en, this.zhTw});
  factory StationNameType.fromJson(Map<String, dynamic> json) {
    return StationNameType(
      zhTw: json['Zh_tw'],
      en: json['En'],
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var items = ["red", "blue", "green", "purple", "yellow", "grey", "white"];
  List<Krtc> searchItems;
  var searchController = TextEditingController();
  List<Krtc> krtcList;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchItems = krtcList
            .where((element) => (element.stationName.en.toLowerCase().contains(searchController.text, 0)) || element.stationName.zhTw.contains(searchController.text, 0))
            .toList();
      });
    });
    // fetchKrtcList();
    fetch();
  }

  Future fetch() async {
    var appid = '80f21ba6534b44f498d7b4488212067e';
    var appKey = utf8.encode('lyPRSXmBKG3t7ZZs-cp_u2HSRNg');
    DateTime now = Jiffy(DateTime.now()).add(hours: -8);
    String formattedDate = DateFormat('EEE, dd MMM yyyy HH:mm:ss').format(now);
    String signDate = "x-date: $formattedDate GMT";
    // String signDate = "x-date: Sun, 31 May 2020 10:44:23 GMT";
    var bytes = utf8.encode(signDate);
    var test = Hmac(sha1, appKey).convert(bytes);
    var base64 = base64Encode(test.bytes);
    print(base64);
    var authorization = "hmac username=\"$appid\", algorithm=\"hmac-sha1\", headers=\"x-date\", signature=\"$base64\"";
    print(authorization);
    var url = 'https://ptx.transportdata.tw/MOTC/v2/Rail/Metro/Station/KRTC';
    var uri = Uri.parse(url);
    var params = {
      "format": "JSON",
    };
    var newUri = uri.replace(queryParameters: params);
    var res = await http.get(newUri, headers: {
      "Authorization": "$authorization",
      "Accept-Encoding": "gzip",
      "x-date": "$formattedDate GMT"
    });
    var list = (json.decode(res.body) as List)
          .map((i) => Krtc.fromJson(i))
          .toList();
    setState(() {
      krtcList = list;
      searchItems = list;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("捷運資訊"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              height: 50.0,
              child: TextField(
                controller: searchController,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '請輸入關鍵字...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: searchItems == null ? 0 : searchItems.length,
              padding: EdgeInsets.all(20),
              itemBuilder: (context, index) {
                return Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 1.0,
                  child: ListTile(
                    leading: Icon(Icons.train),
                    title: Text(searchItems[index].stationName.zhTw),
                    subtitle: Text(searchItems[index].stationName.en),
                    trailing: Icon(Icons.arrow_forward_ios),
                    contentPadding: EdgeInsets.all(20),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => KRTCPage(searchItems[index])));
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 10.0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
