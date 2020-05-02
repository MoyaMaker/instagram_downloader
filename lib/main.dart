import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Controllers
import 'package:instagram_downloader/instagram_controller.dart';

// Models
import 'package:instagram_downloader/model/post_data_model.dart';
import 'package:instagram_downloader/widgets/video_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intagram downloader',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String link;
  bool showPost = false;
  String feedback;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instagram downloader"),
      ),
      body: SingleChildScrollView(child: _body())
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          _link(),
          _buttons(),
          _futureBuild()
        ],
      ),
    );
  }

  Widget _link() {
    return Container(
      child: Text(
        this.link != null ? this.link : "Waiting for link...",
        overflow: TextOverflow.ellipsis
      ),
    );
  }

  Widget _buttons() {
    return Container(
      margin: EdgeInsets.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            key: Key("paste-button"),
            child: Text("Paste"),
            onPressed: () async {
              ClipboardData result = await Clipboard.getData('text/plain');
              this.link = result.text;
              this.showPost = false;
              setState(() {});
            },
          ),

          RaisedButton(
            child: Text("Get post"),
            onPressed: this.link != null ? _getPost : null
          )
        ],
      ),
    );
  }

  void _getPost() {
    this.showPost = true;
    setState(() {});
  }

  Widget _photo(String urlImage) {
    return Container(
      child: FadeInImage(
        placeholder: AssetImage('assets/loader.gif'),
        image: NetworkImage(urlImage)
      )
    );
  }

  Widget _video(String urlVideo) {
    return VideoWidget(urlContent: urlVideo);
  }

  Widget _loadPosts(PostData postData) {
    List<Widget> _posts = [];
    postData.contentList.forEach((PostContent content) {
      if (content.isVideo)
        _posts.add(_video(content.urlContent));
      else
        _posts.add(_photo(content.urlContent));
    });

    return Column(
      children: _posts
    );
  }

  Widget _futureBuild() {
    if (!showPost) return Container();
    return FutureBuilder(
      future: InstagramController().getDataPost(this.link),
      builder: (BuildContext context, AsyncSnapshot<PostData> snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Text('Cargando');
          case ConnectionState.done:
            return _loadPosts(snapshot.data);
          case ConnectionState.none:
            return Text('Falló');
          default:
            return Text('Espera...');
        }
      },
    );
  }
}
