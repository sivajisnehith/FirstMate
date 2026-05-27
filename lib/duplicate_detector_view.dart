import 'package:flutter/material.dart';
import 'api_service.dart';

class DuplicateDetectorView extends StatelessWidget {
  const DuplicateDetectorView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ApiService.fetchDuplicates('flutter/flutter'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Agent querying Coral...', style: TextStyle(color: Colors.white70)),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)));
        } else if (snapshot.hasData) {
          final duplicateIssues = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            itemCount: duplicateIssues.length,
            itemBuilder: (context, index) {
              final issue = duplicateIssues[index];
        final confidence = issue['confidence'] as double;
        final matchPercent = (confidence * 100).toInt();
        
        final isHighMatch = confidence >= 0.9;
        final badgeColor = isHighMatch ? const Color(0xFF818CF8) : const Color(0xFFfbbf24);

        return Card(
          color: const Color(0xFF1A1A1E),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
          margin: const EdgeInsets.only(bottom: 24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Master Issue & Confidence
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Master Issue #${issue['master_issue']}'.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF64748b),
                              fontSize: 12,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            issue['master_title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: badgeColor.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, color: badgeColor, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '$matchPercent% Match',
                            style: TextStyle(
                              color: badgeColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.white10, height: 1),
                ),
                
                // Duplicate Issue
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Potential Duplicate #${issue['duplicate_issue']}'.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF64748b),
                        fontSize: 12,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      issue['duplicate_title'],
                      style: const TextStyle(
                        color: Color(0xFFcbd5e1),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Reason
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121214),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.psychology_outlined, color: Color(0xFF94a3b8), size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '"${issue['reason']}"',
                          style: const TextStyle(
                            color: Color(0xFF94a3b8),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('View on GitHub'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFcbd5e1),
                        side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.merge_type, size: 16),
                      label: const Text('Mark as Duplicate'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
        }
        return const SizedBox();
      },
    );
  }
}
