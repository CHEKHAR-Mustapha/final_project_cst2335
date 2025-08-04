import 'package:final_project_cst2335/encrypted_preferences.dart';
import 'package:final_project_cst2335/reservation_dao.dart';
import 'package:flutter/material.dart';
import '../airplane/services/reservation_service.dart';
import '../reservation_entity.dart';

class ReservationListPage extends StatelessWidget {
  final ReservationService reservationService;

  const ReservationListPage({
    Key? key,
    required this.reservationService, required ReservationDao reservationDao, required EncryptedPreferences encryptedPrefs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations'),
      ),
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
                  (reservation.reservationName.isNotEmpty ?? false)
                      ? reservation.reservationName!
                      : 'Unnamed Reservation',
                ),
                subtitle: Text(
                    'Customer ID: ${reservation.customerId} | Flight ID: ${reservation.flightId} | Date: ${reservation.date}'),
                onTap: () {
                  // You can add detail navigation here if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}
