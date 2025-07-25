import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isRemembered = prefs.getBool('remember_me') ?? false;
  final userType = prefs.getString('user_type') ?? '';
  
  String initialRoute = '/';
  if (isRemembered) {
    initialRoute = userType == 'technician' ? '/technician_home' : '/dashboard';
  }
  
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICT Services Management System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/register': (context) => const RegisterScreen(),
        '/technician_home': (context) => const TechnicianHomeScreen(),
      },
    );
  }
}

class LoginCredentials {
  final String email;
  final String password;
  LoginCredentials({required this.email, required this.password});

  Map<String, dynamic> validate() {
    // Admin credentials
    if (email == 'admin@ict.com' && password == 'password123') {
      return {'isValid': true, 'userType': 'admin'};
    }
    
    // Check if it's a registered technician email
    if (email.isNotEmpty && password.isNotEmpty) {
      // Simulate checking registered users - in real app, this would be from database
      if (email.contains('@') && password.length >= 6) {
        return {'isValid': true, 'userType': 'technician'};
      }
    }
    
    return {'isValid': false, 'userType': ''};
  }
}

class RegistrationData {
  final String fullName;
  final String email;
  final String password;
  final String department;
  final String phone;

  RegistrationData({
    required this.fullName,
    required this.email,
    required this.password,
    required this.department,
    required this.phone,
  });

  bool validate() {
    return fullName.isNotEmpty &&
        email.contains('@') &&
        password.length >= 6 &&
        department.isNotEmpty;
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorMessage;
  bool isLoading = false;
  bool rememberMe = false;

  void _handleLogin() async {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final credentials = LoginCredentials(
      email: emailController.text,
      password: passwordController.text,
    );

    final validationResult = credentials.validate();

    if (validationResult['isValid']) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', rememberMe);
      await prefs.setString('user_type', validationResult['userType']);
      await prefs.setString('user_email', emailController.text);

      if (!mounted) return;

      if (validationResult['userType'] == 'admin') {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/technician_home');
      }
    } else {
      setState(() {
        errorMessage = 'Invalid email or password';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A8D8A),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_forward, size: 48, color: Colors.black),
                const SizedBox(height: 16),
                const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Access the ICT Service Management System',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text('Remember me'),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Sign In'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/register'),
                  child: const Text("Don't have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  
  String selectedDepartment = '';
  String? errorMessage;
  String? successMessage;
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> departments = [
    'ICT Services',
    'Technical Support',
  ];

  void _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      errorMessage = null;
      successMessage = null;
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final registrationData = RegistrationData(
      fullName: fullNameController.text,
      email: emailController.text,
      password: passwordController.text,
      department: selectedDepartment,
      phone: phoneController.text,
    );

    if (registrationData.validate()) {
      setState(() {
        successMessage = 'Registration successful! You can now sign in as a technician.';
        isLoading = false;
      });

      _clearForm();

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      });
    } else {
      setState(() {
        errorMessage = 'Please fill in all required fields correctly';
        isLoading = false;
      });
    }
  }

