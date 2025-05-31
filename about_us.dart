import 'package:flutter/material.dart';

// --- About Us Page ---
class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        // Page title and consistent theming
        title: const Text("About BloomWithin", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Welcome heading
              Text(
                "Welcome to BloomWithin!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle/Quote
              Text(
                "Because the strongest blooms come from within.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: colorScheme.onBackground.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 28),

              // Main body text / creator message
              Text(
                "BloomWithin was created with the belief that healing doesn’t always happen on the outside — sometimes it begins quietly, within.\n\n"
                    "After going through a period of emotional burnout and personal struggle, I realized how important it is to have a space where you can pause, reflect, and just be honest with yourself.\n\n"
                    "This app is my way of offering that space to others. Whether you're feeling overwhelmed, misunderstood, or just trying to find your peace again, BloomWithin is here to remind you: you’re not alone, and growth is still possible — even in the darkest seasons.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 32),

              // Divider
              Divider(
                thickness: 1,
                color: colorScheme.onBackground.withOpacity(0.5),
              ),
              const SizedBox(height: 16),

              // Creator Info
              Text("Created by Ali Masuth", style: TextStyle(fontSize: 15, color: colorScheme.onBackground)),
              Text("Course: IT-315-DL1", style: TextStyle(fontSize: 15, color: colorScheme.onBackground)),
              Text("Date: May 5, 2025", style: TextStyle(fontSize: 15, color: colorScheme.onBackground)),
              const SizedBox(height: 16),

              // Divider
              Divider(
                thickness: 1,
                color: colorScheme.onBackground.withOpacity(0.5),
              ),
              const SizedBox(height: 12),

              // Copyright footer
              Text(
                "© 2025 Ali Masuth. All Rights Reserved.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),

              // Return home button (optional if AppBar has back button)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, "/");
                },
                child: const Text("Return Home"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}