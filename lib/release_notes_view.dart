import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'api_service.dart';

class ReleaseNotesView extends StatefulWidget {
  const ReleaseNotesView({super.key});

  @override
  State<ReleaseNotesView> createState() => _ReleaseNotesViewState();
}

class _ReleaseNotesViewState extends State<ReleaseNotesView> {
  String _selectedVersion = 'v1.3.0';
  final List<String> _versions = ['v1.2.3', 'v1.3.0'];
  Future<String>? _notesFuture;
  String? _currentNotes;

  void _generateNotes() {
    setState(() {
      _notesFuture = ApiService.generateReleaseNotes('flutter/flutter', _selectedVersion);
    });
  }

  void _copyToClipboard() {
    if (_currentNotes != null) {
      Clipboard.setData(ClipboardData(text: _currentNotes!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Markdown copied to clipboard!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: _notesFuture != null ? FloatingActionButton(
        onPressed: _copyToClipboard,
        child: const Icon(Icons.copy),
      ) : null,
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Release Notes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1E),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedVersion,
                        dropdownColor: const Color(0xFF1A1A1E),
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                        items: _versions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedVersion = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _generateNotes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Generate Notes'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _notesFuture == null
                    ? const Center(child: Text('Select a version and generate notes.', style: TextStyle(color: Colors.white70)))
                    : FutureBuilder<String>(
                        future: _notesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Claude analyzing merged PRs...', style: TextStyle(color: Colors.white70)),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)),
                            );
                          } else if (snapshot.hasData) {
                            _currentNotes = snapshot.data;
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 800),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1A1A1E),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                                        ),
                                        child: MarkdownBody(
                                          data: snapshot.data!,
                                          styleSheet: MarkdownStyleSheet(
                                            h2: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                            p: const TextStyle(color: Colors.white70, fontSize: 14),
                                            listBullet: const TextStyle(color: Colors.white70),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
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
