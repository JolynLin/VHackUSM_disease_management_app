import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineLookupPage extends StatefulWidget {
  const MedicineLookupPage({super.key});

  @override
  State<MedicineLookupPage> createState() => _MedicineLookupPageState();
}

class _MedicineLookupPageState extends State<MedicineLookupPage> {
  final TextEditingController _searchController = TextEditingController();
  String _medicineName = "";
  bool _searched = false;

  void _performSearch() {
    setState(() {
      _medicineName = _searchController.text.toLowerCase().trim();
      _searched = true;
    });
  }

  void _resetSearch() {
    setState(() {
      _medicineName = "";
      _searched = false;
      _searchController.clear();
    });
  }

  Widget _buildMedicineCard(Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          data['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Tap to view full details"),
        trailing: const Icon(Icons.medical_services),
        onTap: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(data['name']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("💊 Usage:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(data['usage']),
                const SizedBox(height: 8),
                const Text("⚠️ Side Effects:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(data['side_effects']),
                const SizedBox(height: 8),
                const Text("🚫 Precautions:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(data['precautions']),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("Close"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_medicineName.isEmpty) {
      return _searched
          ? const Text("⚠️ Please enter a search term.")
          : const SizedBox.shrink();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("medicines")
          .where("keywords", arrayContains: _medicineName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("❌ No results found."),
          );
        }

        final docs = snapshot.data!.docs;

        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return _buildMedicineCard(data);
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("💊 Medicine Lookup"),
        actions: [
          IconButton(
            onPressed: _resetSearch,
            icon: const Icon(Icons.refresh),
            tooltip: "Reset",
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Enter medicine or illness",
                labelText: "Search",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSearchResults(),
          ],
        ),
      ),
    );
  }
}
