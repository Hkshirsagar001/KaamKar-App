


import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String providerName;
  final double rating;
  final String availability;
  final double price;

  const ServiceCard({super.key, 
    required this.serviceName,
    required this.providerName,
    required this.rating,
    required this.availability,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.amber,
        color: Colors.grey[400],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Container(
        width: 300,
       
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              serviceName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(providerName, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(rating.toString()),
              ],
            ),
            const SizedBox(height: 8),
            Text("Availability: $availability"),
            const SizedBox(height: 8),
            Text(
              "Price: ₹$price",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}