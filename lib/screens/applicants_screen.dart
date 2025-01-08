import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApplicantsScreen extends StatefulWidget {
  const ApplicantsScreen({Key? key}) : super(key: key);

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  String searchQuery = '';
  String selectedFilter = 'All';
  int currentPage = 1;
  final int itemsPerPage = 5;
  bool isLoading = true;

  List<Map<String, dynamic>> applicants = [];

  @override
  void initState() {
    super.initState();
    fetchApprovedApplicants();
  }

  Future<void> fetchApprovedApplicants() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client
          .from('applications')
          .select('id, profiles(given_name, sur_name), stage')
          .eq('status', 'Approved')
          .order('id', ascending: true) as List<dynamic>;

      setState(() {
        applicants = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching applicants: $error')),
      );
    }
  }

  List<Map<String, dynamic>> get filteredApplicants {
    List<Map<String, dynamic>> filteredList = applicants;

    if (selectedFilter != 'All') {
      filteredList = filteredList.where((applicant) {
        switch (selectedFilter) {
          case 'Screening':
            return applicant['stage'] == 1;
          case 'Pre-employment Exam':
            return applicant['stage'] == 2;
          case 'Hiring Stage':
            return applicant['stage'] == 3;
          default:
            return true;
        }
      }).toList();
    }

    if (searchQuery.isNotEmpty) {
      filteredList = filteredList.where((applicant) {
        final fullName =
            '${applicant['profiles']['given_name']} ${applicant['profiles']['sur_name']}';
        return fullName.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filteredList;
  }

  List<Map<String, dynamic>> get paginatedApplicants {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return filteredApplicants.sublist(
        startIndex,
        endIndex > filteredApplicants.length
            ? filteredApplicants.length
            : endIndex);
  }

  List<String> get progressiveFilters {
    return ['All', 'Screening', 'Pre-employment Exam', 'Hiring Stage'];
  }

  void showStageModal(BuildContext context, String name, int stage) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800, minHeight: 300),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$name Progress',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Applicant Progress',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildStep(context, 'Screening', Icons.search, stage >= 1,
                        () => debugPrint('Screening clicked')),
                    buildLine(),
                    buildStep(
                      context,
                      'Pre-employment Exam',
                      Icons.edit,
                      stage >= 2,
                      () => debugPrint('Pre-employment Exam clicked'),
                    ),
                    buildLine(),
                    buildStep(
                      context,
                      'Hiring Stage',
                      Icons.work,
                      stage >= 3,
                      () => debugPrint('Hiring Stage clicked'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildStep(
    BuildContext context,
    String label,
    IconData icon,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isActive ? Colors.green : Colors.grey[300],
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.grey[300],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Applicants'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 900),
                  margin: const EdgeInsets.all(24),
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
                      // Header
                      Container(
                        padding: const EdgeInsets.all(36),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Applicants',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                DropdownButton<String>(
                                  value: selectedFilter,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFilter = value!;
                                      currentPage = 1;
                                    });
                                  },
                                  items: progressiveFilters
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(width: 20),
                                SizedBox(
                                  width: 400,
                                  height: 45,
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        searchQuery = value;
                                        currentPage = 1;
                                      });
                                    },
                                    style: const TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                      hintText: 'Search applicants...',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Data Table
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.grey[200],
                          ),
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              const Color(0xFF358873),
                            ),
                            dataRowHeight: 65,
                            horizontalMargin: 24,
                            columnSpacing: 24,
                            columns: const [
                              DataColumn(
                                  label: Text('ID',
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text('NAME',
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text('STAGE',
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text('ACTIONS',
                                      style: TextStyle(color: Colors.white))),
                            ],
                            rows: paginatedApplicants.map((applicant) {
                              final fullName =
                                  '${applicant['profiles']['given_name']} ${applicant['profiles']['sur_name']}';
                              return DataRow(
                                cells: [
                                  DataCell(Text(applicant['id'].toString())),
                                  DataCell(Text(fullName)),
                                  DataCell(
                                    Row(
                                      children: List.generate(
                                        3,
                                        (index) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Icon(
                                            Icons.circle,
                                            size: 12,
                                            color: index < applicant['stage']
                                                ? Colors.green
                                                : Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'View') {
                                          showStageModal(context, fullName,
                                              applicant['stage']);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'View',
                                          child: ListTile(
                                            leading: Icon(Icons.remove_red_eye),
                                            title: Text('View'),
                                          ),
                                        ),
                                      ],
                                      icon: const Icon(Icons.more_vert),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      // Pagination
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: currentPage > 1
                                  ? () => setState(() => currentPage--)
                                  : null,
                              icon: const Icon(Icons.arrow_back),
                            ),
                            Text(
                              'Page $currentPage of ${(filteredApplicants.length / itemsPerPage).ceil()}',
                            ),
                            IconButton(
                              onPressed: currentPage <
                                      (filteredApplicants.length / itemsPerPage)
                                          .ceil()
                                  ? () => setState(() => currentPage++)
                                  : null,
                              icon: const Icon(Icons.arrow_forward),
                            ),
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
}
