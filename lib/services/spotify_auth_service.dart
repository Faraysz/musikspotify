import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpotifyAuthService {
  static const String clientId = '1c7d97a06669488a99a571fe481972a8';
  static const String clientSecret = '807a5658e01e41509351daf2f5b64b60'; // ❗ Pindahkan ke backend di produksi
  static const String redirectUri = 'musikspotify://callback';
  static const String scopes = 'user-read-private user-read-email';

  Future<String?> authenticate() async {
    try {
      final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
        'response_type': 'code',
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'scope': scopes,
      });

      final result = await FlutterWebAuth2.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: "musikspotify",
      );

      final code = Uri.parse(result).queryParameters['code'];

      if (code == null) {
        print("❌ Authorization code not found.");
        return null;
      }

      final tokenResponse = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
        },
      );

      if (tokenResponse.statusCode == 200) {
        final data = json.decode(tokenResponse.body);
        final accessToken = data['access_token'];
        return accessToken;
      } else {
        print('❌ Failed to get access token: ${tokenResponse.statusCode} - ${tokenResponse.body}');
        return null;
      }
    } catch (e) {
      print('❌ Authentication error: $e');
      return null;
    }
  }
}
