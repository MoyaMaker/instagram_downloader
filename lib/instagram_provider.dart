import 'package:http/http.dart' as http;

class InstagramProvider {

  /// Return the JSON data from Instagram API
  static Future<http.Response> getData(String idPost) async {
    final String url = "https://www.instagram.com/p/${idPost}/?__a=1";

    return http.get(url);
  }
}
