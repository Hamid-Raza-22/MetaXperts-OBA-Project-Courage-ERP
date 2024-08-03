import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';

class NSMShopVisitPage extends StatelessWidget {
  final TextEditingController nsmNameController = TextEditingController(text: 'ABC');
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateFormat('dd-MMMM-yyyy hh:mm a').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Visit Form'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnimatedTextField('NSM Name', nsmNameController, Icons.person),
            const SizedBox(height: 16),
            _buildAnimatedDateField(currentDate),
            const SizedBox(height: 16),
            _buildAnimatedDropdown("Select Region", ["Region 1", "Region 2", "Region 3"], Icons.location_on),
            const SizedBox(height: 16),
            _buildAnimatedDropdown("Select Booker", ["Booker 1", "Booker 2", "Booker 3"], Icons.book),
            const SizedBox(height: 16),
            _buildAnimatedDropdown("Select Shop", ["Shop 1", "Shop 2", "Shop 3"], Icons.store),
            const SizedBox(height: 16),
            _buildAnimatedFeedbackBox(),
            const SizedBox(height: 24),
            _buildAnimatedSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField(String label, TextEditingController controller, IconData icon) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.green),
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedDateField(String currentDate) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: TextEditingController(text: currentDate),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
            labelText: 'Date',
            border: InputBorder.none,
          ),
          readOnly: true,
        ),
      ),
    );
  }

  Widget _buildAnimatedDropdown(String label, List<String> items, IconData icon) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownSearch<String>(
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.green),
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
          items: items,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.green),
              labelText: label,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            ),
          ),
          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget _buildAnimatedFeedbackBox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feedback or Note',
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your feedback here...',
              ),
              maxLines: 3,
              textInputAction: TextInputAction.newline,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  feedbackController.clear();
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Form Submitted Successfully'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
          elevation: 8,
        ),
        child: const Text('Submit'),
      ),
    );
  }
}
