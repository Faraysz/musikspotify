import 'package:flutter/material.dart';
import 'services/spotify_auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SpotifyLoginPage(),
    );
  }
}

class SpotifyLoginPage extends StatelessWidget {
  final spotifyAuth = SpotifyAuthService();

  SpotifyLoginPage({super.key});

  void login() async {
    final token = await spotifyAuth.authenticate();
    print("Access Token: $token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Spotify")),
      body: Center(
        child: ElevatedButton(
          onPressed: login,
          child: const Text("Login Spotify"),
        ),
      ),
    );
  }
}