  void _clearForm() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
    setState(() {
      selectedDepartment = '';
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A8D8A),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_add, size: 48, color: Colors.black),
                  const SizedBox(height: 16),
                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Join the ICT Service Management System',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  
                  TextFormField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    value: selectedDepartment.isEmpty ? null : selectedDepartment,
                    decoration: const InputDecoration(
                      labelText: 'Department *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                    ),
                    items: departments.map((String department) {
                      return DropdownMenuItem<String>(
                        value: department,
                        child: Text(department),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDepartment = newValue ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a department';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (Optional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password *',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password *',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: _validateConfirmPassword,
                  ),
                  const SizedBox(height: 16),
                  
                  if (errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  if (successMessage != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green[300]!),
                      ),
                      child: Text(
                        successMessage!,
                        style: const TextStyle(color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Create Account'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Already have an account? Sign in'),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  const Text(
                    'By creating an account, you agree to our Terms of Service and Privacy Policy',
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TechnicianHomeScreen extends StatefulWidget {
  const TechnicianHomeScreen({super.key});

  @override
  State<TechnicianHomeScreen> createState() => _TechnicianHomeScreenState();
}

class _TechnicianHomeScreenState extends State<TechnicianHomeScreen> {
  int _selectedIndex = 0; // Start with Home tab selected

  final List<Widget> _pages = [
    const HomePage(),
    const TaskPage(),
    const QRScannerPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remember_me');
    await prefs.remove('user_type');
    await prefs.remove('user_email');
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Technician'),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _logout,
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'My Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// HOME PAGE
// HOME PAGE - Enhanced with more features
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentAnnouncementIndex = 0;

  final List<Map<String, dynamic>> announcements = [
    {
      'title': 'System Maintenance Scheduled',
      'message': 'Network maintenance on Jan 20, 2024 from 2-4 PM',
      'type': 'warning',
      'icon': Icons.build,
    },
    {
      'title': 'New Equipment Arrived',
      'message': '15 new laptops have been added to inventory',
      'type': 'info',
      'icon': Icons.laptop,
    },
    {
      'title': 'Training Session',
      'message': 'QR Scanner training tomorrow at 10 AM',
      'type': 'success',
      'icon': Icons.school,
    },
  ];

  final List<Map<String, dynamic>> recentActivities = [
    {
      'action': 'Scanned Equipment',
      'item': 'Computer Lab A - PC #12',
      'time': '2 hours ago',
      'status': 'Working',
    },
    {
      'action': 'Completed Task',
      'item': 'Network Troubleshooting',
      'time': '4 hours ago',
      'status': 'Completed',
    },
    {
      'action': 'Updated Status',
      'item': 'Printer - Main Office',
      'time': '6 hours ago',
      'status': 'Needs Repair',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dashboard refreshed!')),
        );
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section with Time-based Greeting
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[400]!, Colors.teal[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.waving_hand, color: Colors.white, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Ready to manage equipment today?',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.today, color: Colors.white, size: 20),
                        const SizedBox(height: 4),
                        Text(
                          _getCurrentDate(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Announcements Carousel
            const Text(
              'Announcements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            SizedBox(
              height: 100,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentAnnouncementIndex = index;
                  });
                },
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  return _buildAnnouncementCard(announcement);
                },
              ),
            ),
            
            // Page Indicators
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                announcements.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentAnnouncementIndex == index
                        ? Colors.teal
                        : Colors.grey[300],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Enhanced Quick Stats
            const Text(
              'Today\'s Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildEnhancedStatCard(
                    'Pending Tasks',
                    '3',
                    Icons.pending_actions,
                    Colors.orange,
                    '+2 from yesterday',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEnhancedStatCard(
                    'Completed',
                    '7',
                    Icons.check_circle,
                    Colors.green,
                    '85% completion rate',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildEnhancedStatCard(
                    'Equipment Scanned',
                    '12',
                    Icons.qr_code_scanner,
                    Colors.blue,
                    'Last scan: 2h ago',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEnhancedStatCard(
                    'Issues Reported',
                    '2',
                    Icons.report_problem,
                    Colors.red,
                    'Needs attention',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Recent Activity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full activity log
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            ...recentActivities.map((activity) => _buildActivityItem(activity)),
            
            const SizedBox(height: 24),
            
            // Quick Actions Grid
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildEnhancedActionCard(
                  'Scan Equipment',
                  Icons.qr_code_scanner,
                  Colors.blue,
                  'Quick scan mode',
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening QR Scanner...')),
                    );
                  },
                ),
                _buildEnhancedActionCard(
                  'View Tasks',
                  Icons.assignment,
                  Colors.purple,
                  '3 pending tasks',
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening Tasks...')),
                    );
                  },
                ),
                _buildEnhancedActionCard(
                  'Equipment List',
                  Icons.devices,
                  Colors.teal,
                  '45 total items',
                  () {
                    _showEquipmentListDialog();
                  },
                ),
                _buildEnhancedActionCard(
                  'Report Issue',
                  Icons.report_problem,
                  Colors.red,
                  'Quick report',
                  () {
                    _showReportIssueDialog();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[now.month - 1]} ${now.day}';
  }

  Widget _buildAnnouncementCard(Map<String, dynamic> announcement) {
    Color cardColor;
    switch (announcement['type']) {
      case 'warning':
        cardColor = Colors.orange;
        break;
      case 'info':
        cardColor = Colors.blue;
        break;
      case 'success':
        cardColor = Colors.green;
        break;
      default:
        cardColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(announcement['icon'], color: cardColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  announcement['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  announcement['message'],
                  style: const TextStyle(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatCard(String title, String count, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
              Text(
                count,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    Color statusColor;
    switch (activity['status']) {
      case 'Working':
        statusColor = Colors.green;
        break;
      case 'Completed':
        statusColor = Colors.blue;
        break;
      case 'Needs Repair':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${activity['action']}: ${activity['item']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  activity['time'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
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
              activity['status'],
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedActionCard(String title, IconData icon, Color color, String subtitle, VoidCallback onTap) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEquipmentListDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Equipment List'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildEquipmentListItem('Computer Lab A - PC #1', 'Working', Colors.green),
              _buildEquipmentListItem('Computer Lab A - PC #2', 'Working', Colors.green),
              _buildEquipmentListItem('Printer - Main Office', 'Needs Repair', Colors.orange),
              _buildEquipmentListItem('Projector - Room 201', 'Working', Colors.green),
              _buildEquipmentListItem('Router - IT Room', 'Under Maintenance', Colors.blue),
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

  Widget _buildEquipmentListItem(String name, String status, Color statusColor) {
    return ListTile(
      leading: Icon(Icons.devices, color: Colors.teal),
      title: Text(name, style: const TextStyle(fontSize: 14)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: statusColor,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showReportIssueDialog() {
    final issueController = TextEditingController();
    final locationController = TextEditingController();
    String selectedPriority = 'Medium';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: ['Low', 'Medium', 'High'].map((priority) {
                return DropdownMenuItem(value: priority, child: Text(priority));
              }).toList(),
              onChanged: (value) => selectedPriority = value!,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: issueController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Describe the issue',
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Issue reported successfully!')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

// TASK PAGE
class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Pending', 'In Progress', 'Completed'];

  final List<Map<String, dynamic>> tasks = [
    {
      'id': 'T001',
      'title': 'Repair Computer Lab A - PC #5',
      'description': 'Monitor not displaying properly',
      'status': 'Pending',
      'priority': 'High',
      'location': 'Computer Lab A',
      'assignedDate': '2024-01-15',
      'dueDate': '2024-01-17',
    },
    {
      'id': 'T002',
      'title': 'Install Software Updates',
      'description': 'Update all computers in Library',
      'status': 'In Progress',
      'priority': 'Medium',
      'location': 'Library',
      'assignedDate': '2024-01-14',
      'dueDate': '2024-01-16',
    },
    {
      'id': 'T003',
      'title': 'Network Troubleshooting',
      'description': 'Internet connectivity issues in Room 201',
      'status': 'Completed',
      'priority': 'High',
      'location': 'Room 201',
      'assignedDate': '2024-01-13',
      'dueDate': '2024-01-15',
    },
    {
      'id': 'T004',
      'title': 'Printer Maintenance',
      'description': 'Regular maintenance for office printers',
      'status': 'Pending',
      'priority': 'Low',
      'location': 'Main Office',
      'assignedDate': '2024-01-15',
      'dueDate': '2024-01-20',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTasks = selectedFilter == 'All' 
        ? tasks 
        : tasks.where((task) => task['status'] == selectedFilter).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'My Tasks',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Filter Chips
          SizedBox(
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
          
          const SizedBox(height: 16),
          
          // Task List
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return _buildTaskCard(task);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    Color statusColor;
    switch (task['status']) {
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'In Progress':
        statusColor = Colors.blue;
        break;
      case 'Completed':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    Color priorityColor;
    switch (task['priority']) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      case 'Low':
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 8),
            Text(
              task['description'],
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  task['location'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task['priority'],
                    style: TextStyle(
                      color: priorityColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Due: ${task['dueDate']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                if (task['status'] != 'Completed')
                  TextButton(
                    onPressed: () {
                      // Update task status
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task ${task['id']} updated!')),
                      );
                    },
                    child: const Text('Update Status'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// HISTORY PAGE
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String selectedTab = 'Tasks';
  final List<String> tabs = ['Tasks', 'Equipment', 'Reports'];

  final List<Map<String, dynamic>> taskHistory = [
    {
      'id': 'T003',
      'title': 'Network Troubleshooting',
      'completedDate': '2024-01-15',
      'duration': '2 hours',
      'status': 'Completed',
    },
    {
      'id': 'T002',
      'title': 'Software Installation',
      'completedDate': '2024-01-14',
      'duration': '1.5 hours',
      'status': 'Completed',
    },
    {
      'id': 'T001',
      'title': 'Hardware Repair',
      'completedDate': '2024-01-13',
      'duration': '3 hours',
      'status': 'Completed',
    },
  ];

  final List<Map<String, dynamic>> equipmentHistory = [
    {
      'id': 'EQ001',
      'name': 'Computer Lab A - PC #5',
      'lastScanned': '2024-01-15 14:30',
      'status': 'Working',
      'location': 'Computer Lab A',
    },
    {
      'id': 'EQ002',
      'name': 'Printer - Main Office',
      'lastScanned': '2024-01-14 10:15',
      'status': 'Needs Repair',
      'location': 'Main Office',
    },
    {
      'id': 'EQ003',
      'name': 'Projector - Room 201',
      'lastScanned': '2024-01-13 16:45',
      'status': 'Working',
      'location': 'Room 201',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'History',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: tabs.map((tab) {
                final isSelected = selectedTab == tab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = tab;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        tab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Content
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 'Tasks':
        return _buildTaskHistory();
      case 'Equipment':
        return _buildEquipmentHistory();
      case 'Reports':
        return _buildReportsHistory();
      default:
        return const Center(child: Text('No content available'));
    }
  }

  Widget _buildTaskHistory() {
    return ListView.builder(
      itemCount: taskHistory.length,
      itemBuilder: (context, index) {
        final task = taskHistory[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.check, color: Colors.white),
            ),
            title: Text(task['title']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Completed: ${task['completedDate']}'),
                Text('Duration: ${task['duration']}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Show task details
            },
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
        final statusColor = equipment['status'] == 'Working' ? Colors.green : Colors.orange;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor.withOpacity(0.2),
              child: Icon(Icons.devices, color: statusColor),
            ),
            title: Text(equipment['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Last Scanned: ${equipment['lastScanned']}'),
                Text('Location: ${equipment['location']}'),
              ],
            ),
            trailing: Container(
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
          ),
        );
      },
    );
  }

  Widget _buildReportsHistory() {
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
}

// PROFILE PAGE
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'John Doe';
  String userEmail = 'john.doe@ict.com';
  String userDepartment = 'Technical Support';
  String userPhone = '+1 234 567 8900';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('user_email') ?? 'technician@ict.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal[400]!, Colors.teal[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.teal),
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
                  userDepartment,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Profile Information
          Expanded(
            child: ListView(
              children: [
                _buildInfoCard('Email', userEmail, Icons.email),
                _buildInfoCard('Department', userDepartment, Icons.business),
                _buildInfoCard('Phone', userPhone, Icons.phone),
                
                const SizedBox(height: 24),
                
                // Settings Section
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                _buildSettingsTile(
                  'Edit Profile',
                  Icons.edit,
                  () {
                    _showEditProfileDialog();
                  },
                ),
                _buildSettingsTile(
                  'Change Password',
                  Icons.lock,
                  () {
                    _showChangePasswordDialog();
                  },
                ),
                _buildSettingsTile(
                  'Notifications',
                  Icons.notifications,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification settings coming soon!')),
                    );
                  },
                ),
                _buildSettingsTile(
                  'Help & Support',
                  Icons.help,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help & Support coming soon!')),
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('remember_me');
                      await prefs.remove('user_type');
                      await prefs.remove('user_email');
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal),
            const SizedBox(width: 16),
            Column(
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
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: userName);
    final phoneController = TextEditingController(text: userPhone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
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
              setState(() {
                userName = nameController.text;
                userPhone = phoneController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
            },
            child: const Text('Save'),
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
}

// QR SCANNER PAGE (keeping the existing one)
class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  String qrData = '11024';
  
  final TextEditingController roomController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  String selectedStatus = '';
  String lastMaintenance = '';

  final List<String> statusOptions = [
    'Working',
    'Needs Repair',
    'Out of Service',
    'Under Maintenance'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EQUIPMENT QR SCANNER',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          
          // QR Scanner Area (Mock UI)
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.info_outline,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Manual Entry Button
          Center(
            child: TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Manual entry feature coming soon!')),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.purple),
              label: const Text(
                'UPLOAD / ENTER QR MANUALLY',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Form Fields
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormField('Room:', roomController),
                  const SizedBox(height: 16),
                  
                  _buildDropdownField('Status:', selectedStatus, statusOptions, (value) {
                    setState(() {
                      selectedStatus = value ?? '';
                    });
                  }),
                  const SizedBox(height: 16),
                  
                  _buildReadOnlyField('Last Maintenance:', lastMaintenance.isEmpty ? '-' : lastMaintenance),
                  const SizedBox(height: 16),
                  
                  _buildFormField('Remarks:', remarksController),
                  const SizedBox(height: 24),
                  
                  // Raw QR Data
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Raw QR Data:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          qrData,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Equipment data saved!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Save Equipment Data'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[50],
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    roomController.dispose();
    remarksController.dispose();
    super.dispose();
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remember_me');
    await prefs.remove('user_type');
    await prefs.remove('user_email');
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ICT Dashboard'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.dashboard_customize, color: Colors.teal, size: 30),
                SizedBox(width: 8),
                Text(
                  'Welcome, Admin!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DashboardCard(title: "Equipment", count: "12", icon: Icons.computer),
                _DashboardCard(title: "Tickets", count: "5", icon: Icons.report_problem),
                _DashboardCard(title: "Alerts", count: "2", icon: Icons.notifications_active),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: const [
                  _DashboardAction(label: "Manage Tasks", icon: Icons.task),
                  _DashboardAction(label: "View Equipment", icon: Icons.devices),
                  _DashboardAction(label: "Submit Report", icon: Icons.send),
                  _DashboardAction(label: "System Logs", icon: Icons.receipt_long),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;

  const _DashboardCard({
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal[50],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.teal, size: 24),
            const SizedBox(height: 6),
            Text(
              count,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardAction extends StatelessWidget {
  final String label;
  final IconData icon;

  const _DashboardAction({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label clicked!')),
          );
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.teal),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
