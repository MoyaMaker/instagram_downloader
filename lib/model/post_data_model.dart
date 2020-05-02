class PostData {
  final String ownerName;
  final List<PostContent> contentList;

  PostData({
    this.ownerName,
    this.contentList,
  });
}

class PostContent {
  final String idContent;
  final String urlContent;
  final bool isVideo;

  PostContent({
    this.idContent,
    this.urlContent,
    this.isVideo
  });
}