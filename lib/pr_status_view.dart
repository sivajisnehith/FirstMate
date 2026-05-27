import 'package:flutter/material.dart';
import 'api_service.dart';

class PRStatusView extends StatelessWidget {
  const PRStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pull Request Health',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: ApiService.fetchPRStatus('flutter/flutter'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Claude analyzing PRs...', style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent))),
                      );
                    } else if (snapshot.hasData) {
                      final prStatuses = snapshot.data!;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingTextStyle: const TextStyle(
                            color: Color(0xFF64748b),
                            fontWeight: FontWeight.w600,
                          ),
                          dataRowMaxHeight: 60,
                          columns: const [
                            DataColumn(label: Text('Issue #')),
                            DataColumn(label: Text('Title')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Days Old')),
                          ],
                          rows: prStatuses.map((pr) {
                            final status = pr['status'] as String;
                      final daysOld = pr['daysOld'] as int;

                      Color statusColor = Colors.white70;
                      if (status.contains('Has PR')) {
                        statusColor = const Color(0xFF34d399); // Green accent
                      } else if (status == 'STALLED') {
                        if (daysOld >= 14) {
                          statusColor = const Color(0xFFef4444); // Red accent
                        } else if (daysOld >= 7) {
                          statusColor = const Color(0xFFfbbf24); // Amber accent
                        }
                      }

                      return DataRow(
                        cells: [
                          DataCell(Text('#${pr['number']}', style: const TextStyle(color: Colors.white))),
                          DataCell(Text(pr['title'].toString(), style: const TextStyle(color: Colors.white))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: statusColor.withOpacity(0.2)),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '$daysOld days',
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

