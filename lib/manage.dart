import 'package:collect_toll/generate_slip.dart';
import 'package:collect_toll/variables.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Manage extends StatefulWidget {
  const Manage({super.key});

  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  TextEditingController hostController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController dbUsernameController = TextEditingController();
  TextEditingController dbPasswordController = TextEditingController();
  TextEditingController dbNameController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    hostController.text = Variables.dbHost!;
    portController.text = Variables.dbPort!;
    dbUsernameController.text = Variables.dbUsername!;
    dbPasswordController.text = Variables.dbPassword!;
    dbNameController.text = Variables.dbName!;
    endDateController.text = Variables.endDate!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 18, 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Background color
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('GO BACK'),
              ),
            ),
          ],
          title: const Text(
            'Generate Slip',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5.0,
                    ),
                  ]),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      controller: hostController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter database host (ex. localhost)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      controller: portController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter database port (ex. 3306)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      controller: dbUsernameController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter database username (ex. root)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      controller: dbPasswordController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter database password (ex. root)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      controller: dbNameController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter database name (ex. slip_data)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      controller: endDateController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter end date (ex. yyyy-mm-dd hh:mm:ss)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // Background color
                      ),
                      onPressed: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('host', hostController.text);
                        prefs.setString('port', portController.text);
                        prefs.setString(
                            'dbusername', dbUsernameController.text);
                        prefs.setString(
                            'dbpassword', dbPasswordController.text);
                        prefs.setString('dbname', dbNameController.text);
                        prefs.setString('enddate', endDateController.text);
                        Variables.dbHost = prefs.getString('host')!;
                        Variables.dbPort = prefs.getString('port')!;
                        Variables.dbUsername = prefs.getString('dbusername')!;
                        Variables.dbPassword = prefs.getString('dbpassword')!;
                        Variables.dbName = prefs.getString('dbname')!;
                        Variables.endDate = prefs.getString('enddate')!;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Generate()),
                        );
                      },
                      child: const Text('SAVE CHANGES'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
