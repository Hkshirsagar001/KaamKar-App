import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaamkar_application1/user%20side/home-screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const ScheduleScreen({super.key, required this.profile});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<String>> _availableSlots = {};
  final Map<String, bool> _slotSelection = {};
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _specialRequestController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User? _user;
  bool _isLoading = false;

  // Colors
  final Color lightPurple = const Color(0xffD7CFFE);
  final Color deepPurple = const Color(0xff6D60AE);
  final Color mintGreen = const Color(0xffCAF0C6);
  final Color white = Colors.white;

  // Function to fetch the current user's data from FirebaseAuth and Firestore
Future<void> _fetchUserData() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        // Safely fetch 'name' field
        String username = (userDoc.data() as Map<String, dynamic>)['name'] ?? 'Guest';

        setState(() {
          _user = user;
          widget.profile['username'] = username;
        });
      } else {
        // Fallback to default
        print("User document not found or empty in Firestore.");
        setState(() {
          widget.profile['username'] = 'Guest';
        });
      }
    }
  } catch (e) {
    print("Error fetching user data: $e");
    setState(() {
      widget.profile['username'] = 'Guest'; // Fallback in case of error
    });
  }
}

// Function to fetch slots from Firestore
  Future<void> fetchAvailableSlots() async {
    setState(() {
      _isLoading = true;
    });
    try {
      DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(widget.profile['id'])
          .get();

      var availability = profileSnapshot['availability'] as Map<String, dynamic>? ?? {};
      Map<DateTime, List<String>> fetchedSlots = {};

      availability.forEach((key, value) {
        DateTime day = DateTime.parse(key);
        List<String> slots = List<String>.from(
          (value as List).map((slot) => slot['start']?.toString() ?? '').where((slot) => slot.isNotEmpty),
        );
        fetchedSlots[day] = slots;
      });

      setState(() {
        _availableSlots = fetchedSlots;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching slots: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> _getSlotsForDay(DateTime day) {
    return _availableSlots[day] ?? [];
  }

  // Function to handle the service request
  Future<void> _submitServiceRequest() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        if (_user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not logged in. Please log in first.')),
          );
          return;
        }

        // Get selected slots
        List<String> selectedSlots = _slotSelection.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList();

        if (selectedSlots.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select at least one slot.')),
          );
          return;
        }

        String serviceProviderId = widget.profile['id'];

        // Submit request to Firestore
        await FirebaseFirestore.instance.collection('service_requests').add({
          'user_id': _user?.uid,
          'user_name': _user?.displayName ?? 'Mahesh',
          'service_provider_id': serviceProviderId,
          'selected_day': _selectedDay?.toIso8601String(),
          'slots': selectedSlots,
          'address': _addressController.text.trim(),
          'contact': _contactController.text.trim(),
          'special_requests': _specialRequestController.text.trim(),
          'status': 'pending',
          'created_at': Timestamp.now(),
        });

        // Show confirmation dialog and navigate to Home
        bool? isConfirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Request Sent'),
              content: const Text('Your request has been sent.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true to indicate confirmation
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        // If the user presses "OK" in the dialog, navigate to HomeScreen
        if (isConfirmed == true) {
  String username = widget.profile['username'] ?? 'Mahesh'; // Use 'Guest' as fallback if null
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HomeScreen(username: username),
    ),
  );
}


        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Service request submitted successfully!')),
        // );
      } catch (e) {
        print("Error submitting service request: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    fetchAvailableSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 9,
        title: Text(
          'Select Appointment Date',
          style: GoogleFonts.sourceSans3(fontSize: 20, fontWeight: FontWeight.bold, color: white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TableCalendar(
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: lightPurple, // Deep purple for today’s date
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: deepPurple.withOpacity(0.8), // Light purple for selected dates
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: const TextStyle(
                          color: Colors.black, // Dark text for selected days for better contrast
                        ),
                        markerDecoration: const BoxDecoration(
                          color: Colors.amber, // Highlight events with mint green
                          shape: BoxShape.circle,
                        ),
                        weekendTextStyle: TextStyle(
                          color: deepPurple, // Deep purple for weekend text
                        ),
                        defaultTextStyle: const TextStyle(
                          color: Colors.black, // Default text color for non-selected dates
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                        titleTextStyle: GoogleFonts.sourceSans3(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: white,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: white,
                        ),
                        headerPadding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: deepPurple, // Deep purple background for the header
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() => _calendarFormat = format);
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      eventLoader: _getSlotsForDay,
                    ),

                    const SizedBox(height: 20),
                    _selectedDay == null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Select a date to view available slots',
                              style: GoogleFonts.sourceSans3(fontSize: 16, color: deepPurple),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Select a Time Slot',
                                  style: GoogleFonts.sourceSans3(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: deepPurple,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              _getSlotsForDay(_selectedDay!).isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'No slots available',
                                        style: GoogleFonts.sourceSans3(fontSize: 16, color: deepPurple),
                                      ),
                                    )
                                  : Column(
                                      children: _getSlotsForDay(_selectedDay!).map((slot) {
                                        bool isSelected = _slotSelection[slot] ?? false;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? deepPurple.withOpacity(0.7)
                                                  : lightPurple.withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: ListTile(
                                              contentPadding: const EdgeInsets.all(12.0),
                                              title: Row(
                                                children: [
                                                  Checkbox(
                                                    value: isSelected,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _slotSelection[slot] = value ?? false;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    slot,
                                                    style: GoogleFonts.sourceSans3(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                      color: isSelected ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    "Available",
                                                    style: GoogleFonts.sourceSans3(
                                                      fontWeight: FontWeight.w400,
                                                      color: deepPurple,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                            ],
                          ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        filled: true,
                        fillColor: lightPurple.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                   TextFormField(
  controller: _contactController,
  decoration:const InputDecoration(
    labelText: 'Contact Number',
    border: OutlineInputBorder(),
  ),
  keyboardType: TextInputType.number, // Ensures only numeric input
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your contact number';
    }
    // Check if the input contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter a valid contact number with only digits';
    }
    // Check if the number is at least 10 digits long
    if (value.length < 10) {
      return 'Contact number should be at least 10 digits';
    }
    return null;
  },
),
const SizedBox(height: 16),
                    TextFormField(
                      controller: _specialRequestController,
                      decoration: InputDecoration(
                        labelText: "Special Requests",
                        filled: true,
                        fillColor: lightPurple.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _submitServiceRequest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: deepPurple,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Confirm Request',
                              style: GoogleFonts.sourceSans3(fontSize: 18, color: white),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
