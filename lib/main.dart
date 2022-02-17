import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sahir_to_do_list/screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        )
      ),
      home: HomePage(),
    );
  }
}
