import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

class ProviderProfile extends StatefulWidget {
  const ProviderProfile({super.key});

  @override
  State<ProviderProfile> createState() => _ProviderProfileState();
}

class _ProviderProfileState extends State<ProviderProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Container
            Container(
              width: MediaQuery.of(context).size.width,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  "assets/pablo_the_cleaner.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Profile Info Section
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pablo Escobar",
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Cleaner",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  // Info Container
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: Colors.pink[300],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: "\$16",
                                  style: GoogleFonts.lato(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "/hr",
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ]),
                            ),
                            Text("Cost",
                                style: GoogleFonts.lato(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("300",
                                style: GoogleFonts.lato(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            Text("Jobs Completed",
                                style: GoogleFonts.lato(
                                    fontSize: 20, fontWeight: FontWeight.w400))
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 30),
                                Text("4.6",
                                    style: GoogleFonts.lato(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Text("Rating",
                                style: GoogleFonts.lato(
                                    fontSize: 20, fontWeight: FontWeight.w400))
                          ],
                        )
                      ],
                    ),
                  ),

                  // Bio Section
                  Text(
                    "Bio",
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const ReadMoreText(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Vestibulum viverra massa at nunc fermentum, sit amet scelerisque ligula tincidunt. '
                    'Phasellus sit amet sapien vitae nisi placerat interdum.',
                    trimLines: 2,
                    trimMode: TrimMode.Length,
                    trimLength: 154,
                    trimCollapsedText: ' Read more ',
                    trimExpandedText: ' Read less ',
                    moreStyle: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                    lessStyle: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Reviews Section
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                  color: Colors.pink[300],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Reviews",
                        style: GoogleFonts.lato(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "(136)",
                        style: GoogleFonts.lato(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.star, color: Colors.amber),
                      Text(
                        "4.6",
                        style: GoogleFonts.lato(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 235,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(
                                  5,
                                  (starIndex) => Icon(
                                    starIndex < 4
                                        ? Icons.star
                                        : Icons.star_border_outlined,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                style: GoogleFonts.lato(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: SizedBox(
        width: 200,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {

          },
          backgroundColor: Colors.deepPurple,
          child: Text("Schedule Now", 
          style: GoogleFonts.lato( 
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),),
        ),
      ),
    );
  }
}
