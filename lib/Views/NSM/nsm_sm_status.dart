import 'package:flutter/material.dart';

class NSM_SM_Status extends StatefulWidget {
  @override
  _NSM_SM_StatusState createState() => _NSM_SM_StatusState();
}

class _NSM_SM_StatusState extends State<NSM_SM_Status> {
  final List<Booker> _allBookers = [
    Booker(
      name: 'Dummy name',
      designation: 'booker',
      attendanceStatus: 'Present',
      city: '',
    ),
    ...List.generate(
      20,
          (index) => Booker(
        name: 'Booker $index',
        designation: index % 3 == 0
            ? 'ASM'
            : index % 3 == 1
            ? 'SO'
            : 'SPO', // Example designation assignment
        attendanceStatus: index % 2 == 0 ? 'Present' : 'Absent', // Example status assignment
        city: index % 3 == 1 ? 'City $index' : '', // Example city assignment for SO
      ),
    ),
  ];

  List<Booker> _filteredBookers = [];
  final List<Booker> _displayedBookers = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _attendanceController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _filteredBookers = _allBookers;
    _addBookersToList(_filteredBookers);
  }

  void _addBookersToList(List<Booker> bookers) async {
    for (int i = 0; i < bookers.length; i++) {
      if (!_displayedBookers.contains(bookers[i])) {
        _displayedBookers.add(bookers[i]);
        _listKey.currentState?.insertItem(_displayedBookers.indexOf(bookers[i]), duration: const Duration(seconds: 1));
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
  }

  void _removeBookersFromList() async {
    for (int i = _displayedBookers.length - 1; i >= 0; i--) {
      final removedBooker = _displayedBookers.removeAt(i);
      _listKey.currentState?.removeItem(
        i,
            (context, animation) => _buildBookerCard(removedBooker, animation),
        duration: const Duration(milliseconds: 300),
      );
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void _filterBookers() {
    final nameFilter = _nameController.text.toLowerCase();
    final attendanceFilter = _attendanceController.text.toLowerCase();
    _filteredBookers = _allBookers.where((booker) {
      final matchesName = booker.name.toLowerCase().contains(nameFilter);
      final matchesStatus = booker.attendanceStatus.toLowerCase().contains(attendanceFilter);
      return matchesName && matchesStatus;
    }).toList();
    _removeBookersFromList();
    _addBookersToList(_filteredBookers);
  }

  Widget _buildTextField(String hint, TextEditingController controller, bool isDate, bool isReadOnly) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(
              isDate ? Icons.calendar_today : Icons.search,
              color: Colors.green,
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          ),
          keyboardType: isDate ? TextInputType.datetime : TextInputType.text,
          readOnly: isReadOnly,
          onChanged: (value) {
            _filterBookers();
          },
        ),
      ),
    );
  }

  Widget _buildBookerCard(Booker booker, Animation<double> animation) {
    // Determine color based on attendance status
    Color statusColor;
    String statusText;

    switch (booker.attendanceStatus) {
      case 'Present':
        statusColor = Colors.green;
        statusText = 'Present';
        break;
      case 'Absent':
        statusColor = Colors.red;
        statusText = 'Absent';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
    }

    return FadeTransition(
      opacity: animation,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookerDetailsPage(booker: booker),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.all(6.0),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset(
                      'assets/icons/avatar3.png', // Path to your image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booker.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              booker.attendanceStatus == 'Present' ? Icons.check : Icons.close,
                              size: 14.0,
                              color: statusColor,
                            ),
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                statusText,
                                style: TextStyle(fontSize: 14, color: statusColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          const Icon(Icons.work, size: 14.0, color: Colors.green),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              'Designation: ${booker.designation}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      if (booker.designation == 'SO') ...[
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14.0, color: Colors.green),
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                'City: ${booker.city}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    _buildTextField('Search by Attendance Status', _attendanceController, false, false),
                    _buildTextField('Search by Booker Name', _nameController, false, false),
                  ],
                ),
              ),
            ),
            Expanded(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _displayedBookers.length,
                itemBuilder: (context, index, animation) {
                  final booker = _displayedBookers[index];
                  return _buildBookerCard(booker, animation);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookerDetailsPage extends StatelessWidget {
  final Booker booker;

  BookerDetailsPage({required this.booker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${booker.name} Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${booker.name}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Designation: ${booker.designation}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Attendance Status: ${booker.attendanceStatus}',
              style: const TextStyle(fontSize: 18),
            ),
            if (booker.designation == 'SO') ...[
              Text(
                'City: ${booker.city}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class Booker {
  final String name;
  final String designation;
  final String attendanceStatus;
  final String city;

  Booker({
    required this.name,
    required this.designation,
    required this.attendanceStatus,
    required this.city,
  });
}
