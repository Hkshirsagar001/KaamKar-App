import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kaamkar_application1/provider%20side/drower.dart';
import 'package:table_calendar/table_calendar.dart';

class ManageAvailabilityScreen extends StatefulWidget {
  final String documentId;
final String userId;
const ManageAvailabilityScreen({super.key, required this.documentId, required this.userId});

  

  @override
  _ManageAvailabilityScreenState createState() =>
      _ManageAvailabilityScreenState();
}

class _ManageAvailabilityScreenState extends State<ManageAvailabilityScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final Map<DateTime, List<Map<String, TimeOfDay?>>> _availability = {};
  int _slotCount = 1;
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.settings, color: theme.colorScheme.onPrimary),
        title: const Text(
          'Manage Availability',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Calendar Widget
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _availability.putIfAbsent(
                        selectedDay,
                        () => [
                              {'start': null, 'end': null}
                            ]);
                  });
                },
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Number of Slots for Selected Date',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Slots: ", style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: StepperInput(
                      value: _slotCount,
                      onChanged: (value) {
                        setState(() {
                          _slotCount = value;
                          _availability[_selectedDay] = List.generate(
                            value,
                            (index) => {'start': null, 'end': null},
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_availability.containsKey(_selectedDay)) ...[
                const Text(
                  'Set Times for Slots',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                ..._availability[_selectedDay]!.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, TimeOfDay?> slot = entry.value;
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildTimeField(
                              context,
                              slot['start'],
                              (time) {
                                setState(() {
                                  slot['start'] = time;
                                });
                              },
                            ),
                          ),
                          const Text(
                            ' - ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Expanded(
                            child: buildTimeField(
                              context,
                              slot['end'],
                              (time) {
                                setState(() {
                                  slot['end'] = time;
                                });
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red[400]),
                            onPressed: () {
                              setState(() {
                                _availability[_selectedDay]!.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
  onPressed: () {
    saveAvailabilityToFirestore();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return MenuScreen(userId: widget.userId); // Pass userId here
        },
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: theme.primaryColor,
    minimumSize: const Size(double.infinity, 48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: const Text(
    'Save/Update',
    style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.white),
  ),
),
],
          ),
        ),
      ),
    );
  }

  Widget buildTimeField(
    BuildContext context,
    TimeOfDay? time,
    Function(TimeOfDay) onTimePicked,
  ) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: time ?? const TimeOfDay(hour: 9, minute: 0),
        );
        if (pickedTime != null) {
          onTimePicked(pickedTime);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time != null ? time.format(context) : 'Select Time',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void saveAvailabilityToFirestore() async {
  try {
    // Convert availability map to structured format
    Map<String, dynamic> availabilityData = _availability.map((key, value) {
      return MapEntry(
        key.toIso8601String(),
        value
            .map((slot) => {
                  'start': slot['start']?.format(context),
                  'end': slot['end']?.format(context),
                })
            .toList(),
      );
    });

    // Reference the existing document by ID
    DocumentReference profileRef = FirebaseFirestore.instance
        .collection('profiles')
        .doc(widget.documentId);

    // Update Firestore with merged availability data
    await profileRef.update(
      {'availability': availabilityData},
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Availability saved successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving availability: $e')),
    );
  }
}
}

class StepperInput extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const StepperInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        Text('$value', style: const TextStyle(fontSize: 18)),
        IconButton(
          onPressed: () => onChanged(value + 1),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
