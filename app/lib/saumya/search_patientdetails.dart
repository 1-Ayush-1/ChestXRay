import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SearchPatientScreen(),
    );
  }
}

class SearchPatientScreen extends StatefulWidget {
  const SearchPatientScreen({super.key});

  @override
  _SearchPatientScreenState createState() => _SearchPatientScreenState();
}

class _SearchPatientScreenState extends State<SearchPatientScreen> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Patient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/doctor.jpg'), // Replace with actual image
                  radius: 40,
                ),
                SizedBox(width: 16),
                Text(
                  'Dr. John',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Patient\'s Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Patient\'s ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _startDateController,
              decoration: const InputDecoration(
                labelText: 'Start Date',
                border: OutlineInputBorder(),
              ),
              onTap: () {
                _selectDate(context, _startDateController);
                FocusScope.of(context).requestFocus(FocusNode());
              },
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _endDateController,
              decoration: const InputDecoration(
                labelText: 'End Date',
                border: OutlineInputBorder(),
              ),
              onTap: () {
                _selectDate(context, _endDateController);
                FocusScope.of(context).requestFocus(FocusNode());
              },
              readOnly: true,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 7, // Number of patients to display
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Patient Name 0${index + 1}/ID'),
                    onTap: () {
                      // Handle patient selection
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle navigation to prescription screen
                },
                child: const Text('Go to prescription'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
        ],
      ),
    );
  }
}