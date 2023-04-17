import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sms/flutter_sms.dart';



void makePhoneCall(String phoneNumber) async {
  final String formattedPhoneNumber = 'tel:$phoneNumber';
  // if (await canLaunchUrlString(formattedPhoneNumber)) {
  await launchUrlString(formattedPhoneNumber);
  // } else {
  //   throw 'Could not launch $formattedPhoneNumber';
  // }
}

Future<void> saveCategories(List<dynamic> categories) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = json.encode(categories);
  await prefs.setString('categories', jsonString);
}

Future<List<dynamic>> loadCategories() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('categories');
  if (jsonString != null) {
    return json.decode(jsonString);
  }
  return [];
}





void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sahayak',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LogoScreen(),
    );
  }
}

class LogoScreen extends StatefulWidget {
  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  void initState() {
    super.initState();
    loadCategories();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 232, 230, 1),
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _showIntro = true;

  @override
  void initState() {
    super.initState();
    _checkIfFirstTime();
  }

  Future<void> _checkIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showIntro = prefs.getBool('showIntro') ?? true;
    setState(() {
      _showIntro = showIntro;
    });
    if (showIntro) {
      await prefs.setBool('showIntro', false);
    }
  }
  final PageController controller = PageController(initialPage: 0);
  int currentPage = 0;

  List<Map<String, String>> services = [    {      "title": "Quick Calling",      "description": "Call your loved ones with a single tap."    },    {      "title": "Healthcare",      "description": "Get quick access to medical help and resources."    },    {      "title": "Easy Cab Booking",      "description": "Book a ride easily and quickly."    },    {      "title": "SOS",      "description": "Get immediate help in an emergency."    },  ];

  @override
  Widget build(BuildContext context) {
    if(_showIntro) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(255, 232, 230, 1),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          services[index]["title"]!,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          services[index]["description"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 30),
                        if (index == services.length - 1)
                          SOSPage(onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(),
                              ),
                            );
                          }),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    }
    else{
      return MainScreen();
    }
  }
}

class SOSPage extends StatelessWidget {
  final VoidCallback onPressed;

  const SOSPage({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.red,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.33,
          // ),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.66,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red, backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 16),
                child: Text(
                  'SAHAYAK',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Color.fromRGBO(255, 96, 56, 1),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Row(
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         // Navigate to Quick Calling screen
            //       },
            //       child: Container(
            //         margin: EdgeInsets.only(right: 16),
            //         child: CircleAvatar(
            //           backgroundColor: Colors.blue,
            //           child: Icon(Icons.call),
            //         ),
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         // Navigate to Medical screen
            //       },
            //       child: Container(
            //         margin: EdgeInsets.only(right: 16),
            //         child: CircleAvatar(
            //           backgroundColor: Colors.green,
            //           child: Icon(Icons.local_hospital),
            //         ),
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         // Navigate to SOS screen
            //       },
            //       child: Container(
            //         margin: EdgeInsets.only(right: 16),
            //         child: CircleAvatar(
            //           backgroundColor: Colors.red,
            //           child: Icon(Icons.warning),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      backgroundColor: Color.fromRGBO(255, 232, 230, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 16, 0, 0),
            // child: Text(
            //   'SAHAYAK',
            //   style: TextStyle(
            //     fontSize: 28,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.red,
            //   ),
            // ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuickCallingScreen()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: EdgeInsets.all(1),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => QuickCallingScreen()),
                                );
                              },
                              icon: Image.asset('assets/Call_icon.png'),
                              iconSize: 100,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Quick Calling',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              //fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HealthcareScreen()),
                        );

                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: EdgeInsets.all(1),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HealthcareScreen()),
                                );
                              },
                              icon: Image.asset('assets/Healthcare_icon.png'),
                              iconSize: 100,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Healthcare',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              //fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        // Read emergency contact and contacts list from storage
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String emergencyNumber = prefs.getString('emergency_contact') ?? '911';
                        List<String> recipients = List<String>.from(prefs.getStringList('emergency_contacts') ?? []);
                        print(emergencyNumber);
                        print(recipients.toString());
                        // Call emergency contact
                        launch("tel:$emergencyNumber");

                        // Send emergency SMS
                        String message = 'Emergency! Please help me!'; // Change this to your emergency SMS message
                        recipients.forEach((recipient) async {
                          String _result = await sendSMS(
                            message: message,
                            recipients: [recipient],
                          );
                          print(_result);
                        });
                      },

                      onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EmergencyContactScreen()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: EdgeInsets.all(1),
                            child: IconButton(
                              onPressed: () async {
                                // Read emergency contact and contacts list from storage
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                String emergencyNumber = prefs.getString('emergency_contact') ?? '911';
                                List<String> recipients = List<String>.from(prefs.getStringList('emergency_contacts') ?? []);
                                print(emergencyNumber);
                                print(recipients.toString());
                                // Call emergency contact
                                launch("tel:$emergencyNumber");

                                // Send emergency SMS
                                String message = 'Emergency! Please help me!'; // Change this to your emergency SMS message
                                recipients.forEach((recipient) async {
                                  String _result = await sendSMS(
                                    message: message,
                                    recipients: [recipient],
                                  );
                                  print(_result);
                                });
                              },
                              icon: Image.asset('assets/SOS_icon.png'),
                              iconSize: 100,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'SOS',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              //fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickCallingScreen extends StatefulWidget {
  @override
  _QuickCallingScreenState createState() => _QuickCallingScreenState();
}

