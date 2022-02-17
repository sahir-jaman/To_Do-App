import 'package:flutter/material.dart';
import 'package:sahir_to_do_list/models/task.dart';
import 'package:sahir_to_do_list/models/todo.dart';
import 'package:sahir_to_do_list/screens/database_helper.dart';
import 'package:sahir_to_do_list/screens/widgets.dart';

class Taskpage extends StatefulWidget {
  final Task task;
  Taskpage({@required this.task});
  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  String _taskTitle = "";
  int _taskId = 0;
  String _taskDescription = "";

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {

      // set visibility to true;
      _contentVisible = true;

      _taskTitle = widget.task.title;
      _taskId= widget.task.id;
      _taskDescription = widget.task.description;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                                image: AssetImage(
                                    "assets/images/back_arrow_icon.png")),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter Task Title..",
                            ),
                            style: TextStyle(fontSize: 23.0,color: Color(0xFF211551),fontWeight: FontWeight.bold),
                            focusNode: _titleFocus,
                              onSubmitted: (value) async {
                              //print("Field value is $value");

                              //check if the field is not empty
                              if (value != "") {
                                //check if the task is null
                                if (widget.task == null) {
                                  Task _newTask = Task(title: value);
                                  _taskId= await _dbHelper.insertTask(_newTask);
                                  print("New task has been created: $_taskId");
                                  setState(() {
                                    _contentVisible = true;
                                    _taskTitle= value;
                                  });
                                } else {
                                  _dbHelper.updateTaskTitile(_taskId,value);
                                  print("Task has been updated");
                                }
                                _descriptionFocus.requestFocus();
                              }
                            },
                            controller: TextEditingController()..text = _taskTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Container(
                      width: double.infinity,
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value)async{
                          // ignore: unrelated_type_equality_checks
                          if(value != 0){
                            // ignore: unrelated_type_equality_checks
                            if(_taskId != 0){
                              await _dbHelper.updateTaskDescription(_taskId, value);
                                  _taskDescription= value;
                            }
                            else{
                              print("nothing");
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        controller: TextEditingController()..text = _taskDescription,
                        decoration: InputDecoration(
                          hintText: "Enter Description for this task..",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 30),
                        ),
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodo(_taskId),
                      builder: (context,AsyncSnapshot snapshot){
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: ()async{
                                   if(snapshot.data[index].isDone==0){
                                    await _dbHelper.updateTodoDone(snapshot.data[index].id, 1);
                                   }else{
                                    await _dbHelper.updateTodoDone(snapshot.data[index].id, 0);
                                   }
                                   setState(() {});
                                },
                                child: TodoWidget(
                                  text: snapshot.data[index].title,
                                 isDone: snapshot.data[index].isDone == 0 ? false : true,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              child: Image(
                                  image:
                                      AssetImage("assets/images/check_icon.png")),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: Color(0xFF86829D),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController()..text = "",
                              onSubmitted: (value) async {
                                if (value != "") {
                                  //check if the task is null
                                  if (_taskId != 0) {
                                    DatabaseHelper _dbHelper = DatabaseHelper();
                                    Todo _newTodo = Todo(
                                      title: value,
                                      taskId: _taskId,
                                      isDone: 0,
                                    );
                                    await _dbHelper.insertTodo(_newTodo);
                                    print("new todo created");
                                    setState(() {});
                                    _todoFocus.requestFocus();
                                  } else {
                                    print("No todo created ");
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter Todo item",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async{
                      if(_taskId != 0){
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Image(
                        image: AssetImage("assets/images/delete_icon.png"),
                        height: 68,
                        width: 68,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
