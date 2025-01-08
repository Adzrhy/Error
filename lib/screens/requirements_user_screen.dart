import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequirementsScreen extends StatefulWidget {
  final int? jobId; // Dynamic job ID
  final List<String>? requirements; // Static requirements list

  const RequirementsScreen({Key? key, this.jobId, this.requirements})
      : super(key: key);

  @override
  State<RequirementsScreen> createState() => _RequirementsScreenState();
}

class _RequirementsScreenState extends State<RequirementsScreen> {
  List<Map<String, dynamic>> requirements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    if (widget.jobId != null) {
      // Fetch requirements dynamically if jobId is provided
      fetchRequirements();
    } else if (widget.requirements != null) {
      // Use static requirements if provided
      setState(() {
        requirements = widget.requirements!
            .map((req) => {
                  'label': 'Requirement',
                  'requirements': [req]
                })
            .toList();
        isLoading = false;
      });
    }
  }

  Future<void> fetchRequirements() async {
    try {
      final response = await Supabase.instance.client
          .from('jobs')
          .select('requirements')
          .eq('id', widget.jobId)
          .maybeSingle(); // Handle single-row response gracefully

      if (response != null && response['requirements'] != null) {
        final data = response['requirements'] as List<dynamic>;

        setState(() {
          requirements = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception('No requirements found for the selected job.');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching requirements: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requirements'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: requirements.map((req) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ExpansionTile(
                    title: Text(req['label']),
                    children: (req['requirements'] as List<dynamic>)
                        .map((item) => ListTile(title: Text(item)))
                        .toList(),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
