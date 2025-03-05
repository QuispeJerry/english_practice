import 'package:flutter/material.dart';
import 'views/FolderListScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Vocabulary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF000000), // Fondo negro sólido
        primaryColor: Color(0xFF1E3E62),            // Color primario para bloques
        cardColor: Color(0xFF1E3E62),               // Color de los Card
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1E3E62),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,    // Color blanco para textos
              displayColor: Colors.white,
            ),
      ),
      home: FolderListScreen(),
    );
  }
}
