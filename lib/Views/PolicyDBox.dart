import 'package:flutter/material.dart' show AlertDialog, BuildContext, Checkbox, Column, CrossAxisAlignment, MainAxisSize, Navigator, Row, SizedBox, StatelessWidget, Text, TextButton, TextStyle, Widget;


class PolicyDialog extends StatelessWidget {
  const PolicyDialog({super.key});

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
            "- This app collects location data to enable tracking, and share your location to server even when the app is closed or not in use.",
            style: TextStyle(fontSize: 14),
          ),

          const Text(
            "- This app requires access to your camera for post image to server through APIs.",
            style: TextStyle(fontSize: 14),
          ),
          const Text(
            "- This app uses APIs for share app data onto server.",
            style: TextStyle(fontSize: 14),
          ), const Text(
            "- This app uses storage for store app data.",
            style: TextStyle(fontSize: 14),
          ),const Text(
            "- This app use battery for background services.",
            style: TextStyle(fontSize: 14),
          ),
          // Add more permissions and APIs here as needed
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: true, // Set initial value based on user's choice
                onChanged: (newValue) {
                  // Handle checkbox state change
                },
              ),
              const Text("I agree to the above policies"),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Handle "Agree" button press
            Navigator.pop(context); // Close the dialog
          },
          child: const Text("Agree"),
        ),
      ],
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(title: Text("App Policies")),
//           body: Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => PolicyDialog(),
//                 );
//               },
//               child: Text("Show Policies"),
//             ),
//           ),
//           ),
//       ));
// }