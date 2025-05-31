import 'package:flutter/material.dart';
import 'mood_check_in.dart';
import 'exercises.dart';
import 'journal.dart';
import 'about_us.dart';
import 'calm_me_now.dart';
import 'soothing_sounds.dart';

// Represents each feature button shown on the home screen
// Stores its icon, label, and the route it navigates to
class Button {
  final IconData icon;
  final String label;
  final String routeName;

  const Button({
    required this.icon,
    required this.label,
    required this.routeName,
  });
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,

    // Defines a custom light theme for consistent app-wide colors
    theme: ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF81C784), // Main accent color (used for buttons, app bar)
        onPrimary: Color(0xFF3E3E3E), // Text color on top of primary color
        secondary: Color(0xFFB3E5FC), // Secondary accent
        onSecondary: Color(0xFF2A3D45),
        background: Color(0xFFE1F5FE), // Scaffold background color
        onBackground: Color(0xFF1B5E20), // Text color on background
        surface: Color(0xFFFFFFFF), // Surfaces like cards
        onSurface: Color(0xFF3E3E3E),
        error: Color(0xFFEF5350),
        onError: Color(0xFFFFFFFF),
      ),
      scaffoldBackgroundColor: Color(0xFFE1F5FE),
    ),

    initialRoute: '/', // First screen to display when the app launches

    // Maps route names to the widget pages they load
    routes: {
      '/': (context) => HomePage(),
      '/journal': (context) => Journal(),
      '/aboutUs': (context) => AboutUs(),
      '/moodCheckIn': (context) => MoodCheckIn(),
      '/calmMeNow': (context) => CalmMeNow(),
      '/exercises': (context) => Exercises(),
      '/soothingSounds': (context) => SoothingSounds(),
    },
  ));
}

// Custom button widget used on the home screen grid
class HomeFeatureButton extends StatelessWidget {
  final IconData iconData;
  final String label;
  final VoidCallback onPressed;

  const HomeFeatureButton({
    super.key,
    required this.iconData,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Wraps the button to keep it square-shaped
    return AspectRatio(
      aspectRatio: 1.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically centers content
          crossAxisAlignment: CrossAxisAlignment.center, // Horizontally centers content
          children: [
            Icon(
              iconData,
              size: 40.0,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Home screen that shows a title and a grid of feature buttons
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Defines the feature buttons that appear on the home screen
  static final List<Button> buttons = [
    Button(icon: Icons.mood, label: "Mood Check-In", routeName: '/moodCheckIn'),
    Button(icon: Icons.book, label: "My Journal", routeName: '/journal'),
    Button(icon: Icons.self_improvement, label: "Calm Me Now", routeName: '/calmMeNow'),
    Button(icon: Icons.fitness_center, label: "Exercises", routeName: '/exercises'),
    Button(icon: Icons.music_note, label: "Soothing Sounds", routeName: '/soothingSounds'),
    Button(icon: Icons.info_outline, label: "About Us", routeName: '/aboutUs'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 45),
            Text(
              "BloomWithin",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 45,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Hello, welcome aboard! 🌱",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 30),

            // Displays the feature buttons in a 2x3 grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  for (var button in buttons)
                    HomeFeatureButton(
                      iconData: button.icon,
                      label: button.label,
                      onPressed: () {
                        Navigator.pushNamed(context, button.routeName);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}