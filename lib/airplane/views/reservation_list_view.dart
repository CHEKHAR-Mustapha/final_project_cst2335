import 'package:flutter/material.dart';
import '../../reservation_entity.dart';
import '../services/reservation_service.dart';

class ReservationListView extends StatelessWidget {
  final ReservationService reservationService;

  const ReservationListView({
    Key? key,
    required this.reservationService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Reservations')),
      body: FutureBuilder<List<Reservation>>(
        future: reservationService.getReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reservations found.'));
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return ListTile(
                title: Text(
                  reservation.reservationName.trim().isEmpty
                      ? 'Unnamed Reservation'
                      : reservation.reservationName,


                ),
                subtitle: Text(
                  'Customer ID: ${reservation.customerId}, '
                      'Flight ID: ${reservation.flightId}, '
                      'Date: ${reservation.date}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
