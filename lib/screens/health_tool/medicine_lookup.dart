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
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue.shade200, width: 1),
      ),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            titlePadding: const EdgeInsets.all(24),
            contentPadding: const EdgeInsets.all(24),
            title: Column(
              children: [
                const Icon(Icons.medical_services,
                    size: 48, color: Colors.blue),
                const SizedBox(height: 16),
                Text(
                  data['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection("Usage", data['usage'], Icons.info_outline),
                  const SizedBox(height: 20),
                  _buildInfoSection("Side Effects", data['side_effects'],
                      Icons.warning_amber),
                  const SizedBox(height: 20),
                  _buildInfoSection(
                      "Precautions", data['precautions'], Icons.shield),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.medication,
                    size: 32, color: Colors.blue.shade700),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Tap for more details",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon) {
    String emoji = "";
    switch (title) {
      case "Usage":
        emoji = "💊 ";
        break;
      case "Side Effects":
        emoji = "⚠️ ";
        break;
      case "Precautions":
        emoji = "🚫 ";
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_medicineName.isEmpty) {
      return _searched
          ? const Center(
              child: Text(
                "Please enter a medicine name to search",
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
          : const SizedBox.shrink();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("medicines")
          .where("keywords", arrayContains: _medicineName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text(
                  "No medicines found",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
        title: const Text(
          "Find Your Medicine",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              size: 28,
              color: Colors.white,
            ),
            onPressed: _resetSearch,
            tooltip: "Clear Search",
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: Color(0xFFE6F7FF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Medicine Name or Illness",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Type here ...",
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.search_rounded,
                      size: 32,
                      color: Colors.blue.shade400,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      size: 32,
                      color: Colors.grey.shade400,
                    ),
                    onPressed: _resetSearch,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                onSubmitted: (_) => _performSearch(),
              ),
            ),
            const SizedBox(height: 24),
            _buildSearchResults(),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton.extended(
          onPressed: _performSearch,
          backgroundColor: Colors.blue.shade400,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          icon: const Icon(
            Icons.search_rounded,
            size: 32,
          ),
          label: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(
              "Search",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
