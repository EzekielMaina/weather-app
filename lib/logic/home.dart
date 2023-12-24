import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/keys.dart';
import 'weatherdata.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: MyHomePage(title: 'Flutter Demo Home Page'),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DateTime _selectedDay;
  TextEditingController _townController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  Future<void> _searchTown(String townName) async {
    try {
      print('Searching for town: $townName');
      String apiKey = WeatherAPIKey.geoapiKey; // Use the apiKey from keys.dart
      String apiUrl = 'https://api.geoapify.com/v1/ipinfo?apiKey=$apiKey';

      // Displaying a loading indicator pop-up
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 10),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Querying...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Simulating a delayed API call (you can replace it with your actual API call)
      await Future.delayed(Duration(seconds: 2));

      // Making the actual API call
      final response = await http.get(Uri.parse(apiUrl));

      Navigator.pop(context); // Close the loading indicator pop-up

      if (response.statusCode != 200) {
        showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'City Not Found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        throw Exception("City not found.");
      } else {
        final jsonData = json.decode(response.body);
        // Process jsonData as needed
        print('City found: $jsonData');

        // Navigate to another screen and pass the jsonData as a variable
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherScreen(cityName: townName),
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
      Navigator.pop(context); // Close the loading indicator pop-up
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        TableCalendar(
                          focusedDay: _selectedDay,
                          firstDay: DateTime.utc(
                            DateTime.now().year,
                            DateTime.now().month,
                            1,
                          ),
                          lastDay: DateTime.utc(
                            DateTime.now().year,
                            DateTime.now().month + 1,
                            0,
                          ),
                          calendarFormat: CalendarFormat.month,
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(color: Colors.green),
                            weekendStyle: TextStyle(color: Colors.black),
                          ),
                          headerStyle: HeaderStyle(
                            titleTextStyle: TextStyle(color: Colors.black),
                            formatButtonDecoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            formatButtonTextStyle:
                                TextStyle(color: Colors.white),
                          ),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.9),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _townController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Enter town name',
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          await _searchTown(_townController.text);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
