import 'package:flutter/material.dart';
import 'mock_data.dart';
import 'duplicate_detector_view.dart';
import 'pr_status_view.dart';
import 'release_notes_view.dart';

void main() {
  runApp(const FirstMateApp());
}

class FirstMateApp extends StatelessWidget {
  const FirstMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Mate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121214),
        cardColor: const Color(0xFF1A1A1E),
        fontFamily: 'Roboto',
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: Color(0xFF1A1A1E),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildNavigationRail(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildBodyContent(_selectedIndex),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail() {
    return Container(
      width: 96,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1E),
        border: Border(
          right: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: NavigationRail(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.transparent,
        useIndicator: false,
        labelType: NavigationRailLabelType.all,
        selectedIconTheme: const IconThemeData(color: Color(0xFF818CF8)),
        unselectedIconTheme: IconThemeData(color: Colors.white.withOpacity(0.4)),
        selectedLabelTextStyle: const TextStyle(
          color: Color(0xFF818CF8),
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 40.0),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.sailing, color: Colors.white),
          ),
        ),
        destinations: const [
          NavigationRailDestination(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.file_copy_outlined),
            ),
            selectedIcon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.file_copy),
            ),
            label: Text('DUPLICATES'),
          ),
          NavigationRailDestination(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.merge_type_outlined),
            ),
            selectedIcon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.merge_type),
            ),
            label: Text('PR STATUS'),
          ),
          NavigationRailDestination(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.notes_outlined),
            ),
            selectedIcon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.notes),
            ),
            label: Text('RELEASE'),
          ),
        ],
        trailing: Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF334155),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                'First Mate',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'v1.0.4',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF64748b),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF22c55e),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Connected to GitHub: flutter/flutter',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFcbd5e1),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBodyContent(int index) {
    switch (index) {
      case 0:
        return _buildDuplicatesTab();
      case 1:
        return const PRStatusView();
      case 2:
        return const ReleaseNotesView();
      default:
        return const SizedBox();
    }
  }

  Widget _buildDuplicatesTab() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Potential Duplicates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'AI Confidence Engine Active'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF818CF8),
                      letterSpacing: 2.0,
                      fontFamily: 'monospace',
                    ),
                  )
                ],
              ),
            ),
            const Expanded(
              child: DuplicateDetectorView(),
            ),
          ],
        ),
      ),
    );
  }
}