class _QuickCallingScreenState extends State<QuickCallingScreen> {
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? categoriesJson = prefs.getString('categories');
    if (categoriesJson != null) {
      setState(() {
        categories = List<Map<String, dynamic>>.from(json.decode(categoriesJson));
      });
    }
  }

  void saveCategories(List<Map<String, dynamic>> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String categoriesJson = json.encode(categories);
    prefs.setString('categories', categoriesJson);
  }

  void _addContact(String name, String number, String category) {
    int categoryIndex = categories.indexWhere((c) => c['name'] == category);
    if (categoryIndex != -1) {
      setState(() {
        categories[categoryIndex]['contacts'].add({'name': name, 'number': number});
      });
    } else {
      setState(() {
        categories.add({'name': category, 'contacts': [{'name': name, 'number': number}]});
      });
    }
    saveCategories(categories);
  }

  void _showAddContactDialog(BuildContext context) {
    // Define controllers for text fields
    TextEditingController nameController = TextEditingController();
    TextEditingController numberController = TextEditingController();
    TextEditingController categoryController = TextEditingController();

    // Display dialog to add new contact
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Name'),
              ),
              TextField(
                controller: numberController,
                decoration: InputDecoration(hintText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(hintText: 'Category'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close dialog
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add new contact
                _addContact(nameController.text, numberController.text, categoryController.text);

                // Close dialog
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 159, 191, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 232, 230, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );

              },
              child: Container(
                // margin: EdgeInsets.only(left: 16),
                margin: EdgeInsets.only(right: 47),

                child: Text(
                  'SAHAYAK',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Color.fromRGBO(255, 96, 56, 1),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuickCallingScreen()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.call),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HealthcareScreen()),
                    );

                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.local_hospital),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // Read emergency contact and contacts list from storage
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String emergencyNumber = prefs.getString('emergency_contact') ?? '911';
                    List<String> recipients = List<String>.from(prefs.getStringList('emergency_contacts') ?? []);
                    print(emergencyNumber);
                    print(recipients.toString());
                    // Call emergency contact
                    launch("tel:$emergencyNumber");

                    // Send emergency SMS
                    String message = 'Emergency! Please help me!'; // Change this to your emergency SMS message
                    recipients.forEach((recipient) async {
                      String _result = await sendSMS(
                        message: message,
                        recipients: [recipient],
                      );
                      print(_result);
                    });
                  },

                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmergencyContactScreen()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.warning),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: categories.isEmpty ? Center(child: Text('Click the + icon to add contacts', style: TextStyle(color: Colors.grey))) : Column(
        children: [
          Expanded(
            child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    // color: Colors.grey[300],
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categories[index]['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: categories[index]['contacts'].length,
                      itemBuilder: (BuildContext context, int contactIndex) {
                        Map<String, dynamic> contact = categories[index]['contacts'][contactIndex];
                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Delete Contact"),
                                content: Text("Are you sure you want to delete this contact?"),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Delete"),
                                    onPressed: () {
                                      // Delete contact
                                      setState(() {
                                        categories[index]['contacts'].removeAt(contactIndex);
                                        saveCategories(categories);
                                      });
                                      Navigator.of(context).pop();

                                      // Check if category is empty and delete if necessary
                                      if (categories[index]['contacts'].isEmpty) {
                                        setState(() {
                                          categories.removeAt(index);
                                          saveCategories(categories);
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contact['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  makePhoneCall(contact['number']);

                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // color: Colors.blue,
                                  ),
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // BuildContext context = context;
          _showAddContactDialog(context);
          // Display popup to add new contact
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


class HealthcareScreen extends StatefulWidget {
  @override
  _HealthcareScreenState createState() => _HealthcareScreenState();
}

class _HealthcareScreenState extends State<HealthcareScreen> {
  List<dynamic> _medications = [];
  String _getTimeOfDayString(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formatter = DateFormat.jm();
    return formatter.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _loadMedications();

  }

  Future<void> _loadMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final medicationsJson = prefs.getString('medications');

    if (medicationsJson != null) {
      final medications = (jsonDecode(medicationsJson) as List)
          .map((medicationJson) => Medication.fromJson(medicationJson))
          .toList();


      setState(() {
        _medications = medications;

      });
    }
  }

  Future<void> _saveMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final medicationsJson = jsonEncode(_medications);

    await prefs.setString('medications', medicationsJson);
  }

  void _addMedication(Medication medication) {
    setState(() {
      _medications.add(medication);
    });
    _saveMedications();
  }

  void _deleteMedication(Medication medication) {
    setState(() {
      _medications.remove(medication);
    });
    _saveMedications();
  }

  String _getWeekdayAbbreviation(int weekday) {
    switch (weekday) {
      case 1:
        return 'M';
      case 2:
        return 'T';
      case 3:
        return 'W';
      case 4:
        return 'T';
      case 5:
        return 'F';
      case 6:
        return 'S';
      case 7:
        return 'S';
      default:
        return '';
    }
  }
  String _getWeekdayAbbreviation2(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
  TimeOfDay timeOfDay = TimeOfDay.now();
  // List<Medication> _medications = [];
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? newTimeOfDay = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
    );

    if (newTimeOfDay != null) {
      setState(() {
        timeOfDay = newTimeOfDay;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    String greeting = "";

    greeting= _getWeekdayAbbreviation2(currentTime.weekday.toInt()) ;
    DateTime today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );

              },
              child: Container(
                margin: EdgeInsets.only(right: 47),

                child: Text(
                  'SAHAYAK',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Color.fromRGBO(255, 96, 56, 1),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuickCallingScreen()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.call),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HealthcareScreen()),
                    );

                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.local_hospital),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // Read emergency contact and contacts list from storage
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String emergencyNumber = prefs.getString('emergency_contact') ?? '911';
                    List<String> recipients = List<String>.from(prefs.getStringList('emergency_contacts') ?? []);
                    print(emergencyNumber);
                    print(recipients.toString());
                    // Call emergency contact
                    launch("tel:$emergencyNumber");

                    // Send emergency SMS
                    String message = 'Emergency! Please help me!'; // Change this to your emergency SMS message
                    recipients.forEach((recipient) async {
                      String _result = await sendSMS(
                        message: message,
                        recipients: [recipient],
                      );
                      print(_result);
                    });
                  },

                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmergencyContactScreen()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.warning),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
        body: Column(
          children: [

            Padding(padding: EdgeInsets.all(25),
                child:Text(

              greeting,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 96, 56, 1),
              ),
              textAlign: TextAlign.center,
              // textAlignVertical: TextAlignVertical.center,
              // Adding padding and margin
              // : EdgeInsets.symmetric(vertical: 10.0),
              // margin: EdgeInsets.only(bottom: 10.0),

            )),
            Expanded(
              child: ListView.builder(
                itemCount: _medications
                    .where((med) => med.daysOfWeek.contains(today.weekday))
                    .length,
                itemBuilder: (context, index) {
                  final medication = _medications
                      .where((med) => med.daysOfWeek.contains(today.weekday))
                      .toList()[index];
                  return Dismissible(
                    key: UniqueKey(), // Use a unique key for each Dismissible
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text('Are you sure you want to delete this medication?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text('DELETE'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      // Perform delete action here
                      _deleteMedication(medication);
                    },
                    background: Container(

                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: MedicationNotification(
                      time: medication.time,
                      icon: medication.icon,
                      name: medication.name,
                      dosage: medication.dosage,
                      description: medication.description,
                    ),
                  );
                },
              ),

            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Show dialog to add new medication
          final medication = await showDialog<Medication>(
            context: context,
            builder: (BuildContext context) {
              // Initialize variables for medication data

              String name = '';
              String dosage = '';
              String description = '';
              Set<int> _selectedDaysOfWeek = {};


              return AlertDialog(
                title: Text('Add Medication'),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Medication Name',
                            ),
                            onChanged: (value) => name = value,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Dosage',
                            ),
                            onChanged: (value) => dosage = value,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Description',
                            ),
                            onChanged: (value) => description = value,
                          ),
                          SizedBox(height: 16.0),
                          Text('Select Time of Day'),
                          SizedBox(height: 8.0),
                          GestureDetector(
                            onTap: () {
                              _selectTime(context);
                            },
                            child: Container(
                              width: 120.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromRGBO(255, 96, 56, 1),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  _getTimeOfDayString(timeOfDay),
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 96, 56, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text('Select Days of Week'),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int i = 1; i <= 7; i++)
                                GestureDetector(
                                  onTap: () {
                                    if (_selectedDaysOfWeek.contains(i)) {
                                      _selectedDaysOfWeek.remove(i);
                                    } else {
                                      _selectedDaysOfWeek.add(i);
                                    }

                                    setState(() {});

                                    print(_selectedDaysOfWeek.toString());
                                  },
                                  child: Container(
                                    width: 32.0,
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _selectedDaysOfWeek.contains(i)
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _getWeekdayAbbreviation(i),
                                        style: TextStyle(
                                          color: _selectedDaysOfWeek.contains(i)
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),

                    );
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Create new Medication object
                      final newMedication = Medication(
                        time: timeOfDay,
                        icon: Icons.local_hospital,
                        name: name,
                        dosage: dosage,
                        description: description,
                        daysOfWeek: _selectedDaysOfWeek.toList(),
                      );
                      // Add new medication to list and update state
                      // _medications.add(newMedication);
                      _addMedication(newMedication);
                      setState(() {});
                      Navigator.pop(context, newMedication);
                    },
                    child: Text('ADD'),
                  ),
                ],
              );

            },
          );
          // if (medication != null) setState(() {
          //   _medications.add(medication);
          // });
        },
        child: Icon(Icons.add),
      )
    );
  }
}

