import 'dart:convert';

import 'package:instagram_downloader/instagram_post_model.dart';
import 'package:instagram_downloader/instagram_provider.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_downloader/post_data_model.dart';

class InstagramController {

  String _getIdPost(String linkPost) {
    final List linkList = linkPost.split('/');
    final int indexOfP = linkList.indexOf('p');
    if (indexOfP > -1) return linkList.elementAt(indexOfP + 1); // Return the id of post

    return null;
  }

  Future<PostData> getDataPost(String linkPost) async {
    try {
      String idPost = _getIdPost(linkPost);

      http.Response response = await InstagramProvider.getData(idPost);
      if (response.statusCode == 200 && response.body != null) {
        ShortcodeMedia media = InstagramPost.fromJSON(json.decode(response.body)).graphql.shortcode_media;

        List<PostContent> contentList = [];

        switch(media.typename) {
          case "GraphImage":
          case "GraphVideo":
            contentList.add(_getPostContent(media));
            break;
          case "GraphSidecar":
            contentList = _getMultipleContent(media.edge_sidecar_to_children);
            break;
        }

        
        return PostData(
          ownerName: media.owner.username,
          contentList: contentList
        );
      } else {
        print("Something goes wrong");
      }
    } catch (e) {
      print("Error D:");
    }
  }

  List<PostContent> _getMultipleContent(Sidecar sidecard) {
    List<PostContent> _results = [];

    for (var edge in sidecard.edges) {
      _results.add(_getPostContent(edge.node));
    }

    return _results;
  }

  PostContent _getPostContent(ShortcodeMedia media) {
    final String idContent = media.id;
    String urlContent;

    if (media.is_video) {
      urlContent = media.video_url;
    } else {
      final List<ResourceItem> resources = media.display_resources;
      final int maxQuality = resources.length - 1;
      urlContent = resources[maxQuality].src;
    }

    return PostContent(
      idContent: idContent,
      urlContent: urlContent,
    );
  }
}