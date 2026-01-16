import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yotei/class_database.dart';
import 'package:yotei/class_variable.dart';
import 'package:yotei/class_method.dart';
import 'package:yotei/class_noti.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late Database subjectDB;

  @override
  void initState() {
    super.initState();
    initDB();
  }

  Future<void> initDB() async {
    subjectDB = await initSubjectDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('科目登録')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //◎テキストの入力フォーム
          TextField(
            decoration: InputDecoration(labelText: '科目名'),
            onChanged: (String value) {
              setState(() {
                subject['title'] = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: '教室名'),
            onChanged: (String value) {
              setState(() {
                // データを変更
                subject['classroom'] = value;
              });
            },
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            dropdownColor: Color.fromARGB(255, 213, 237, 245),
            value: subject['day'],
            menuWidth: double.infinity,
            onChanged: (String? value) {
              setState(() {
                subject['day'] = value!;
              });
            },
            items:
                day.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('曜日：$value'),
                  );
                }).toList(),
          ),
          
          const SizedBox(height: 10),
          //時限を入力するフォーム
          /*
          枠を付ける
          Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
          */
          DropdownButton<int>(
            dropdownColor: Color.fromARGB(255, 213, 237, 245),
            //現在選択されている項目の値
            value: subject['period'],
            menuWidth: double.infinity,
            onChanged: (int? value) {
              setState(() {
                subject['period'] = value!;
                debugPrint('調べたい値$hour[value-1]');
                subject['hour'] = hour[value - 1];
                subject['minute'] = minute[value - 1];
              });
            },
            items:
                period.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    //value：選択した場合にonchangedに渡す引数
                    value: value,
                    child: Text('時限：$value'),
                  );
                }).toList(),
          ),
          
          const SizedBox(height: 30),
          //@登録ボタン
          ElevatedButton(
            onPressed: () async {
              subject['id'] = await getId(subject['day'], subject['period']);
              subject['place'] = await getPlace(subject['classroom']);
              await insertSubject(subjectDB, subject);
              setNoti(subject);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(minimumSize: Size(250, 50)),
            child: Text('科目を登録', style: TextStyle(color: Colors.black)),
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
          /*
          ElevatedButton(
            onPressed: () async {
              deleteAllNoti();
            },
            child: Text("通知を全て削除する"),
          ),
          ElevatedButton(
            onPressed: () async {
              checkNoti();
            },
            child: Text("通知を確認する"),
          ),
          */
        ],
      ),
    );
  }
}
