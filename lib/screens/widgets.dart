import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget{

  final String title;
  final String desc;
  TaskCardWidget({this.title,this.desc});

  @override
  Widget build (BuildContext context){
    return Container(
     width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 25),
      margin: EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title ?? "Unnamed task",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22),),
          SizedBox(height: 5.0,),
          Text(desc ?? "No Description Added"),
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {

  final String text;
  final bool isDone;
  TodoWidget({this.text,this.isDone});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20,bottom: 10),
        child: Row(
          children: [
            Container(
                child: Image(image: AssetImage("assets/images/check_icon.png")),
              width: 20,height: 20,
              decoration: BoxDecoration(
                color: isDone ? Color(0xFF7349FE) : Colors.transparent ,
                borderRadius: BorderRadius.circular(5.0),
                border: isDone? null : Border.all(
                  color: Color(0xFF86829D),
                )
              ),
            ),
            SizedBox(width: 5.0,),
            Flexible(child: Text(text ?? "Unnamed Todo",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),)),
          ],
        ),
      ),
    );
  }
}
