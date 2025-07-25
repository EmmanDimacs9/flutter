// ENHANCED PROFILE PAGE
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  String userName = 'John Doe';
  String userEmail = 'john.doe@ict.com';
  String userDepartment = 'Technical Support';
  String userPhone = '+1 234 567 8900';
  String userEmployeeId = 'EMP001';
  String userJoinDate = '2023-06-15';
  String userRole = 'Senior Technician';
  
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  // Performance Stats
  final Map<String, dynamic> performanceStats = {
    'tasksCompleted': 47,
    'equipmentScanned': 156,
    'averageRating': 4.8,
    'responseTime': '15 min',
    'completionRate': 94,
  };

  // Recent Achievements
  final List<Map<String, dynamic>> achievements = [
    {
      'title': 'Speed Demon',
      'description': 'Completed 10 tasks in one day',
      'icon': Icons.flash_on,
      'color': Colors.orange,
      'date': '2024-01-15',
    },
    {
      'title': 'Quality Expert',
      'description': 'Maintained 5-star rating for 30 days',
      'icon': Icons.star,
      'color': Colors.amber,
      'date': '2024-01-10',
    },
    {
      'title': 'Equipment Master',
      'description': 'Scanned 100+ equipment items',
      'icon': Icons.qr_code_scanner,
      'color': Colors.blue,
      'date': '2024-01-05',
    },
  ];

  // Settings
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  bool soundEnabled = true;
  String selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('user_email') ?? 'technician@ict.com';
      notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
      soundEnabled = prefs.getBool('sound_enabled') ?? true;
      selectedLanguage = prefs.getString('selected_language') ?? 'English';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Enhanced Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[400]!, Colors.teal[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.teal[100],
                          child: const Icon(Icons.person, size: 50, color: Colors.teal),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userRole,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'ID: $userEmployeeId',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Performance Stats
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Performance Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard('Tasks Completed', '${performanceStats['tasksCompleted']}', Icons.task_alt, Colors.green),
                _buildStatCard('Equipment Scanned', '${performanceStats['equipmentScanned']}', Icons.qr_code_scanner, Colors.blue),
                _buildStatCard('Average Rating', '${performanceStats['averageRating']}/5', Icons.star, Colors.amber),
                _buildStatCard('Response Time', performanceStats['responseTime'], Icons.speed, Colors.orange),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Recent Achievements
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Achievements',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => _showAllAchievements(),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  return _buildAchievementCard(achievement);
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Profile Information
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            
            _buildEnhancedInfoCard('Email', userEmail, Icons.email, () => _editField('Email', userEmail)),
            _buildEnhancedInfoCard('Department', userDepartment, Icons.business, null),
            _buildEnhancedInfoCard('Phone', userPhone, Icons.phone, () => _editField('Phone', userPhone)),
            _buildEnhancedInfoCard('Join Date', userJoinDate, Icons.calendar_today, null),
            
            const SizedBox(height: 24),
            
            // Settings Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Settings & Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            
            _buildSettingsCard('Notifications', Icons.notifications, 
              Switch(
                value: notificationsEnabled,
                onChanged: (value) => _updateSetting('notifications', value),
                activeColor: Colors.teal,
              ),
            ),
            _buildSettingsCard('Sound Effects', Icons.volume_up,
              Switch(
                value: soundEnabled,
                onChanged: (value) => _updateSetting('sound', value),
                activeColor: Colors.teal,
              ),
            ),
            _buildSettingsTile('Language', Icons.language, selectedLanguage, () => _showLanguageDialog()),
            _buildSettingsTile('Change Password', Icons.lock, '', () => _showChangePasswordDialog()),
            _buildSettingsTile('Privacy Settings', Icons.privacy_tip, '', () => _showPrivacySettings()),
            _buildSettingsTile('Help & Support', Icons.help, '', () => _showHelpSupport()),
            _buildSettingsTile('About App', Icons.info, 'Version 1.0.0', () => _showAboutDialog()),
            
            const SizedBox(height: 24),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _showLogoutConfirmation,
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achievement['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: achievement['color'].withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(achievement['icon'], color: achievement['color'], size: 24),
          const SizedBox(height: 8),
          Text(
            achievement['title'],
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            achievement['description'],
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedInfoCard(String title, String value, IconData icon, VoidCallback? onEdit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.teal, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (onEdit != null)
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 20),
                color: Colors.grey[600],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(String title, IconData icon, Widget trailing) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, String subtitle, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _editField(String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field,
            border: const OutlineInputBorder(),
          ),
          keyboardType: field == 'Phone' ? TextInputType.phone : TextInputType.text,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (field == 'Email') {
                  userEmail = controller.text;
                } else if (field == 'Phone') {
                  userPhone = controller.text;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$field updated successfully!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _updateSetting(String setting, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (setting == 'notifications') {
        notificationsEnabled = value;
        prefs.setBool('notifications_enabled', value);
      } else if (setting == 'sound') {
        soundEnabled = value;
        prefs.setBool('sound_enabled', value);
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${setting.capitalize()} ${value ? 'enabled' : 'disabled'}')),
    );
  }

  void _showLanguageDialog() {
    final languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) {
            return RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Language changed to $value')),
                );
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
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
              if (newPasswordController.text == confirmPasswordController.text) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password changed successfully!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match!')),
                );
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy settings coming soon!')),
    );
  }

  void _showHelpSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help? Contact us:'),
            SizedBox(height: 12),
            Text('📧 support@ict.com'),
            Text('📞 +1 (555) 123-4567'),
            Text('🌐 www.ict-support.com'),
            SizedBox(height: 12),
            Text('Office Hours: Mon-Fri 9AM-5PM'),
          ],
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
                const SnackBar(content: Text('Opening support chat...')),
              );
            },
            child: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'ICT Services Management',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.computer, size: 48, color: Colors.teal),
      children: const [
        Text('A comprehensive solution for managing ICT equipment and services.'),
        SizedBox(height: 8),
        Text('© 2024 ICT Services Department'),
      ],
    );
  }

  void _showAllAchievements() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Achievements'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return ListTile(
                leading: Icon(achievement['icon'], color: achievement['color']),
                title: Text(achievement['title']),
                subtitle: Text(achievement['description']),
                trailing: Text(achievement['date']),
              );
            },
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

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('remember_me');
              await prefs.remove('user_type');
              await prefs.remove('user_email');
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
