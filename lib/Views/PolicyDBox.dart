import 'package:flutter/material.dart';

class PolicyDialog extends StatefulWidget {
  const PolicyDialog({Key? key}) : super(key: key);

  @override
  _PolicyDialogState createState() => _PolicyDialogState();
}

class _PolicyDialogState extends State<PolicyDialog> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("App Policies"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "By using this app, you agree to the following policies:",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            "- This app collects location data to enable tracking and share your location to server even when the app is closed or not in use.",
            style: TextStyle(fontSize: 14),
          ),
          const Text(
            "- This app requires access to your camera for posting images to the server through APIs.",
            style: TextStyle(fontSize: 14),
          ),
          const Text(
            "- This app uses APIs to share app data onto the server.",
            style: TextStyle(fontSize: 14),
          ),
          const Text(
            "- This app uses storage to store app data.",
            style: TextStyle(fontSize: 14),
          ),
          const Text(
            "- This app uses battery for background services.",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isChecked = newValue ?? false;
                  });
                },
              ),
              const Text("I agree to the above policies"),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isChecked
              ? () {
            // Handle "Agree" button press
            Navigator.pop(context, true); // Close the dialog and return true
          }
              : null, // Disable the button if checkbox is not checked
          child: const Text("Agree"),
        ),
      ],
    );
  }
}

// Example usage in main.dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("App Policies")),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (context) => const PolicyDialog(),
              ).then((agreed) {
                if (agreed ?? false) {
                  // Request location permission here
                  // Implement your location permission request logic
                }
              });
            },
            child: const Text("Show Policies"),
          ),
        ),
      ),
    );
  }
}
