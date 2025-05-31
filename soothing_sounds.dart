import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

// --- Sound Data Class ---
class Sound {
  final String title;
  final String url;
  final String type;

  Sound({required this.title, required this.url, required this.type});
}

// --- Soothing Sounds Page ---
class SoothingSounds extends StatefulWidget {
  const SoothingSounds({super.key});

  @override
  State<SoothingSounds> createState() => _MusicState();
}

class _MusicState extends State<SoothingSounds> {
  final player = AudioPlayer();
  String? currentTrack;

  // List of available sounds with types
  final List<Sound> allSounds = [
    Sound(title: 'Gentle Rain', url: 'assets/audio/gentle_rain.mp3', type: 'ambience'),
    Sound(title: 'Ocean Waves', url: 'assets/audio/ocean_waves.mp3', type: 'ambience'),
    Sound(title: 'Forest Ambience', url: 'assets/audio/forest.mp3', type: 'ambience'),
    Sound(title: 'Wind in Trees', url: 'assets/audio/wind.mp3', type: 'ambience'),
    Sound(title: 'Calm Piano', url: 'assets/audio/calm_piano.mp3', type: 'instrumental'),
    Sound(title: 'Soft Guitar', url: 'assets/audio/soft_guitar.mp3', type: 'instrumental'),
    Sound(title: 'Lo-fi Focus', url: 'assets/audio/lofi.mp3', type: 'instrumental'),
    Sound(title: 'Ambient Synths', url: 'assets/audio/synth.mp3', type: 'instrumental'),
  ];

  // Group sounds by type (e.g., ambience, instrumental)
  Map<String, List<Sound>> get groupedSounds {
    final map = <String, List<Sound>>{};
    for (var sound in allSounds) {
      map.putIfAbsent(sound.type, () => []).add(sound);
    }
    return map;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  // Play or pause a track by its URL and title
  Future<void> playTrack(String url, String title) async {
    if (currentTrack == title) {
      await player.stop();
      setState(() => currentTrack = null);
    } else {
      try {
        await player.setAsset(url);
        await player.play();
        setState(() => currentTrack = title);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Could not load track: $title")),
          );
        }
      }
    }
  }

  // Return an icon based on the sound type
  Icon _iconForType(String type) {
    switch (type) {
      case 'ambience':
        return Icon(Icons.eco);
      case 'instrumental':
        return Icon(Icons.music_note);
      case 'mood':
        return Icon(Icons.sentiment_satisfied);
      default:
        return Icon(Icons.audiotrack);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Soothing Sounds",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      backgroundColor: colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Instructional header
            Text(
              "Tap a sound to play or pause",
              style: TextStyle(
                fontSize: 24,
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // List of grouped sounds displayed as cards
            Expanded(
              child: ListView(
                children: groupedSounds.entries.expand((entry) {
                  final type = entry.key;
                  final sounds = entry.value;

                  return [
                    // Category label
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        type[0].toUpperCase() + type.substring(1),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ),
                    // List of sounds in the category
                    ...sounds.map((sound) {
                      final isPlaying = sound.title == currentTrack;
                      return Card(
                        child: ListTile(
                          leading: _iconForType(sound.type),
                          title: Text(sound.title),
                          trailing: Icon(
                            isPlaying ? Icons.pause_circle : Icons.play_circle,
                            color: colorScheme.primary,
                            size: 30,
                          ),
                          onTap: () => playTrack(sound.url, sound.title),
                        ),
                      );
                    }),
                  ];
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}