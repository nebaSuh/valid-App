import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final TextEditingController matriculeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Fake database of receipts (replace with real DB later)
  final Map<String, Map<String, String>> receipts = {
    "STU001": {
      "amount": "250,000 XAF",
      "date": "21 Feb 2026",
    },
    "STU002": {
      "amount": "300,000 XAF",
      "date": "15 Jan 2026",
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Dashboard")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Student Name"),
              accountEmail: Text("student@email.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.cyan),
              ),
              decoration: BoxDecoration(color: Colors.cyan),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text("Dashboard"),
              onTap: () => Navigator.pop(context),
            ),
           ListTile(
  leading: Icon(Icons.folder),
  title: Text("My Documents"),
  onTap: () {
    // TODO: Navigate to documents page
  },
),
ListTile(
  leading: Icon(Icons.notifications),
  title: Text("Notifications"),
  onTap: () {
    // TODO: Navigate to notifications page
  },
),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/auth');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to Valid",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan[700],
                ),
              ),
              SizedBox(height: 40),

              TextFormField(
                controller: matriculeController,
                decoration: InputDecoration(
                  hintText: "Enter your matricule number",
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Matricule number is required";
                  } else if (value.length > 9) {
                    return "Matricule must not exceed 9 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final matricule = matriculeController.text.trim();

                    if (receipts.containsKey(matricule)) {
                      final receipt = receipts[matricule]!;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiptPage(
                            matricule: matricule,
                            amount: receipt["amount"]!,
                            date: receipt["date"]!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("No receipt found for $matricule")),
                      );
                    }
                  }
                },
                child: Text("Search", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Receipt page
class ReceiptPage extends StatelessWidget {
  final String matricule;
  final String amount;
  final String date;

  ReceiptPage({required this.matricule, required this.amount, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tuition Receipt")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Receipt Details",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Matricule: $matricule"),
            Text("Amount Paid: $amount"),
            Text("Date: $date"),
            SizedBox(height: 30),
            Icon(Icons.qr_code, size: 120, color: Colors.cyan),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement download logic
              },
              child: Text("Download Receipt"),
            ),
          ],
        ),
      ),
    );
  }
}