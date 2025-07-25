// ENHANCED TASK PAGE
import 'package:flutter/material.dart';
class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> with TickerProviderStateMixin {
  String selectedFilter = 'All';
  String selectedSort = 'Due Date';
  final List<String> filters = ['All', 'Pending', 'In Progress', 'Completed', 'Overdue'];
  final List<String> sortOptions = ['Due Date', 'Priority', 'Created Date', 'Status'];
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> tasks = [
    {
      'id': 'T001',
      'title': 'Repair Computer Lab A - PC #5',
      'description': 'Monitor not displaying properly, possible graphics card issue',
      'status': 'Pending',
      'priority': 'High',
      'location': 'Computer Lab A',
      'assignedDate': '2024-01-15',
      'dueDate': '2024-01-17',
      'estimatedTime': '2 hours',
      'assignedBy': 'John Manager',
      'category': 'Hardware',
      'progress': 0,
    },
    {
      'id': 'T002',
      'title': 'Install Software Updates',
      'description': 'Update all computers in Library with latest security patches',
      'status': 'In Progress',
      'priority': 'Medium',
      'location': 'Library',
      'assignedDate': '2024-01-14',
      'dueDate': '2024-01-16',
      'estimatedTime': '4 hours',
      'assignedBy': 'Sarah Admin',
      'category': 'Software',
      'progress': 65,
    },
    {
      'id': 'T003',
      'title': 'Network Troubleshooting',
      'description': 'Internet connectivity issues in Room 201, check network cables',
      'status': 'Completed',
      'priority': 'High',
      'location': 'Room 201',
      'assignedDate': '2024-01-13',
      'dueDate': '2024-01-15',
      'estimatedTime': '1.5 hours',
      'assignedBy': 'Mike IT',
      'category': 'Network',
      'progress': 100,
    },
    {
      'id': 'T004',
      'title': 'Printer Maintenance',
      'description': 'Regular maintenance for office printers, replace toner and clean',
      'status': 'Overdue',
      'priority': 'Low',
      'location': 'Main Office',
      'assignedDate': '2024-01-10',
      'dueDate': '2024-01-12',
      'estimatedTime': '30 minutes',
      'assignedBy': 'Lisa Office',
      'category': 'Maintenance',
      'progress': 0,
    },
    {
      'id': 'T005',
      'title': 'Setup New Workstation',
      'description': 'Configure new employee workstation with required software',
      'status': 'Pending',
      'priority': 'Medium',
      'location': 'HR Department',
      'assignedDate': '2024-01-16',
      'dueDate': '2024-01-18',
      'estimatedTime': '3 hours',
      'assignedBy': 'Tom HR',
      'category': 'Setup',
      'progress': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredAndSortedTasks();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Tasks',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${filteredTasks.length} tasks',
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Quick Stats Row
            Row(
              children: [
                Expanded(child: _buildQuickStat('Pending', _getTaskCountByStatus('Pending'), Colors.orange)),
                const SizedBox(width: 8),
                Expanded(child: _buildQuickStat('In Progress', _getTaskCountByStatus('In Progress'), Colors.blue)),
                const SizedBox(width: 8),
                Expanded(child: _buildQuickStat('Completed', _getTaskCountByStatus('Completed'), Colors.green)),
                const SizedBox(width: 8),
                Expanded(child: _buildQuickStat('Overdue', _getTaskCountByStatus('Overdue'), Colors.red)),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Filter and Sort Row
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      itemBuilder: (context, index) {
                        final filter = filters[index];
                        final isSelected = selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedFilter = filter;
                              });
                            },
                            selectedColor: Colors.teal.withOpacity(0.3),
                            checkmarkColor: Colors.teal,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort),
                  onSelected: (value) {
                    setState(() {
                      selectedSort = value;
                    });
                  },
                  itemBuilder: (context) => sortOptions.map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Row(
                        children: [
                          Icon(
                            selectedSort == option ? Icons.check : Icons.sort,
                            size: 16,
                            color: selectedSort == option ? Colors.teal : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(option),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Task List
            Expanded(
              child: filteredTasks.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return _buildEnhancedTaskCard(task, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTaskCard(Map<String, dynamic> task, int index) {
    Color statusColor = _getStatusColor(task['status']);
    Color priorityColor = _getPriorityColor(task['priority']);
    bool isOverdue = task['status'] == 'Overdue';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isOverdue ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isOverdue ? BorderSide(color: Colors.red.withOpacity(0.5), width: 1) : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _showTaskDetails(task),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(task['category']).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task['category'],
                      style: TextStyle(
                        color: _getCategoryColor(task['category']),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task['status'],
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
              
              // Title and Priority
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          task['priority'] == 'High' ? Icons.keyboard_arrow_up :
                          task['priority'] == 'Medium' ? Icons.remove : Icons.keyboard_arrow_down,
                          size: 12,
                          color: priorityColor,
                        ),
                        Text(
                          task['priority'],
                          style: TextStyle(
                            color: priorityColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                task['description'],
                style: const TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Progress Bar (for In Progress tasks)
              if (task['status'] == 'In Progress') ...[
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: task['progress'] / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${task['progress']}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              
              // Footer Info
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    task['location'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    task['estimatedTime'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    'Due: ${task['dueDate']}',
                    style: TextStyle(
                      color: isOverdue ? Colors.red : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Action Buttons
              Row(
                children: [
                  if (task['status'] == 'Pending')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _startTask(task),
                        icon: const Icon(Icons.play_arrow, size: 16),
                        label: const Text('Start Task'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  if (task['status'] == 'In Progress') ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateProgress(task),
                        icon: const Icon(Icons.update, size: 16),
                        label: const Text('Update'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _completeTask(task),
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text('Complete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                  if (task['status'] == 'Completed')
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Completed',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (task['status'] == 'Overdue')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _startTask(task),
                        icon: const Icon(Icons.priority_high, size: 16),
                        label: const Text('Start Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredAndSortedTasks() {
    List<Map<String, dynamic>> filtered = selectedFilter == 'All' 
        ? tasks 
        : tasks.where((task) => task['status'] == selectedFilter).toList();

    // Sort tasks
    filtered.sort((a, b) {
      switch (selectedSort) {
        case 'Priority':
          final priorityOrder = {'High': 3, 'Medium': 2, 'Low': 1};
          return priorityOrder[b['priority']]!.compareTo(priorityOrder[a['priority']]!);
        case 'Created Date':
          return DateTime.parse(b['assignedDate']).compareTo(DateTime.parse(a['assignedDate']));
        case 'Status':
          return a['status'].compareTo(b['status']);
        default: // Due Date
          return DateTime.parse(a['dueDate']).compareTo(DateTime.parse(b['dueDate']));
      }
    });

    return filtered;
  }

  int _getTaskCountByStatus(String status) {
    return tasks.where((task) => task['status'] == status).length;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending': return Colors.orange;
      case 'In Progress': return Colors.blue;
      case 'Completed': return Colors.green;
      case 'Overdue': return Colors.red;
      default: return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High': return Colors.red;
      case 'Medium': return Colors.orange;
      case 'Low': return Colors.green;
      default: return Colors.grey;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Hardware': return Colors.blue;
      case 'Software': return Colors.purple;
      case 'Network': return Colors.teal;
      case 'Maintenance': return Colors.orange;
      case 'Setup': return Colors.green;
      default: return Colors.grey;
    }
  }

  void _showTaskDetails(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task['title']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID', task['id']),
              _buildDetailRow('Status', task['status']),
              _buildDetailRow('Priority', task['priority']),
              _buildDetailRow('Category', task['category']),
              _buildDetailRow('Location', task['location']),
              _buildDetailRow('Assigned By', task['assignedBy']),
              _buildDetailRow('Assigned Date', task['assignedDate']),
              _buildDetailRow('Due Date', task['dueDate']),
              _buildDetailRow('Estimated Time', task['estimatedTime']),
              if (task['status'] == 'In Progress')
                _buildDetailRow('Progress', '${task['progress']}%'),
              const SizedBox(height: 12),
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(task['description']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (task['status'] != 'Completed')
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (task['status'] == 'Pending') {
                  _startTask(task);
                } else if (task['status'] == 'In Progress') {
                  _updateProgress(task);
                }
              },
              child: Text(task['status'] == 'Pending' ? 'Start Task' : 'Update Progress'),
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
            width: 100,
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

  void _startTask(Map<String, dynamic> task) {
    setState(() {
      task['status'] = 'In Progress';
      task['progress'] = 10;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Started task: ${task['title']}')),
    );
  }

  void _updateProgress(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) {
        double progress = task['progress'].toDouble();
        return StatefulBuilder(
          builder: (context, setStateSB) => AlertDialog(
            title: const Text('Update Progress'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Current Progress: ${progress.round()}%'),
                const SizedBox(height: 16),
                Slider(
                  value: progress,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: '${progress.round()}%',
                  onChanged: (value) {
                    setStateSB(() {
                      progress = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    task['progress'] = progress.round();
                    if (progress >= 100) {
                      task['status'] = 'Completed';
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Progress updated to ${progress.round()}%')),
                  );
                },
                child: const Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _completeTask(Map<String, dynamic> task) {
    setState(() {
      task['status'] = 'Completed';
      task['progress'] = 100;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Completed task: ${task['title']}')),
    );
  }
}
