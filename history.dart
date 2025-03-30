import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = "All";

  final List<Map<String, dynamic>> _requests = [
    {
      "type": "Complaint",
      "date": "2025-03-27",
      "status": "Reviewed",
      "location": "Downtown",
      "description": "Noisy party at night.",
    },
    {
      "type": "Crime report",
      "date": "2025-03-25",
      "status": "Under processing",
      "location": "Park",
      "description": "Suspicious person walking around cars.",
    },
    {
      "type": "Question",
      "date": "2025-03-20",
      "status": "Awaiting response",
      "location": "",
      "description": "What documents are needed for vehicle registration?",
    },
  ];

  List<Map<String, dynamic>> get _filteredRequests {
    if (_selectedFilter == "All") return _requests;
    return _requests.where((req) => req['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("История обращений"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedFilter,
              isExpanded: true,
              items:
                  ["All", "Considered", "In process", "Wait for answer"].map((
                    filter,
                  ) {
                    return DropdownMenuItem(value: filter, child: Text(filter));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRequests.length,
              itemBuilder: (context, index) {
                final request = _filteredRequests[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      request['type'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date: ${request['date']}",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Status: ${request['status']}",
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        ),
                        if (request['location'].isNotEmpty)
                          Text(
                            "Place: ${request['location']}",
                            style: TextStyle(fontSize: 14),
                          ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _showRequestDetails(context, request);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestDetails(BuildContext context, Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(request['type']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Date: ${request['date']}", style: TextStyle(fontSize: 14)),
              Text(
                "Status: ${request['status']}",
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
              if (request['location'].isNotEmpty)
                Text(
                  "Place: ${request['location']}",
                  style: TextStyle(fontSize: 14),
                ),
              SizedBox(height: 10),
              Text(
                "Description: ${request['description']}",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
