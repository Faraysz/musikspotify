import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpotifyAuthService {
  static const clientId = 'YOUR_CLIENT_ID';
  static const clientSecret = 'YOUR_CLIENT_SECRET';
  static const redirectUri = 'yourapp://callback';
  static const scopes = 'user-read-private user-read-email';

  Future<String?> authenticate() async {
    final authUrl =
        'https://accounts.spotify.com/authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&scope=$scopes';

    final result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: "yourapp",
    );

    final code = Uri.parse(result).queryParameters['code'];

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code!,
        'redirect_uri': redirectUri,
      },
    );

    final accessToken = json.decode(response.body)['access_token'];
    return accessToken;
  }
}
