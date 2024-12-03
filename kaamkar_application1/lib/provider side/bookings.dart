import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyBookingScreen extends StatefulWidget {
  final String providerId; // Logged-in provider's ID

  const MyBookingScreen({super.key, required this.providerId});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  String selectedFilter = 'All'; // Filter for bookings
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffB19CD9), // Soft lavender
              Color(0xff6D60AF), // Dark purple
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          children: [
            // Filter Dropdown
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter by Status:',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  Container(
                      // color: Colors.amber,
                      child: DropdownButton<String>(
                    focusColor: Colors.red,
                    value: selectedFilter,
                    items:
                        ['All', 'pending', 'accepted', 'rejected', 'complete']
                            .map((filter) => DropdownMenuItem(
                                  value: filter,
                                  child: Text(filter),
                                ))
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFilter = value ?? 'All';
                      });
                    },
                    dropdownColor: const Color(
                        0xff6D60AF), // Purple background for the dropdown menu
                    style: const TextStyle(
                        color:
                            Colors.white), // White text for the selected item
                    iconEnabledColor: Colors.white, // Icon color in the button
                    iconDisabledColor:
                        Colors.white, // Icon color when the button is disabled
                  )),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {}); // Rebuild to fetch updated data
                },
                child: StreamBuilder<QuerySnapshot>(
                  stream: selectedFilter == 'All'
                      ? FirebaseFirestore.instance
                          .collection('service_requests')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('service_requests')
                          .where('status', isEqualTo: selectedFilter)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/animations/notfound.json',
                                height: 150),
                            const SizedBox(height: 16),
                            const Text(
                              'No requests found.',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    final requests = snapshot.data!.docs;

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        final data = request.data() as Map<String, dynamic>;
                        final isAssignedToProvider =
                            data['service_provider_id'] == widget.providerId;

                        // Status color coding
                        final statusColor = data['status'] == 'accepted'
                            ? Colors.green
                            : data['status'] == 'rejected'
                                ? Colors.red
                                : Colors.orange;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          elevation: 8.0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data['user_name'] ?? 'Unnamed Customer',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Chip(
                                      label: Text(
                                        data['status'] ?? 'Unknown',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: statusColor,
                                    ),
                                  ],
                                ),
                                const Divider(),
                                const SizedBox(height: 8),
                                _buildRow(Icons.calendar_today, 'Date:',
                                    data['selected_day'] ?? 'Unknown'),
                                _buildRow(
                                    Icons.access_time,
                                    'Slots:',
                                    data['slots']?.join(', ') ??
                                        'No slots selected'),
                                _buildRow(Icons.location_on, 'Address:',
                                    data['address'] ?? 'No address provided'),
                                _buildRow(Icons.phone, 'Contact:',
                                    data['contact'] ?? 'No contact provided'),
                                if (data['special_requests'] != null &&
                                    data['special_requests']!.isNotEmpty)
                                  _buildRow(Icons.comment, 'Special Request:',
                                      data['special_requests']),
                                const SizedBox(height: 16),
                                if (isAssignedToProvider &&
                                    data['status'] ==
                                        'pending') // Only show buttons if status is pending
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildActionButton(
                                        context,
                                        label: 'Accept',
                                        icon: Icons.check,
                                        color: Colors.green,
                                        onTap: () => _updateStatus(
                                            request.id, 'accepted', context),
                                      ),
                                      _buildActionButton(
                                        context,
                                        label: 'Reject',
                                        icon: Icons.close,
                                        color: Colors.red,
                                        onTap: () => _updateStatus(
                                            request.id, 'rejected', context),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build Row with Icon and Text
  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label $value',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  // Build Action Button
  Widget _buildActionButton(BuildContext context,
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _updateStatus(
      String requestId, String newStatus, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('service_requests')
          .doc(requestId)
          .update({'status': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to $newStatus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: $e')),
      );
    }
  }
}
