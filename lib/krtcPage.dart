import 'package:flutter/material.dart';
import 'card.dart';
import 'home.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:convert';
import 'dart:async';

class LiveBoard {
  final String lineNO;
  final String lineID;
  final StationNameType lineName;
  final String stationID;
  final StationNameType stationName;
  final String tripHeadSign;
  final String destinationStaionID;
  final StationNameType destinationStationName;
  final int estimateTime;
  final String srcUpdateTime;
  final String updateTime;

  LiveBoard(
      {this.lineNO,
      this.lineID,
      this.lineName,
      this.stationID,
      this.stationName,
      this.tripHeadSign,
      this.destinationStaionID,
      this.destinationStationName,
      this.estimateTime,
      this.srcUpdateTime,
      this.updateTime});

  factory LiveBoard.fromJson(Map<String, dynamic> json) {
    return LiveBoard(
      lineNO: json['LineNO'],
      lineID: json['LineID'],
      lineName: StationNameType.fromJson(json['LineName']),
      stationID: json['StationID'],
      stationName: StationNameType.fromJson(json['StationName']),
      tripHeadSign: json['TripHeadSign'],
      destinationStaionID: json['DestinationStaionID'],
      destinationStationName: StationNameType.fromJson(json['DestinationStationName']),
      estimateTime: json['EstimateTime'],
      srcUpdateTime: json['SrcUpdateTime'],
      updateTime: json['UpdateTime'],
    );
  }
}

class KRTCPage extends StatefulWidget {
  final Krtc station;
  KRTCPage(this.station);

  @override
  _KRTCPageState createState() => _KRTCPageState();
}

class _KRTCPageState extends State<KRTCPage> {

  List<LiveBoard> liveBoards;

  @override
  void initState() {
    super.initState();
    fetchLiveBoard();
  }

  Future fetchLiveBoard() async {
    var appid = '80f21ba6534b44f498d7b4488212067e';
    var appKey = utf8.encode('lyPRSXmBKG3t7ZZs-cp_u2HSRNg');
    DateTime now = Jiffy(DateTime.now()).add(hours: -8);
    String formattedDate = DateFormat('EEE, dd MMM yyyy HH:mm:ss').format(now);
    String signDate = "x-date: $formattedDate GMT";
    var bytes = utf8.encode(signDate);
    var test = Hmac(sha1, appKey).convert(bytes);
    var base64 = base64Encode(test.bytes);
    print(base64);
    var authorization = "hmac username=\"$appid\", algorithm=\"hmac-sha1\", headers=\"x-date\", signature=\"$base64\"";
    print(authorization);
    var url = 'https://ptx.transportdata.tw/MOTC/v2/Rail/Metro/LiveBoard/KRTC';
    var uri = Uri.parse(url);
    var stationID = widget.station.stationID;
    var params = {
      "format": "JSON",
      "\$filter": "StationID eq '$stationID'"
    };
    var newUri = uri.replace(queryParameters: params);
    var res = await http.get(newUri, headers: {
      "Authorization": "$authorization",
      "Accept-Encoding": "gzip",
      "x-date": "$formattedDate GMT"
    });
    var list = (json.decode(res.body) as List)
          .map((i) => LiveBoard.fromJson(i))
          .toList();
    setState(() {
      liveBoards = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.stationName.zhTw),
      ),
      body: liveBoards != null ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ShadowCard(liveBoards.first),
          ShadowCard(liveBoards[1])
        ],
      ) : Center(child: Container(child: Text('暫無資料...'),))
    );
  }
}
