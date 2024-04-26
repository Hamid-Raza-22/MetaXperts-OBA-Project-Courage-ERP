import 'package:flutter/material.dart';

class PolicyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("App Policies"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "By using this app, you agree to the following policies:",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            "- This app collects location data to enable feature A, feature B, and feature C even when the app is closed or not in use.",
            style: TextStyle(fontSize: 14),
          ),
          Text(
            "- This data is also used to provide ads/support advertising/support ads.",
            style: TextStyle(fontSize: 14),
          ),
          Text(
            "- The app requires access to your camera for feature D.",
            style: TextStyle(fontSize: 14),
          ),
          Text(
            "- Access to your contacts is needed for feature E.",
            style: TextStyle(fontSize: 14),
          ),
          Text(
            "- The app uses APIs for feature F and feature G.",
            style: TextStyle(fontSize: 14),
          ),
          // Add more permissions and APIs here as needed
          SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: true, // Set initial value based on user's choice
                onChanged: (newValue) {
                  // Handle checkbox state change
                },
              ),
              Text("I agree to the above policies"),
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
          child: Text("Agree"),
        ),
      ],
    );
  }
}
//
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