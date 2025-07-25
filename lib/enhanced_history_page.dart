// ENHANCED HISTORY PAGE
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with TickerProviderStateMixin {
  String selectedTab = 'Tasks';
  final List<String> tabs = ['Tasks', 'Equipment', 'Reports'];
  late TabController _tabController;
  
  String selectedDateRange = 'Last 7 days';
  final List<String> dateRanges = ['Today', 'Last 7 days', 'Last 30 days', 'All time'];

  final List<Map<String, dynamic>> taskHistory = [
    {
      'id': 'T003',
      'title': 'Network Troubleshooting',
      'completedDate': '2024-01-15',
      'completedTime': '14:30',
      'duration': '2 hours 15 minutes',
      'status': 'Completed',
      'location': 'Room 201',
      'category': 'Network',
      'rating': 5,
      'notes': 'Fixed network cable connection, tested all ports',
    },
    {
      'id': 'T002',
      'title': 'Software Installation',
      'completedDate': '2024-01-14',
      'completedTime': '11:45',
      'duration': '1 hour 30 minutes',
      'status': 'Completed',
      'location': 'Library',
      'category': 'Software',
      'rating': 4,
      'notes': 'Installed updates on 12 computers, one required restart',
    },
    {
      'id': 'T001',
      'title': 'Hardware Repair',
      'completedDate': '2024-01-13',
      'completedTime': '09:15',
      'duration': '3 hours',
      'status': 'Completed',
      'location': 'Computer Lab A',
      'category': 'Hardware',
      'rating': 5,
      'notes': 'Replaced faulty RAM module, system running smoothly',
    },
    {
      'id': 'T006',
      'title': 'Printer Setup',
      'completedDate': '2024-01-12',
      'completedTime': '16:20',
      'duration': '45 minutes',
      'status': 'Completed',
      'location': 'HR Department',
      'category': 'Setup',
      'rating': 4,
      'notes': 'Configured new printer, trained staff on usage',
    },
  ];

  final List<Map<String, dynamic>> equipmentHistory = [
    {
      'id': 'EQ001',
      'name': 'Computer Lab A - PC #5',
      'lastScanned': '2024-01-15 14:30',
      'status': 'Working',
      'location': 'Computer Lab A',
      'qrCode': '11024',
      'previousStatus': 'Needs Repair',
      'maintenanceType': 'Repair',
      'technician': 'You',
      'notes': 'Fixed monitor display issue',
    },
    {
      'id': 'EQ002',
      'name': 'Printer - Main Office',
      'lastScanned': '2024-01-14 10:15',
      'status': 'Needs Repair',
      'location': 'Main Office',
      'qrCode': '11025',
      'previousStatus': 'Working',
      'maintenanceType': 'Inspection',
      'technician': 'You',
      'notes': 'Paper jam detected, needs cleaning',
    },
    {
      'id': 'EQ003',
      'name': 'Projector - Room 201',
      'lastScanned': '2024-01-13 16:45',
      'status': 'Working',
      'location': 'Room 201',
      'qrCode': '11026',
      'previousStatus': 'Working',
      'maintenanceType': 'Routine Check',
      'technician': 'You',
      'notes': 'Regular maintenance completed',
    },
    {
      'id': 'EQ004',
      'name': 'Router - IT Room',
      'lastScanned': '2024-01-12 13:20',
      'status': 'Under Maintenance',
      'location': 'IT Room',
      'qrCode': '11027',
      'previousStatus': 'Working',
      'maintenanceType': 'Upgrade',
      'technician': 'You',
      'notes': 'Firmware update in progress',
    },
  ];

  final List<Map<String, dynamic>> reportHistory = [
    {
      'id': 'R001',
      'title': 'Weekly Equipment Status Report',
      'submittedDate': '2024-01-15',
      'submittedTime': '17:00',
      'type': 'Equipment Status',
      'status': 'Submitted',
      'recipient': 'IT Manager',
      'summary': '45 equipment items checked, 3 issues found',
    },
    {
      'id': 'R002',
      'title': 'Incident Report - Network Outage',
      'submittedDate': '2024-01-13',
      'submittedTime': '15:30',
      'type': 'Incident',
      'status': 'Reviewed',
      'recipient': 'Network Admin',
      'summary': 'Network outage in Room 201 resolved',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTab = tabs[_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'History',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.date_range),
                onSelected: (value) {
                  setState(() {
                    selectedDateRange = value;
                  });
                },
                itemBuilder: (context) => dateRanges.map((range) {
                  return PopupMenuItem(
                    value: range,
                    child: Row(
                      children: [
                        Icon(
                          selectedDateRange == range ? Icons.check : Icons.calendar_today,
                          size: 16,
                          color: selectedDateRange == range ? Colors.teal : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(range),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Summary Cards
          Row(
            children: [
              Expanded(child: _buildSummaryCard('Tasks Completed', '${taskHistory.length}', Icons.task_alt, Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCard('Equipment Scanned', '${equipmentHistory.length}', Icons.qr_code_scanner, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCard('Reports Submitted', '${reportHistory.length}', Icons.report, Colors.orange)),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(25),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              tabs: tabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskHistory(),
                _buildEquipmentHistory(),
                _buildReportsHistory(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskHistory() {
    return ListView.builder(
      itemCount: taskHistory.length,
      itemBuilder: (context, index) {
        final task = taskHistory[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => _showTaskHistoryDetails(task),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.green, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${task['completedDate']} at ${task['completedTime']}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildRatingStars(task['rating']),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(Icons.location_on, task['location'], Colors.blue),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.access_time, task['duration'], Colors.orange),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.category, task['category'], Colors.purple),
                    ],
                  ),
                  if (task['notes'] != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      task['notes'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEquipmentHistory() {
    return ListView.builder(
      itemCount: equipmentHistory.length,
      itemBuilder: (context, index) {
        final equipment = equipmentHistory[index];
        final statusColor = _getEquipmentStatusColor(equipment['status']);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => _showEquipmentHistoryDetails(equipment),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.devices, color: statusColor, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              equipment['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Scanned: ${equipment['lastScanned']}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          equipment['status'],
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(Icons.qr_code, 'QR: ${equipment['qrCode']}', Colors.teal),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.build, equipment['maintenanceType'], Colors.orange),
                    ],
                  ),
                  if (equipment['previousStatus'] != equipment['status']) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Status changed: ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${equipment['previousStatus']} → ${equipment['status']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (equipment['notes'] != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      equipment['notes'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportsHistory() {
    if (reportHistory.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.report, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Reports Yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Your submitted reports will appear here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: reportHistory.length,
      itemBuilder: (context, index) {
        final report = reportHistory[index];
        final statusColor = report['status'] == 'Submitted' ? Colors.orange : Colors.green;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => _showReportHistoryDetails(report),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.report, color: statusColor, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Submitted: ${report['submittedDate']} at ${report['submittedTime']}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          report['status'],
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(Icons.category, report['type'], Colors.purple),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.person, report['recipient'], Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    report['summary'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: 16,
          color: Colors.amber,
        );
      }),
    );
  }

  Color _getEquipmentStatusColor(String status) {
    switch (status) {
      case 'Working': return Colors.green;
      case 'Needs Repair': return Colors.orange;
      case 'Out of Service': return Colors.red;
      case 'Under Maintenance': return Colors.blue;
      default: return Colors.grey;
    }
  }

  void _showTaskHistoryDetails(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task['title']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Task ID', task['id']),
              _buildDetailRow('Completed Date', task['completedDate']),
              _buildDetailRow('Completed Time', task['completedTime']),
              _buildDetailRow('Duration', task['duration']),
              _buildDetailRow('Location', task['location']),
              _buildDetailRow('Category', task['category']),
              Row(
                children: [
                  const Text('Rating: ', style: TextStyle(fontWeight: FontWeight.w500)),
                  _buildRatingStars(task['rating']),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(task['notes'] ?? 'No notes available'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEquipmentHistoryDetails(Map<String, dynamic> equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(equipment['name']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Equipment ID', equipment['id']),
              _buildDetailRow('QR Code', equipment['qrCode']),
              _buildDetailRow('Current Status', equipment['status']),
              _buildDetailRow('Previous Status', equipment['previousStatus']),
              _buildDetailRow('Last Scanned', equipment['lastScanned']),
              _buildDetailRow('Location', equipment['location']),
              _buildDetailRow('Maintenance Type', equipment['maintenanceType']),
              _buildDetailRow('Technician', equipment['technician']),
              const SizedBox(height: 12),
              const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(equipment['notes'] ?? 'No notes available'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReportHistoryDetails(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report['title']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Report ID', report['id']),
              _buildDetailRow('Type', report['type']),
              _buildDetailRow('Status', report['status']),
              _buildDetailRow('Submitted Date', report['submittedDate']),
              _buildDetailRow('Submitted Time', report['submittedTime']),
              _buildDetailRow('Recipient', report['recipient']),
              const SizedBox(height: 12),
              const Text('Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(report['summary']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report downloaded!')),
              );
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
