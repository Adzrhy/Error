import 'package:flutter/material.dart';
import 'home_section.dart';
import 'job_listings_screen.dart'; // Import JobListingsContent
import 'forms_screen.dart'; // Import FormsScreen
import 'job_list_screen.dart'; // Import JobListScreen
import '../modal/profile_modal.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  bool isSidebarOpen = true;
  bool isNotificationVisible = false;
  bool isDropdownOpen = false;
  String selectedMenu = 'Home'; // Default menu selection

  final GlobalKey dropdownKey = GlobalKey();
  final Duration transitionDuration = const Duration(milliseconds: 300);

  void _toggleDropdown() {
    setState(() {
      isDropdownOpen = !isDropdownOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.dashboard, size: 20),
                                title: const Text(
                                  'Home',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedMenu = 'Home';
                                  });
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.work, size: 20),
                                title: const Text(
                                  'Jobs',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedMenu = 'Jobs';
                                  });
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.list, size: 20),
                                title: const Text(
                                  'List',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedMenu = 'List';
                                  });
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
                                  setState(() {
                                    selectedMenu = 'Forms';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 20),
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
                      // Top bar
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
                              Text(
                                selectedMenu == 'Home'
                                    ? 'Dashboard'
                                    : selectedMenu == 'Jobs'
                                        ? 'Jobs Listings'
                                        : selectedMenu == 'List'
                                            ? 'Job List'
                                            : 'Forms Management',
                                style: const TextStyle(
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
                      const SizedBox(height: 16),
                      // Main Content based on selected menu
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: selectedMenu == 'Home'
                              ? const HomeSection() // Home content
                              : selectedMenu == 'Jobs'
                                  ? const JobListingsContent() // Jobs content
                                  : selectedMenu == 'List'
                                      ? const JobListScreen() // List content
                                      : const FormsScreen(), // Forms content
                        ),
                      ),
                    ],
                  ),
                  // Dropdown menu
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
}
