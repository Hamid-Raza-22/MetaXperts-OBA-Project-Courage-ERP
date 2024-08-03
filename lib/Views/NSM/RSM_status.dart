import 'package:flutter/material.dart';

class RSM_Status extends StatefulWidget {
  @override
  _RSM_StatusState createState() => _RSM_StatusState();
}

class _RSM_StatusState extends State<RSM_Status> {
  final List<Booker> _allBookers = [
    Booker(
      name: 'Dummy name',
      designation: 'RSM',
      attendanceStatus: 'Present',
      city: '',
    ),
    ...List.generate(
      20,
          (index) => Booker(
        name: 'RSM $index',
        designation: 'RSM', // Simplified designation assignment
        attendanceStatus: index % 2 == 0 ? 'Present' : 'Absent',
        city: index % 3 == 1 ? 'City $index' : '',
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 2.0, // Adjusted elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Adjusted border radius
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(
              isDate ? Icons.calendar_today : Icons.search,
              color: Colors.green,
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 1.5),
              borderRadius: BorderRadius.circular(8.0), // Adjusted border radius
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
              borderRadius: BorderRadius.circular(8.0), // Adjusted border radius
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
          margin: const EdgeInsets.all(8.0), // Adjusted margin
          elevation: 4.0, // Adjusted elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Adjusted border radius
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0), // Adjusted padding
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0), // Adjusted border radius
                  child: SizedBox(
                    width: 80, // Adjusted width
                    height: 80, // Adjusted height
                    child: Image.asset(
                      'assets/icons/avatar3.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0), // Adjusted spacing
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booker.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Adjusted font size
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0), // Adjusted padding
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6.0), // Adjusted border radius
                        ),
                        child: Row(
                          children: [
                            Icon(
                              booker.attendanceStatus == 'Present' ? Icons.check : Icons.close,
                              size: 14.0, // Adjusted icon size
                              color: statusColor,
                            ),
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                statusText,
                                style: TextStyle(fontSize: 14, color: statusColor), // Adjusted font size
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          const Icon(Icons.work, size: 14.0, color: Colors.green), // Adjusted icon size
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              'Designation: ${booker.designation}',
                              style: const TextStyle(fontSize: 14), // Adjusted font size
                            ),
                          ),
                        ],
                      ),
                      if (booker.designation == 'SO') ...[
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14.0, color: Colors.green), // Adjusted icon size
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                'City: ${booker.city}',
                                style: const TextStyle(fontSize: 14), // Adjusted font size
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
        padding: const EdgeInsets.all(8.0), // Adjusted padding
        child: Column(
          children: [
            Card(
              elevation: 2.0, // Adjusted elevation
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Adjusted border radius
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildTextField('Search by Attendance Status', _attendanceController, false, false),
                    _buildTextField('Search by RSM Name', _nameController, false, false),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${booker.name}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'City: ${booker.city}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Designation: ${booker.designation}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
