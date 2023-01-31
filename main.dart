import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

const String _baseUrl = 'https://api.unsplash.com/';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Random photo from unsplash'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _user_name = "1";
  late String _photo_link = "1";

  Future<void> _getRandomPhoto() async {
    final GalleryFromUnsplech galleryfromunsplech = GalleryFromUnsplech.filled();
    final Photo data = await galleryfromunsplech.getRandomData();

    setState(() {
      _user_name = data.user_name;
      _photo_link = data.photo_link;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(_photo_link),
            Text('Author\'s name: $_user_name'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getRandomPhoto,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Photo {
  String user_name;
  String photo_link;

  Photo({required this.user_name, required this.photo_link});

  factory Photo.fromJson(Map<String,dynamic> json) {
    return Photo(
      user_name: json["user"]["name"] as String,
      photo_link: json["urls"]["regular"] as String,
    );
  }
}

class GalleryFromUnsplech{

  factory GalleryFromUnsplech.filled() {
    final Dio dio = Dio(BaseOptions(
        baseUrl: _baseUrl
    ));
    return GalleryFromUnsplech._(dio);
  }
  final Dio _dio;

  GalleryFromUnsplech._(this._dio);

  Future<Photo>getRandomData() async {
    final responce = await _dio.get('/photos/random/?client_id=ab3411e4ac868c2646c0ed488dfd919ef612b04c264f3374c97fff98ed253dc9');
    if (responce.statusCode == 200) {
      return Photo.fromJson(responce.data);
    } else {
      throw Exception('Failed to load Photo');
    }
  }
}