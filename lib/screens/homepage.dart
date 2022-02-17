import 'package:flutter/material.dart';
import 'package:sahir_to_do_list/screens/database_helper.dart';
import 'package:sahir_to_do_list/screens/taskpage.dart';
import 'package:sahir_to_do_list/screens/widgets.dart';
import 'package:sqflite/sqlite_api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 30.0,
          ),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 1.0),
                      child: Image(
                        image: AssetImage("assets/images/logo.png"),
                      )),
                  Expanded(
                      child: FutureBuilder(
                    initialData: [],
                    future: _dbHelper.getTasks(),
                    builder: (context, AsyncSnapshot snapshot) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Taskpage(
                                          task: snapshot.data[index],
                                        )),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            child: TaskCardWidget(
                              title: snapshot.data[index].title,
                              desc: snapshot.data[index].description,
                            ),
                          );
                        },
                      );
                    },
                  )),
                ],
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Taskpage(
                                  task: null,
                                ))).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Image(
                      image: AssetImage("assets/images/add_icon.png"),
                      height: 68,
                      width: 68,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
