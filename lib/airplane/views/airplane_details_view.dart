import 'package:flutter/material.dart';
import '../models/airplane.dart';
import '../services/airplane_service.dart';
import 'airplane_edit_view.dart';




/// A view for displaying details of a specific airplane.
class AirplaneDetailsPage extends StatefulWidget {
  final AirplaneService airplaneService;
  final int airplaneId;
  final VoidCallback onAirplaneUpdated;

  /// Constructor for AirplaneDetailsPage, requires an instance of AirplaneService, airplane ID, and a callback.
  AirplaneDetailsPage({
    required this.airplaneService,
    required this.airplaneId,
    required this.onAirplaneUpdated,
  });

  @override
  _AirplaneDetailsPageState createState() => _AirplaneDetailsPageState();
}

class _AirplaneDetailsPageState extends State<AirplaneDetailsPage> {
  Airplane? _airplane;

  @override
  void initState() {
    super.initState();
    _loadAirplane();
  }

  /// Loads the airplane details from the database.
  void _loadAirplane() {
    widget.airplaneService.getAirplaneById(widget.airplaneId).then((airplane) {
      setState(() {
        _airplane = airplane;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_airplane?.type ?? 'Airplane Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              if (_airplane != null) {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AirplaneEditView(
                      airplane: _airplane!,
                      airplaneService: widget.airplaneService,
                      onAirplaneUpdated: widget.onAirplaneUpdated,
                    ),
                  ),
                );
                widget.onAirplaneUpdated();
              }
            },
          ),
        ],
      ),
      body: _airplane == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${_airplane!.type}'),
            Text('Passengers: ${_airplane!.numberOfPassengers}'),
            Text('Max Speed: ${_airplane!.maxSpeed} km/h'),
            Text('Range: ${_airplane!.range} km'),
          ],
        ),
      ),
    );
  }
}