class InstagramPost {

  final GraphQL graphql;

  InstagramPost({
    this.graphql
  });

  factory InstagramPost.fromJSON(Map<String, dynamic> json) => InstagramPost(
    graphql: GraphQL.fromJSON(json["graphql"])
  );
}

class GraphQL {
  final ShortcodeMedia shortcode_media;

  GraphQL({ this.shortcode_media });

  factory GraphQL.fromJSON(Map<String, dynamic> json) => GraphQL(
    shortcode_media: ShortcodeMedia.fromJSON(json["shortcode_media"])
  );
}

class ShortcodeMedia {
  final String typename;
  final String id;
  final List<ResourceItem> display_resources;
  final bool is_video;
  final Owner owner;
  final Sidecar edge_sidecar_to_children;
  final String video_url;

  ShortcodeMedia({
    this.typename,
    this.id,
    this.display_resources,
    this.is_video,
    this.owner,
    this.edge_sidecar_to_children,
    this.video_url
  });

  factory ShortcodeMedia.fromJSON(Map<String, dynamic> json) => ShortcodeMedia(
    typename: json["__typename"],
    id: json["id"],
    display_resources: DisplayResources.fromJSON(json["display_resources"]).items,
    is_video: json["is_video"],
    owner: json["owner"] != null ? Owner.fromJSON(json["owner"]) : null,
    edge_sidecar_to_children: Sidecar.fromJSON(json["edge_sidecar_to_children"]),
    video_url: json["video_url"]
  );
}

class DisplayResources {
  List<ResourceItem> items = [];

  DisplayResources.fromJSON(List<dynamic> json) {
    if (json != null) {
      for (var item in json) {
        var resource = ResourceItem.fromJSON(item);
        items.add(resource);
      }
    }
  }
}

class ResourceItem {
  final String src;

  ResourceItem({ this.src });

  factory ResourceItem.fromJSON(Map<String, dynamic> json) => ResourceItem(
    src: json["src"]
  );
}

class Owner {
  final String username;

  Owner({ this.username });

  factory Owner.fromJSON(Map<String, dynamic> json) => Owner(
    username: json["username"]
  );
}

class Sidecar {
  List<Edge> edges;

  Sidecar({ this.edges });

  factory Sidecar.fromJSON(Map<String, dynamic> json) => Sidecar(
    edges: json != null ? List<Edge>.from(json["edges"].map((x) => Edge.fromJSON(x))): null,
  );
}

class Edge {
  ShortcodeMedia node;

  Edge({ this.node });

  factory Edge.fromJSON(Map<String, dynamic> json) => Edge(
      node: ShortcodeMedia.fromJSON(json["node"]),
  );
}
