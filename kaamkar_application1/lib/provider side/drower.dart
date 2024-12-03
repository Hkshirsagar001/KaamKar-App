import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaamkar_application1/login_screen.dart';

import 'package:kaamkar_application1/provider%20side/bookings.dart';

import 'Dashboard.dart';

class MenuScreen extends StatefulWidget {
  final String userId; // Accepts user ID as a parameter

  const MenuScreen({super.key, required this.userId});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedScreenIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
     Dashboard(userId: widget.userId),
      MyBookingScreen(providerId: widget.userId),

      
       
    ];
  }

  final List<String> _titles = [
    "Dashboard",
    "Booking Requests",
    "Profile",
    
  ];

  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
    Navigator.pop(context); // Close the drawer after selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedScreenIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff6D60AF)
              ),
              child:  Center(
                child: Text("KAAMKAR", 
                style: GoogleFonts.bebasNeue( 
                    fontSize: 45,
                    color: const Color(0xffcaf0c6)
                ),),
              )
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => _onDrawerItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Booking Requests'),
              onTap: () => _onDrawerItemTapped(1),
            ),
            // ListTile(
            //   leading: const Icon(Icons.person),
            //   title: const Text('Profile'),
            //   onTap: () => _onDrawerItemTapped(2),
            // ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () { 
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context) =>const LoginScreen(),), 
                (route){ 
                  return false; 
                });
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedScreenIndex],
    );
  }
}

// class DashboardScreen extends StatelessWidget {
//   final String userId;

//   const DashboardScreen({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Container(
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 40,
//                       backgroundColor: Color.fromARGB(255, 145, 197, 239),
//                       child: Icon(Icons.person, size: 40, color: Colors.white),
//                     ),
//                     const SizedBox(width: 16),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "User ID: $userId", // Display User ID
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         const Text(
//                           "johndoe@example.com",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BookingRequestScreen extends StatelessWidget {
//   final String userId;

//   const BookingRequestScreen({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         "Booking requests for User ID: $userId",
//         style: const TextStyle(fontSize: 18),
//       ),
//     );
//   }
// // }

// class ProfileScreen extends StatelessWidget {
//   final String userId;

//   const ProfileScreen({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         "Profile Details for User ID: $userId",
//         style: const TextStyle(fontSize: 18),
//       ),
//     );
//   }
// }
