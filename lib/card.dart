import 'package:Test/krtcPage.dart';
import 'package:flutter/material.dart';

class ShadowCard extends StatelessWidget {
  final LiveBoard liveBoard;
  ShadowCard(this.liveBoard);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text(
                liveBoard.stationName.zhTw,
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'OpenSans',
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                liveBoard.stationName.en,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'OpenSans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 10,
              ),
              Icon(
                Icons.arrow_downward,
                color: Colors.black,
                size: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                liveBoard.destinationStationName.zhTw,
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'OpenSans',
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                liveBoard.destinationStationName.en,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'OpenSans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                '預估到站時間: ' + liveBoard.estimateTime.toString() + ' 分鐘',
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'OpenSans',
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
