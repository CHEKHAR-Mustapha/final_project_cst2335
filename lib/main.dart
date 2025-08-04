import 'package:flutter/material.dart';
import 'flight_list_dao.dart';
import 'flight_list_db.dart';
import 'flight_list_page.dart';
import 'encrypted_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the databases
  final flightDatabase = await $FloorFlightDatabase.databaseBuilder('flight_database.db').build();
  final flightDao = flightDatabase.flightDao;

  // Initialize EncryptedPreferences
  final encryptedPrefs = EncryptedPreferences();

  runApp(MyApp(
    flightDao: flightDao,
    encryptedPrefs: encryptedPrefs,
  ));
}

class MyApp extends StatelessWidget {
  final FlightDao flightDao;
  final EncryptedPreferences encryptedPrefs;
  
  const MyApp({
    super.key,
    required this.flightDao,
    required this.encryptedPrefs
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airplane Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        flightDao: flightDao,
        encryptedPrefs: encryptedPrefs,
      ),
      routes: {
        '/homePage': (context) => MyApp(
          flightDao: flightDao,
          encryptedPrefs: encryptedPrefs,
        ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FlightDao flightDao;
  final EncryptedPreferences encryptedPrefs;

  const MyHomePage({
    super.key,
    required this.flightDao,
    required this.encryptedPrefs,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: _navigateToFlightListPage,
              icon: const Icon(Icons.flight),
              label: const Text('Go to Flight List Page'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToFlightListPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightListPage(
          flightDao: widget.flightDao,
          encryptedPrefs: widget.encryptedPrefs,
        ),
      ),
    );
  }

}