class Medication {
  final TimeOfDay time;
  final IconData icon;
  final String name;
  final String dosage;
  final String description;
  final List<int> daysOfWeek;
  bool taken;

  Medication({
    required this.time,
    required this.icon,
    required this.name,
    required this.dosage,
    required this.description,
    required this.daysOfWeek,
    this.taken = false,
  });

  Medication.fromJson(Map<String, dynamic> json)
      : time = TimeOfDay(
    hour: json['hour'],
    minute: json['minute'],
  ),
        icon = IconData(
          json['codePoint'],
          fontFamily: 'MaterialIcons',
        ),
        name = json['name'],
        dosage = json['dosage'],
        description = json['description'],
        daysOfWeek = List<int>.from(json['daysOfWeek']),
        taken = json['_taken'] ?? false;

  Map<String, dynamic> toJson() => {
    'hour': time.hour,
    'minute': time.minute,
    'codePoint': icon.codePoint,
    'name': name,
    'dosage': dosage,
    'description': description,
    'daysOfWeek': daysOfWeek,
    '_taken': taken,
  };
}



class MedicationNotification extends StatefulWidget {
  final TimeOfDay time;
  final IconData icon;
  final String name;
  final String dosage;
  final String description;

  const MedicationNotification({
    Key? key,
    required this.time,
    required this.icon,
    required this.name,
    required this.dosage,
    required this.description,
  }) : super(key: key);


