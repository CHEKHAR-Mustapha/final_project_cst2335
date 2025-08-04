import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'flight_details_page.dart';
import 'flight_entity.dart';
import 'flight_list_dao.dart';
import 'encrypted_preferences.dart';

///Class flight list page is a page containing a listView builder that obtains flight data from database and allows for addition, deletion and updating flights.
class FlightListPage extends StatefulWidget {
  ///DAO For Flight Entity
  final FlightDao flightDao;
  final EncryptedPreferences encryptedPrefs;

  FlightListPage({Key? key, required this.flightDao, required this.encryptedPrefs}) : super(key: key);

  @override
  _FlightListPageState createState() => _FlightListPageState();
}

class _FlightListPageState extends State<FlightListPage> {
  //text controllers
  final TextEditingController _departureCityController = TextEditingController();
  final TextEditingController _arrivalCityController = TextEditingController();
  final TextEditingController _departureDateController = TextEditingController();
  final TextEditingController _arrivalDateController = TextEditingController();
  DateTime? _selectedDepartureDate;
  DateTime? _selectedArrivalDate;
  late Future<List<FlightEntity>> _flightsFuture;
  ///Field is to track and display seslected flight when in landscape mode
  FlightEntity? _selectedFlight;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _flightsFuture = widget.flightDao.findAllFlights();
  }

  ///Method to grab encrypted preferences for flight cities
  Future<void> _loadPreferences() async {
    final departureCity = await widget.encryptedPrefs.getLastDepartureCity();
    final arrivalCity = await widget.encryptedPrefs.getLastArrivalCity();

    setState(() {
      _departureCityController.text = departureCity ?? '';
      _arrivalCityController.text = arrivalCity ?? '';
    });
  }

  ///Method that shows a calendar and allows user to select a date
  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _selectedDepartureDate = picked;
          _departureDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _selectedArrivalDate = picked;
          _arrivalDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  ///Adds flight to database if values are valid
  Future<void> _addFlight() async {
    final String departureCity = _departureCityController.text;
    final String arrivalCity = _arrivalCityController.text;
    if (departureCity.isEmpty || arrivalCity.isEmpty || _selectedDepartureDate == null || _selectedArrivalDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return;
    }
    if (_selectedArrivalDate!.isBefore(_selectedDepartureDate!)){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arrival date cannot come before Departure date.')
        ),
      );
      return;
    }
    final int departureTime = _selectedDepartureDate!.millisecondsSinceEpoch;
    final int arrivalTime = _selectedArrivalDate!.millisecondsSinceEpoch;
    ///New flight to be added
    final flight = FlightEntity(
      null, // Assuming `id` is auto-incremented
      departureCity,
      arrivalCity,
      departureTime,
      arrivalTime,
    );
    await widget.flightDao.insertFlight(flight);
    // Save input to encrypted preferences
    await widget.encryptedPrefs.saveLastDepartureCity(departureCity);
    await widget.encryptedPrefs.saveLastArrivalCity(arrivalCity);
    ///Clear the input fields
    _departureCityController.clear();
    _arrivalCityController.clear();
    _departureDateController.clear();
    _arrivalDateController.clear();
    setState(() {
      _selectedDepartureDate = null;
      _selectedArrivalDate = null;
      _flightsFuture = widget.flightDao.findAllFlights(); // Reload the list of flights
    });
  }

  ///Deletes selected flight
  Future<void> _deleteFlight(FlightEntity flight) async {
    await widget.flightDao.deleteFlight(flight);
    setState(() {
      _flightsFuture = widget.flightDao.findAllFlights(); // Reload the list of flights
    });
  }

  ///Updates selected flight with New values
  Future<void> _updateFlight(FlightEntity flight) async {
    final String departureCity = _departureCityController.text;
    final String arrivalCity = _arrivalCityController.text;
    final int departureTime = _selectedDepartureDate!.millisecondsSinceEpoch;
    final int arrivalTime = _selectedArrivalDate!.millisecondsSinceEpoch;
    if (_selectedArrivalDate!.isBefore(_selectedDepartureDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Arrival date cannot be earlier than departure date'),
        ),
      );
      return;
    }

    final updatedFlight = FlightEntity(
      flight.id,
      departureCity,
      arrivalCity,
      departureTime,
      arrivalTime,
    );

    await widget.flightDao.updateFlight(updatedFlight);
    setState(() {
      _flightsFuture = widget.flightDao.findAllFlights(); // Reload the list of flights
    });
  }

  ///Shows flight details, if Media Query shows that app is in portrait mode details page is called
  void _showFlightDetailsPage(FlightEntity flight) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // If height is greater than width
    final isPortrait = screenHeight > screenWidth;

    if (isPortrait) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlightDetailPage(
            flight: flight,
            onDelete: () async {
              await _deleteFlight(flight);
              Navigator.pop(context); // Return to the previous page after deleting
            },
            onUpdate: () {
              _showUpdateFlightDialog(flight);
            },
          ),
        ),
      );
    } else {
      // Handle landscape mode by updating the state
      setState(() {
        _selectedFlight = flight;
      });
    }
  }

  ///Pop-up for landscape, Allows user to choose between updating and deleting selected flight
  void _showUpdateFlightDialog(FlightEntity flight) {
    _departureCityController.text = flight.departureCity;
    _arrivalCityController.text = flight.arrivalCity;
    _selectedDepartureDate = DateTime.fromMillisecondsSinceEpoch(flight.departureTime);
    _selectedArrivalDate = DateTime.fromMillisecondsSinceEpoch(flight.arrivalTime);
    _departureDateController.text = DateFormat('yyyy-MM-dd').format(_selectedDepartureDate!);
    _arrivalDateController.text = DateFormat('yyyy-MM-dd').format(_selectedArrivalDate!);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Flight'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _departureCityController,
              decoration: InputDecoration(labelText: 'Departure City'),
            ),
            TextField(
              controller: _arrivalCityController,
              decoration: InputDecoration(labelText: 'Arrival City'),
            ),
            TextField(
              controller: _departureDateController,
              decoration: InputDecoration(
                labelText: 'Departure Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, true),
                ),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, true),
            ),
            TextField(
              controller: _arrivalDateController,
              decoration: InputDecoration(
                labelText: 'Arrival Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false),
                ),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, false),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _updateFlight(flight);
              Navigator.of(context).pop(); // Close the dialog after updating
            },
            child: Text('Confirm'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Function to show instructions popup with plain text and OK button to return
  void _showInstructionsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Instructions'),
        content: Text(
          'This Page Is Used To Update The Selected Flight Between Two Cities. Please Ensure That All Fields Are Filled Out. Arrival Date Cannot Be Earlier Than Departure Date.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Flight List'),
            Row(
              children: [
                TextButton.icon(
                  icon: Icon(Icons.help_outline),
                  label: Text('Instructions'),
                  onPressed: () => _showInstructionsPopup(context),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: isPortrait ? 1 : 2,
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<FlightEntity>>(
                    future: _flightsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      //Find flights
                      final flights = snapshot.data ?? [];
                      //show no flights
                      if (flights.isEmpty) {
                        return Center(child: Text('No flights available.'));
                      }

                      return ListView.builder(
                        itemCount: flights.length,
                        itemBuilder: (context, index) {
                          final flight = flights[index];
                          return ListTile(
                            title: Text('${flight.departureCity} -> ${flight.arrivalCity}'),
                            subtitle: Text('Departure: ${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(flight.departureTime))} - Arrival: ${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(flight.arrivalTime))}'),
                            onTap: () {
                              _showFlightDetailsPage(flight);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _showAddFlightPopup,
                    icon: Icon(Icons.airplanemode_active),
                    label: Text('New Flight?'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isPortrait && _selectedFlight != null) // Display flight details in landscape mode
            Expanded(
              flex: 2,
              child: FlightDetailPage(
                flight: _selectedFlight!,
                onDelete: () async {
                  await _deleteFlight(_selectedFlight!);
                  setState(() {
                    _selectedFlight = null; // Clear selection after deletion
                  });
                },
                onUpdate: () {
                  _showUpdateFlightDialog(_selectedFlight!);
                },
              ),
            ),
        ],
      ),
    );
  }

  ///Shows pop-up with textfields for user to fill when they want to add a new flight
  void _showAddFlightPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Flight'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _departureCityController,
              decoration: InputDecoration(labelText: 'Departure City'),
            ),
            TextField(
              controller: _arrivalCityController,
              decoration: InputDecoration(labelText: 'Arrival City'),
            ),
            TextField(
              controller: _departureDateController,
              decoration: InputDecoration(
                labelText: 'Departure Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, true),
                ),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, true),
            ),
            TextField(
              controller: _arrivalDateController,
              decoration: InputDecoration(
                labelText: 'Arrival Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false),
                ),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, false),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _addFlight,
            child: Text('Add Flight'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}