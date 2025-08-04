import 'package:flutter/material.dart';
import 'flight_entity.dart';

/// Class FlightDetailPage is for portrait users, shows selected flight entity from FlightListPage
/// and allows for update or deletion.
class FlightDetailPage extends StatelessWidget {
  final FlightEntity flight;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  FlightDetailPage({
    required this.flight,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Details'),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.help_outline),
            label: Text('Instructions'),
            onPressed: () => _showInstructionsPopup(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Departure: ${flight.departureCity} -> Arrival: ${flight.arrivalCity}'),
            Text('Departure Time: ${DateTime.fromMillisecondsSinceEpoch(flight.departureTime)}'),
            Text('Arrival Time: ${DateTime.fromMillisecondsSinceEpoch(flight.arrivalTime)}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onUpdate,
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: onDelete,
              child: Text('Delete'),
            ),
          ],
        ),
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
          'This Page Is Used To Update The Selected Flight Between Two Cities. Arrival Date Cannot Be Earlier Than Departure Date.',
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
}