  @override
  _MedicationNotificationState createState() => _MedicationNotificationState();
}

class _MedicationNotificationState extends State<MedicationNotification> {
  bool _isDone = false;
  _HealthcareScreenState obj = new _HealthcareScreenState();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _isDone = !_isDone;
        });
      },
      child: Opacity(
        opacity: _isDone ? 0.5 : 1.0,
        child: Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(25.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 2.0,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.time.format(context),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Icon(
                    widget.icon,
                    size: 32.0,
                    color: _isDone ? Colors.black : Colors.blue,
                  ),
                ],
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.dosage,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }





}

class EmergencyContactScreen extends StatefulWidget {
  @override
  _EmergencyContactScreenState createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  TextEditingController _emergencyContactController = TextEditingController();
  List<TextEditingController> _contactControllers = [    TextEditingController(),    TextEditingController(),    TextEditingController(),    TextEditingController(),    TextEditingController(),  ];

  @override
  void initState() {
    super.initState();
    // Load emergency contact and contacts list from storage
    SharedPreferences.getInstance().then((prefs) {
      _emergencyContactController.text = prefs.getString('emergency_contact') ?? '';
      List<String> contacts = prefs.getStringList('emergency_contacts') ?? [];
      for (int i = 0; i < contacts.length && i < _contactControllers.length; i++) {
        _contactControllers[i].text = contacts[i];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );

              },
              child: Container(
                // margin: EdgeInsets.only(left: 16),
                margin: EdgeInsets.only(right: 47),

                child: Text(
                  'SAHAYAK',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Color.fromRGBO(255, 96, 56, 1),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuickCallingScreen()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.call),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HealthcareScreen()),
                    );

                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.local_hospital),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // Read emergency contact and contacts list from storage
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String emergencyNumber = prefs.getString('emergency_contact') ?? '911';
                    List<String> recipients = List<String>.from(prefs.getStringList('emergency_contacts') ?? []);
                    print(emergencyNumber);
                    print(recipients.toString());
                    // Call emergency contact
                    launch("tel:$emergencyNumber");

                    // Send emergency SMS
                    String message = 'Emergency! Please help me!'; // Change this to your emergency SMS message
                    recipients.forEach((recipient) async {
                      String _result = await sendSMS(
                        message: message,
                        recipients: [recipient],
                      );
                      print(_result);
                    });
                  },

                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmergencyContactScreen()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.warning),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Emergency Contact',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _emergencyContactController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter emergency contact number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Emergency Contacts to Notify',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 96, 56, 1),
              ),
            ),
            SizedBox(height: 8),
            for (int i = 0; i < 5; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: _contactControllers[i],
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter contact number ${i + 1}',
                    border: OutlineInputBorder(),

                  ),
                ),
              ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                // Save emergency contact and contacts list to storage
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('emergency_contact', _emergencyContactController.text);
                List<String> contacts = _contactControllers.map((controller) => controller.text).toList();
                prefs.setStringList('emergency_contacts', contacts);

                Navigator.pop(context);
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                
                shape: RoundedRectangleBorder(
                  
                  borderRadius: BorderRadius.circular(45), // set the button border radius
                ),
                minimumSize: Size(10, 50),
                padding: EdgeInsets.symmetric(horizontal: 16),
                // maximumSize: Size(50, 50),

                primary: Colors.red,
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
