
import 'package:flutter/material.dart';
import 'package:google_meet_example/resources/color.dart';
import 'package:google_meet_example/screens/create_screen.dart';
import 'package:google_meet_example/screens/edit_screen.dart';
import 'package:google_meet_example/utils/storage.dart';
import 'package:google_meet_sdk/google_meet_sdk.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.grey, //change your color here
        ),
        title: const Text(
          'Event Details',
          style: TextStyle(
            color: CustomColor.dark_blue,
            fontSize: 22,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColor.dark_cyan,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateScreen(),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 8.0),
          color: Colors.white,
          child: StreamBuilder(
            stream: storage.retrieveEvents(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('snapshot.data is ${snapshot.data?.docs.length}');
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> eventInfo = snapshot.data!.docs[index].data() as Map<String, dynamic> ;

                      EventInfo event = EventInfo.fromMap(eventInfo);

                      DateTime startTime = DateTime.fromMillisecondsSinceEpoch(event.startTimeInEpoch);
                      DateTime endTime = DateTime.fromMillisecondsSinceEpoch(event.endTimeInEpoch);

                      String startTimeString = DateFormat.jm().format(startTime);
                      String endTimeString = DateFormat.jm().format(endTime);
                      String dateString = DateFormat.yMMMMd().format(startTime);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditScreen(event: event),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  bottom: 16.0,
                                  top: 16.0,
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: CustomColor.neon_green.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.name,
                                      style: const TextStyle(
                                        color: CustomColor.dark_blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      event.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black38,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                      child: Text(
                                        event.link,
                                        style: TextStyle(
                                          color: CustomColor.dark_blue.withOpacity(0.5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 5,
                                          color: CustomColor.neon_green,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dateString,
                                              style: const TextStyle(
                                                color: CustomColor.dark_cyan,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                            Text(
                                              '$startTimeString - $endTimeString',
                                              style: const TextStyle(
                                                color: CustomColor.dark_cyan,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                else {
                  return const Center(
                    child: Text(
                      'No Events',
                      style: TextStyle(
                        color: Colors.black38,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(CustomColor.sea_blue),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
