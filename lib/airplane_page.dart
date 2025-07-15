import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'db/database_helper.dart';
import 'models/airplane.dart';

class AirplanePage extends StatefulWidget {
  const AirplanePage({super.key});

  @override
  State<AirplanePage> createState() => _AirplanePageState();
}

class _AirplanePageState extends State<AirplanePage> {
  final _typeController = TextEditingController();
  final _passengerController = TextEditingController();
  final _speedController = TextEditingController();
  final _rangeController = TextEditingController();

  final _storage = const FlutterSecureStorage();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Airplane> _airplaneList = [];
  int? _editingId;

  @override
  void initState() {
    super.initState();
    _loadLastInput();
    _loadAirplanesFromDb();
  }

  Future<void> _loadLastInput() async {
    _typeController.text = await _storage.read(key: 'type') ?? '';
    _passengerController.text = await _storage.read(key: 'passengers') ?? '';
    _speedController.text = await _storage.read(key: 'speed') ?? '';
    _rangeController.text = await _storage.read(key: 'range') ?? '';
  }

  Future<void> _saveLastInput() async {
    await _storage.write(key: 'type', value: _typeController.text);
    await _storage.write(key: 'passengers', value: _passengerController.text);
    await _storage.write(key: 'speed', value: _speedController.text);
    await _storage.write(key: 'range', value: _rangeController.text);
  }

  Future<void> _loadAirplanesFromDb() async {
    final airplanes = await _dbHelper.getAirplanes();
    setState(() {
      _airplaneList = airplanes;
    });
  }

  Future<void> _submit() async {
    if (_typeController.text.isEmpty ||
        _passengerController.text.isEmpty ||
        _speedController.text.isEmpty ||
        _rangeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final airplane = Airplane(
      id: _editingId,
      type: _typeController.text,
      passengers: int.tryParse(_passengerController.text) ?? 0,
      speed: int.tryParse(_speedController.text) ?? 0,
      range: int.tryParse(_rangeController.text) ?? 0,
    );

    if (_editingId == null) {
      await _dbHelper.insertAirplane(airplane);
    } else {
      await _dbHelper.updateAirplane(airplane);
    }

    await _saveLastInput();
    await _loadAirplanesFromDb();
    _clearFields();
  }

  void _clearFields() {
    _editingId = null;
    _typeController.clear();
    _passengerController.clear();
    _speedController.clear();
    _rangeController.clear();
  }

  void _edit(Airplane airplane) {
    setState(() {
      _editingId = airplane.id;
      _typeController.text = airplane.type;
      _passengerController.text = airplane.passengers.toString();
      _speedController.text = airplane.speed.toString();
      _rangeController.text = airplane.range.toString();
    });
  }

  void _delete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete airplane"),
        content: const Text("Do you want to delete this airplane?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
          TextButton(
            onPressed: () async {
              await _dbHelper.deleteAirplane(id);
              await _loadAirplanesFromDb();
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Instructions"),
        content: const Text(
          "Enter airplane details and tap 'Save' to add or update.\n"
              "Tap on a list item to edit it.\n"
              "Long press to delete.\n"
              "Last inputs are saved for reuse.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _typeController.dispose();
    _passengerController.dispose();
    _speedController.dispose();
    _rangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airplane List'),
        actions: [
          IconButton(onPressed: _showInstructions, icon: const Icon(Icons.info_outline))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: _typeController,
            decoration: const InputDecoration(labelText: 'Airplane Type'),
          ),
          TextField(
            controller: _passengerController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Passengers'),
          ),
          TextField(
            controller: _speedController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Max Speed (km/h)'),
          ),
          TextField(
            controller: _rangeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Range (km)'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submit,
            child: Text(_editingId == null ? "Add Airplane" : "Update Airplane"),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _airplaneList.isEmpty
                ? const Center(child: Text("No airplanes in list"))
                : ListView.builder(
              itemCount: _airplaneList.length,
              itemBuilder: (context, index) {
                final plane = _airplaneList[index];
                return GestureDetector(
                  onTap: () => _edit(plane),
                  onLongPress: () => _delete(plane.id!),
                  child: Card(
                    child: ListTile(
                      title: Text(plane.type),
                      subtitle: Text(
                        "Passengers: ${plane.passengers}, Speed: ${plane.speed} km/h, Range: ${plane.range} km",
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
