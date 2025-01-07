import 'package:flutter/material.dart';

class ProfileModal extends StatefulWidget {
  const ProfileModal({super.key});

  @override
  State<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  final TextEditingController departmentController =
      TextEditingController(text: 'Human Resources');
  final TextEditingController roleController =
      TextEditingController(text: 'Administrative');
  final TextEditingController firstNameController =
      TextEditingController(text: 'Al-adzrhy');
  final TextEditingController lastNameController =
      TextEditingController(text: 'Jalman');
  final TextEditingController dobController =
      TextEditingController(text: '12/12/1986');
  final TextEditingController emailController =
      TextEditingController(text: 'al-adzrhy.jalman@one.uz.edu.ph');
  final TextEditingController phoneController =
      TextEditingController(text: '+1 (555) 789-0123');
  final TextEditingController noteController = TextEditingController();

  bool isEditingPersonalInfo = false;
  bool isEditingDepartmentRole = false;
  bool isEditingNote = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture and Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile_picture.jpg'),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Al-adzrhy Jalman',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'General Manager',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone Number: ${phoneController.text}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Email: ${emailController.text}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
                const SizedBox(width: 32),

                // Editable Fields
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        title: 'Personal Information',
                        isEditing: isEditingPersonalInfo,
                        onEditToggle: () {
                          setState(() {
                            isEditingPersonalInfo = !isEditingPersonalInfo;
                          });
                        },
                        content: Column(
                          children: [
                            _buildEditableRow('First Name', firstNameController,
                                isEditingPersonalInfo),
                            _buildEditableRow('Last Name', lastNameController,
                                isEditingPersonalInfo),
                            _buildEditableRow('Date of Birth', dobController,
                                isEditingPersonalInfo),
                            _buildEditableRow('Email Address', emailController,
                                isEditingPersonalInfo),
                            _buildEditableRow('Phone Number', phoneController,
                                isEditingPersonalInfo),
                            _buildStaticRow('User Role', roleController.text),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: 'Department and Role',
                        isEditing: isEditingDepartmentRole,
                        onEditToggle: () {
                          setState(() {
                            isEditingDepartmentRole = !isEditingDepartmentRole;
                          });
                        },
                        content: Column(
                          children: [
                            _buildEditableRow('Department',
                                departmentController, isEditingDepartmentRole),
                            _buildEditableRow('Role', roleController,
                                isEditingDepartmentRole),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: 'Note',
                        isEditing: isEditingNote,
                        onEditToggle: () {
                          setState(() {
                            isEditingNote = !isEditingNote;
                          });
                        },
                        content: Column(
                          children: [
                            _buildEditableRow(
                                'Note', noteController, isEditingNote,
                                maxLines: 3),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required bool isEditing,
    required VoidCallback onEditToggle,
    required Widget content,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(isEditing ? Icons.save : Icons.edit),
                  onPressed: onEditToggle,
                ),
              ],
            ),
            const Divider(),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildEditableRow(
      String label, TextEditingController controller, bool isEditable,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: isEditable
                ? TextField(
                    controller: controller,
                    maxLines: maxLines,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(controller.text),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
