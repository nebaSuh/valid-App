import 'package:flutter/material.dart';
import 'dart:math';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:qr_flutter/qr_flutter.dart';

// ------------------- ADMIN DASHBOARD -------------------
class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Admin User"),
              accountEmail: Text("admin@validapp.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.admin_panel_settings,
                    size: 40, color: Colors.cyan),
              ),
              decoration: BoxDecoration(color: Colors.cyan),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Manage Documents"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Send Notifications"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Issued Records"),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/auth');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(context,
                      icon: Icons.receipt,
                      label: "Receipt",
                      color: Colors.cyan, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReceiptFormPage()),
                    );
                  }),
                  _buildDashboardCard(context,
                      icon: Icons.assignment_turned_in,
                      label: "Examination Pass",
                      color: Colors.green, onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Examination Pass template coming soon")),
                    );
                  }),
                  _buildDashboardCard(context,
                      icon: Icons.school,
                      label: "Admission Letter",
                      color: Colors.blue, onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Admission Letter template coming soon")),
                    );
                  }),
                  _buildDashboardCard(context,
                      icon: Icons.bookmark,
                      label: "Registration",
                      color: Colors.orange, onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registration template coming soon")),
                    );
                  }),
                  _buildDashboardCard(context,
                      icon: Icons.star,
                      label: "Transcripts",
                      color: Colors.purple, onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Transcripts template coming soon")),
                    );
                  }),
                  _buildDashboardCard(context,
                      icon: Icons.card_membership,
                      label: "Certificates",
                      color: Colors.amber, onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Certificates template coming soon")),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------- RECEIPT FORM PAGE -------------------
class ReceiptFormPage extends StatefulWidget {
  @override
  _ReceiptFormPageState createState() => _ReceiptFormPageState();
}

class _ReceiptFormPageState extends State<ReceiptFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _matriculeController = TextEditingController();
  final _amountController = TextEditingController();
  final _balanceController = TextEditingController();
  final _programController = TextEditingController();
  final _issuedByController = TextEditingController();

  late String _receiptNumber;
  late String _date;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _activeField = ""; // Tracks which field is currently being dictated

  @override
  void initState() {
    super.initState();
    _receiptNumber = "RCPT-${Random().nextInt(999999)}";
    _date = DateTime.now().toString().split(" ")[0];
  }

  void _listen(TextEditingController controller, String fieldName) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == "done" || status == "notListening") {
            setState(() {
              _isListening = false;
              _activeField = "";
            });
          }
        },
        onError: (error) {
          setState(() {
            _isListening = false;
            _activeField = "";
          });
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
          _activeField = fieldName;
        });
        _speech.listen(
          onResult: (val) {
            setState(() {
              // Updates text box instantly as you speak
              controller.text = val.recognizedWords;
              // Keeps cursor at the end
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            });
          },
          partialResults: true,
          listenMode: stt.ListenMode.dictation,
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _activeField = "";
      });
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Issue Receipt")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Receipt Number: $_receiptNumber",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("Date: $_date"),
              const SizedBox(height: 16),
              _buildVoiceField("Name", _nameController),
              _buildVoiceField("Matricule Number", _matriculeController),
              _buildVoiceField("Amount Paid", _amountController,
                  keyboardType: TextInputType.number),
              _buildVoiceField("Balance", _balanceController,
                  keyboardType: TextInputType.number),
              _buildVoiceField("Program", _programController),
              _buildVoiceField("Issued By", _issuedByController),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.white),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String receiptData =
                        "Receipt: $_receiptNumber\nDate: $_date\nName: ${_nameController.text}\nMatricule: ${_matriculeController.text}\nAmount: ${_amountController.text}\nBalance: ${_balanceController.text}\nProgram: ${_programController.text}\nIssued By: ${_issuedByController.text}";
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Receipt QR Code"),
                        content: SizedBox(
                          width: 250,
                          height: 250,
                          child: Center(
                            child: QrImageView(
                              data: receiptData,
                              version: QrVersions.auto,
                              size: 200.0,
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text("Generate QR & Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

   Widget _buildVoiceField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    // Make sure this variable name matches whatever you used in your _listen function (_activeField vs _activeFieldLabel)
    bool isThisFieldActive = (_isListening && _activeField == label);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              // This line ensures the "X" appears as soon as you speak/type
              onChanged: (text) => setState(() {}), 
              decoration: InputDecoration(
                labelText: label,
                hintText: isThisFieldActive ? "Listening..." : null,
                border: const OutlineInputBorder(),
                // This adds the "X" button inside the box
                suffixIcon: controller.text.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                        onPressed: () {
                          controller.clear();
                          setState(() {}); 
                        },
                      )
                    : null,
              ),
              validator: (value) => value!.isEmpty ? "Enter $label" : null,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              isThisFieldActive ? Icons.mic : Icons.mic_none,
              color: isThisFieldActive ? Colors.red : Colors.cyan,
            ),
            onPressed: () => _listen(controller, label),
          ),
        ],
      ),
    );
  }
}