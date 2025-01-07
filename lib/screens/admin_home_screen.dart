import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'forms_screen.dart';
import 'job_list_screen.dart';
import 'job_listings_screen.dart';
import 'pending_screen.dart';
import 'applicants_screen.dart';
import '../modal/profile_modal.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  bool isSidebarOpen = true;
  bool isNotificationVisible = false;
  bool isDropdownOpen = false;

  final GlobalKey dropdownKey = GlobalKey();

  void _toggleDropdown() {
    setState(() {
      isDropdownOpen = !isDropdownOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSidebarOpen ? 250 : 0, // 0 when closed, 250 when open
            child: Container(
              color: Colors.white,
              child: isSidebarOpen
                  ? Column(
                      children: [
                        const SizedBox(height: 16),
                        // "X" button at top-right of sidebar
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 24),
                            onPressed: () {
                              setState(() => isSidebarOpen = false);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Sidebar items
                        Expanded(
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.dashboard, size: 20),
                                title: const Text(
                                  'Home',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {},
                              ),
                              ListTile(
                                leading: const Icon(Icons.work, size: 20),
                                title: const Text(
                                  'Jobs',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const JobListingsScreen(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.list, size: 20),
                                title: const Text(
                                  'List',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const JobListScreen(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading:
                                    const Icon(Icons.description, size: 20),
                                title: const Text(
                                  'Forms',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FormsScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 20),
                        // Admin info at bottom
                        const Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 120),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage('assets/image.png'),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Admin User',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'admin@example.com',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      // Top bar (Admin and Notification Bar)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (!isSidebarOpen)
                                IconButton(
                                  icon: const Icon(Icons.menu, size: 24),
                                  onPressed: () {
                                    setState(() => isSidebarOpen = true);
                                  },
                                ),
                              const SizedBox(width: 8),
                              const Text(
                                'Dashboard',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications),
                                onPressed: () {
                                  setState(() {
                                    isNotificationVisible =
                                        !isNotificationVisible;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                key: dropdownKey,
                                onTap: _toggleDropdown,
                                child: Row(
                                  children: [
                                    const Text(
                                      'Admin',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      isDropdownOpen
                                          ? Icons.arrow_drop_down
                                          : Icons.arrow_right,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 90),
                      // Stat Cards
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/employees'),
                            child: _buildStatCard(
                              'Employees',
                              '250',
                              Icons.people,
                              Colors.green,
                              isWideScreen,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/interview'),
                            child: _buildStatCard(
                              'Interviews',
                              '150',
                              Icons.assignment,
                              Colors.orange,
                              isWideScreen,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ApplicantsScreen(),
                                ),
                              );
                            },
                            child: _buildStatCard(
                              'Applicants',
                              '120',
                              Icons.person_add,
                              Colors.red,
                              isWideScreen,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PendingScreen(),
                                ),
                              );
                            },
                            child: _buildStatCard(
                              'Pending',
                              '25',
                              Icons.hourglass_empty,
                              Colors.grey,
                              isWideScreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      _buildGraphCard(screenWidth),
                    ],
                  ),
                  // Dropdown Positioned Below Admin Label
                  if (isDropdownOpen)
                    Positioned(
                      top: 60,
                      right: 20,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: const Text('Profile'),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const ProfileModal();
                                    },
                                  );
                                  setState(() {
                                    isDropdownOpen = false;
                                  });
                                },
                              ),
                              ListTile(
                                title: const Text('Settings'),
                                onTap: () {
                                  setState(() {
                                    isDropdownOpen = false;
                                  });
                                },
                              ),
                              ListTile(
                                title: const Text('Logout'),
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, '/');
                                },
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isWideScreen,
  ) {
    return Container(
      // Adjusted from 290 to 300 for these boxes to be even wider
      width: isWideScreen ? 290 : double.infinity,
      height: isWideScreen ? 140 : 160,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphCard(double width) {
    return Container(
      // Slightly reduced from (width * 0.7) to (width * 0.65)
      // for a smaller chart to align better with the bigger stat boxes.
      width: (width * 0.65) - 32,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hires per month',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SizedBox(
              height: 400,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[200],
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec'
                          ];
                          if (value.toInt() < months.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                months[value.toInt()],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 10),
                        FlSpot(1, 25),
                        FlSpot(2, 45),
                        FlSpot(3, 30),
                        FlSpot(4, 60),
                        FlSpot(5, 20),
                        FlSpot(6, 35),
                        FlSpot(7, 40),
                        FlSpot(8, 35),
                        FlSpot(9, 35),
                        FlSpot(10, 40),
                        FlSpot(11, 45),
                      ],
                      isCurved: true,
                      color: Color(0xFF358873),
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF358873).withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}