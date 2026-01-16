import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yotei/sonota_database.dart';
import 'package:yotei/sonota_variable.dart';
import 'package:yotei/sonota_widget.dart';
import 'package:yotei/sonota_noti.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class AddSonotaScreen extends StatefulWidget {
  @override
  _AddSonotaScreenState createState() => _AddSonotaScreenState();
}

class _AddSonotaScreenState extends State<AddSonotaScreen> {
  late Database sonotaDB;

  @override
  void initState() {
    super.initState();
    initDB();
  }

  Future<void> initDB() async {
    sonotaDB = await initSonotaDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('その他の予定登録')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //◎テキストの入力フォーム
          TextField(
            decoration: InputDecoration(labelText: 'タイトル'),
            onChanged: (String value) {
              setState(() {
                sonota['title'] = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'メモ'),
            onChanged: (String value) {
              setState(() {
                sonota['memo'] = value;
              });
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minTime: DateTime(2025, 1, 1, 0, 0),
                maxTime: DateTime(2028, 12, 31, 23, 59),
                onChanged: (date) {},
                onConfirm: (date) {
                  print('confirm $date ${date.year}');
                  setState(() {
                    sonota['year'] = date.year;
                    sonota['month'] = date.month;
                    sonota['day'] = date.day;
                    pickerLabel[0] =
                        '年月日を選択(${sonota['year']}年${sonota['month']}月${sonota['day']}日)';
                  });
                },
                currentTime: DateTime.now(),
                locale: LocaleType.jp,
              );
            },
            //表示するウィジェット
            child: Text(pickerLabel[0], style: TextStyle(color: Colors.blue)),
          ),

          TextButton(
            onPressed: () {
              DatePicker.showPicker(
                context,
                showTitleActions: true,
                onChanged: (date) {},
                onConfirm: (date) {
                  setState(() {
                    sonota['hour'] = date.hour;
                    sonota['minute'] = date.minute;
                    pickerLabel[1] =
                        '時間を選択(${sonota['hour']}時${sonota['minute']}分)';
                  });
                },
                pickerModel: CustomPicker(currentTime: DateTime.now()),
                locale: LocaleType.jp,
              );
            },
            child: Text(pickerLabel[1], style: TextStyle(color: Colors.blue)),
          ),
          const SizedBox(height: 30),
          //@登録ボタン
          ElevatedButton(
            onPressed: () async {
              pickerLabel[0] = "年月日を選択";
              pickerLabel[1] = "時分を選択";
              sonota['id'] =
                  sonota['year'].toString().substring(3) +
                  sonota['month'].toString().padLeft(2, '0') +
                  sonota['day'].toString().padLeft(2, '0') +
                  sonota['hour'].toString().padLeft(2, '0') +
                  sonota['minute'].toString().padLeft(2, '0');
              debugPrint(sonota['id']);
              await insertSonota(sonotaDB, sonota);
              setNoti(sonota);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(minimumSize: Size(250, 50)),
            child: Text('予定を登録', style: TextStyle(color: Colors.black)),
          ),

          const SizedBox(height: 20),
          //土台ウィジェット  @取消ボタン
          Container(
            width: 250,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('キャンセル'),
            ),
          ),
        ],
      ),
    );
  }
}
