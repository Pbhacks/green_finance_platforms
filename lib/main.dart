import 'package:flutter/material.dart';
import 'package:green_finance_platform/screens/analytics_screen.dart';
import 'package:green_finance_platform/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:green_finance_platform/providers/project_provider.dart';
import 'package:green_finance_platform/providers/theme_provider.dart';
import 'package:green_finance_platform/screens/home_screen.dart';
import 'package:green_finance_platform/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/esg_dashboard_screen.dart';
import 'widgets/animated_nav_icon.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Green Finance Platform',
            theme: AppTheme.lightTheme.copyWith(
              colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
                primary: Colors.teal,
                secondary: Colors.greenAccent,
                surface: Colors.teal.shade50,
              ),
              scaffoldBackgroundColor: Colors.teal.shade50,
              cardTheme: CardTheme(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              appBarTheme: AppBarTheme(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
              ),
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
              colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
                primary: Colors.teal.shade200,
                secondary: Colors.green.shade700, // emerald tone
              ),
              scaffoldBackgroundColor: const Color(0xFF2F3B3F), // darker charcoal
            ),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AnalyticsScreen(),
    ESGDashboardScreen(), // Added ESGDashboardScreen
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            key: ValueKey<int>(_selectedIndex),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: AnimatedNavIcon(
                  icon: Icons.home,
                  isSelected: _selectedIndex == 0,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: AnimatedNavIcon(
                  icon: Icons.analytics,
                  isSelected: _selectedIndex == 1,
                ),
                label: 'Analytics',
              ),
              NavigationDestination(
                icon: AnimatedNavIcon(
                  icon: Icons.dashboard,
                  isSelected: _selectedIndex == 2,
                ),
                label: 'ESG Dashboard',
              ),
              NavigationDestination(
                icon: AnimatedNavIcon(
                  icon: Icons.settings,
                  isSelected: _selectedIndex == 3,
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
