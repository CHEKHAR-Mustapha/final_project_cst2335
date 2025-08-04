import 'package:final_project_cst2335/airplane/initializers/database_initializer.dart' show DatabaseInitializer;
import 'package:flutter/material.dart';
import 'package:final_project_cst2335/airplane/initializers/database_initializer.dart';
import 'package:final_project_cst2335/airplane/services/airplane_service.dart';
import 'package:final_project_cst2335/airplane/views/airplane_responsive_view.dart';

/// The entry point of the application.
/// Initializes the airplane service and starts the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final airplaneService = await DatabaseInitializer.initializeAirplaneService();

  runApp(MyApp(airplaneService: airplaneService));
}

/// The main widget of the application.
/// Sets up the MaterialApp and provides the airplane service to the home screen.
class MyApp extends StatelessWidget {
  final AirplaneService airplaneService;

  /// Constructor for MyApp, requires an instance of AirplaneService.
  MyApp({required this.airplaneService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airplane Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: AirplaneResponsiveView(airplaneService: airplaneService),
    );
  }
}