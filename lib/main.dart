import 'package:flutter/material.dart';
import 'services/spotify_auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SpotifyLoginPage());
  }
}

class SpotifyLoginPage extends StatelessWidget {
  final spotifyAuth = SpotifyAuthService();

  SpotifyLoginPage({super.key});

  void login(BuildContext context) async {
    try {
      final token = await spotifyAuth.authenticate();
      print("Access Token: $token");
    } catch (e) {
      print("Login failed;$e");
      //misal tampilkan dialog error
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar(content: Text("Login failed: $e"),
        duration: const Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Spotify")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => login(context),
          child: const Text("Login Spotify"),
        ),
      ),
    );
  }
  
  SnackBar snackBar({required Text content, required Duration duration}) {
    return SnackBar(content: content, duration: duration);
  }
}
