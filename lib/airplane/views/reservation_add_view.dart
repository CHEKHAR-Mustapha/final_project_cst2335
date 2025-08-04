import 'package:flutter/material.dart';
import 'package:final_project_cst2335/flight_list_dao.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReservationAddPage extends StatefulWidget {
  final FlightDao flightDao;
  final FlutterSecureStorage encryptedPrefs;

  const ReservationAddPage({
    Key? key,
    required this.flightDao,
    required this.encryptedPrefs,
  }) : super(key: key);

  @override
  State<ReservationAddPage> createState() => _ReservationAddPageState();
}

class _ReservationAddPageState extends State<ReservationAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerIdController = TextEditingController();
  final _flightIdController = TextEditingController();
  final _reservationNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadPreviousCustomerId();
  }

  void _loadPreviousCustomerId() async {
    final lastId = await widget.encryptedPrefs.read(key: 'last_customer_id');
    if (lastId != null) {
      _customerIdController.text = lastId;
    }
  }

  void _saveCustomerId() async {
    await widget.encryptedPrefs.write(
      key: 'last_customer_id',
      value: _customerIdController.text,
    );
  }

  void _submitReservation() {
    if (_formKey.currentState!.validate()) {
      _saveCustomerId();
      // TODO: Insert reservation into database here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation added successfully!')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Reservation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _customerIdController,
                decoration: const InputDecoration(labelText: 'Customer ID'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _flightIdController,
                decoration: const InputDecoration(labelText: 'Flight ID'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _reservationNameController,
                decoration:
                const InputDecoration(labelText: 'Reservation Name'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text("Flight Date: ${_selectedDate.toLocal()}".split(' ')[0]),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReservation,
                child: const Text('Save Reservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
