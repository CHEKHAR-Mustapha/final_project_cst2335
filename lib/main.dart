import 'package:final_project_cst2335/reservation_dao.dart';
import 'package:final_project_cst2335/reservation_db.dart';
import 'package:flutter/material.dart';
import 'CustomerListPage.dart';
import 'flight_list_dao.dart';
import 'flight_list_db.dart';
import 'flight_list_page.dart';
import 'encrypted_preferences.dart';
import 'package:final_project_cst2335/airplane/initializers/database_initializer.dart';
import 'package:final_project_cst2335/airplane/services/airplane_service.dart';
import 'package:final_project_cst2335/airplane/views/airplane_responsive_view.dart';
import 'package:final_project_cst2335/airplane/services/reservation_service.dart';
import 'package:final_project_cst2335/airplane/repositories/reservation_repository.dart';
import 'package:final_project_cst2335/airplane/services/reservation_service.dart';

import 'reservation_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the databases
  final flightDatabase = await $FloorFlightDatabase.databaseBuilder('flight_database.db').build();
  final flightDao = flightDatabase.flightDao;

  final reservationDatabase = await $FloorReservationDatabase.databaseBuilder('reservation_database.db').build();
  final reservationDao = reservationDatabase.reservationDao;
  final reservationRepository = ReservationRepository(reservationDao);
  final reservationService = ReservationService(reservationDao);
  // Initialize EncryptedPreferences
  final encryptedPrefs = EncryptedPreferences();

  // Initialize AirplaneService
  final airplaneService = await DatabaseInitializer.initializeAirplaneService();

  runApp(MyApp(
    flightDao: flightDao,
    encryptedPrefs: encryptedPrefs,
    airplaneService: airplaneService,
    reservationDao: reservationDao,
    reservationService: reservationService,
  ));
}

class MyApp extends StatelessWidget {
  final FlightDao flightDao;
  final EncryptedPreferences encryptedPrefs;
  final AirplaneService airplaneService;
  final ReservationDao reservationDao;
  final ReservationService reservationService;


  const MyApp({
    super.key,
    required this.flightDao,
    required this.encryptedPrefs,
    required this.airplaneService,
    required this.reservationDao,
    required this.reservationService,
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
        airplaneService: airplaneService,
        reservationDao: reservationDao,
        reservationService: reservationService,
      ),
      routes: {
        '/customerList': (context) => const CustomerListPage(),
        '/homePage': (context) => MyApp(
          flightDao: flightDao,
          encryptedPrefs: encryptedPrefs,
          airplaneService: airplaneService,
          reservationDao: reservationDao,
          reservationService: reservationService,
        ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
final FlightDao flightDao;
final EncryptedPreferences encryptedPrefs;
final AirplaneService airplaneService;
final ReservationDao reservationDao;
final ReservationService reservationService; // ✅ Add this line

const MyHomePage({
super.key,
required this.flightDao,
required this.encryptedPrefs,
required this.airplaneService,
required this.reservationDao,
required this.reservationService, // ✅ And this
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
            ElevatedButton.icon(
              onPressed: _navigateToCustomerListPage,
              icon: const Icon(Icons.people),
              label: const Text('Go to Customer List Page'),
            ),
            ElevatedButton.icon(
              onPressed: _navigateToAirplanePage,
              icon: const Icon(Icons.airplanemode_active),
              label: const Text('Go to Airplane Management'),
            ),
            ElevatedButton.icon(
              onPressed: _navigateToReservationPage,
              icon: const Icon(Icons.book_online),
              label: const Text('Go to Reservation Page'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCustomerListPage() {
    Navigator.pushNamed(context, '/customerList');
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

  void _navigateToAirplanePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AirplaneResponsiveView(
          airplaneService: widget.airplaneService,
        ),
      ),
    );
  }

  void _navigateToReservationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationListPage(
          reservationDao: widget.reservationDao,
          encryptedPrefs: widget.encryptedPrefs,
          reservationService: widget.reservationService, // ✅ ADD THIS LINE
        ),
      ),
    );
  }
}
