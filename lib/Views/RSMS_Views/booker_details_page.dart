import 'package:flutter/material.dart';

import '../../Models/BookerStatusModel/BookerStatusModel.dart';
import 'BookerStatus.dart';

class BookerDetailsPage extends StatelessWidget {
  final BookerStatusModel booker;

  BookerDetailsPage({required this.booker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RSM-BOOKER DETAILS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${booker.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'City: ${booker.city}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Designation: ${booker.designation}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
