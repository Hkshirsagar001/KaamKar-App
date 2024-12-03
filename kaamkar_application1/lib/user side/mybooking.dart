import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
     
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('service_requests')
            .where('status', isEqualTo: 'accepted')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xffB19CD9),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error fetching bookings',
                style: TextStyle(color: Color(0xffB19CD9)),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No bookings found with status "accepted"',
                style: TextStyle(color: Color(0xffB19CD9)),
              ),
            );
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final data = booking.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8.0),
                color: const Color(0xffB19CD9).withOpacity(0.2), // Lighter shade for card background
                child: ListTile(
                  title: Text(
                    'Date: ${data['selected_day'] ?? 'N/A'}',
                    style: const TextStyle(color: Color(0xffB19CD9)),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Slot: ${data['slots'] ?? 'N/A'}',
                        style: const TextStyle(color: Color(0xffB19CD9)),
                      ),
                      Text(
                        'Address: ${data['address'] ?? 'N/A'}',
                        style: const TextStyle(color: Color(0xffB19CD9)),
                      ),
                      Text(
                        'Contact: ${data['contact'] ?? 'N/A'}',
                        style: const TextStyle(color: Color(0xffB19CD9)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
