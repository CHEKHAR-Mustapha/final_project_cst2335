import 'package:flutter/material.dart';
import '../models/airplane.dart';
import '../services/airplane_service.dart';
import 'airplane_list_view.dart';
import 'airplane_details_view.dart';

/// A responsive view for managing airplanes, adjusting between list and detail views based on screen size.
class AirplaneResponsiveView extends StatefulWidget {
  final AirplaneService airplaneService;

  /// Constructor for AirplaneResponsiveView, requires an instance of AirplaneService.
  AirplaneResponsiveView({required this.airplaneService});

  @override
  _AirplaneResponsiveViewState createState() => _AirplaneResponsiveViewState();
}

class _AirplaneResponsiveViewState extends State<AirplaneResponsiveView> {
  Airplane? _selectedAirplane;

  /// Handles the selection of an airplane from the list.
  void _onAirplaneSelected(Airplane airplane) {
    setState(() {
      _selectedAirplane = airplane;
    });
  }

  /// Refreshes the airplane list when an airplane is updated.
  void _refreshAirplaneList() {
    setState(() {
      _selectedAirplane = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Airplane Management'),
      ),
      body: isMobile
          ? AirplaneListView(
        airplaneService: widget.airplaneService,
        onAirplaneSelected: _onAirplaneSelected,
      )
          : Row(
        children: [
          Expanded(
            flex: 1,
            child: AirplaneListView(
              airplaneService: widget.airplaneService,
              onAirplaneSelected: _onAirplaneSelected,
            ),
          ),
          Expanded(
            flex: 2,
            child: _selectedAirplane != null
                ? AirplaneDetailsPage(
              airplaneService: widget.airplaneService,
              airplaneId: _selectedAirplane!.id,
              onAirplaneUpdated: _refreshAirplaneList,
            )
                : Center(child: Text('Select an airplane')),
          ),
        ],
      ),
    );
  }
}