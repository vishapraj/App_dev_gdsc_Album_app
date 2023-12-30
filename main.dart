import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Albums App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AlbumListPage(),
    );
  }
}

class AlbumListPage extends StatefulWidget {
  @override
  _AlbumListPageState createState() => _AlbumListPageState();
}

class _AlbumListPageState extends State<AlbumListPage> {
  List<dynamic> albums = [];

  @override
  void initState() {
    super.initState();
    fetchAlbums();
  }

  Future<void> fetchAlbums() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
    if (response.statusCode == 200) {
      setState(() {
        albums = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to fetch albums');
    }
  }

  Future<void> addAlbum() async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      body: jsonEncode({'userId': 1, 'title': 'New Album'}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      fetchAlbums();
    } else {
      throw Exception('Failed to add album');
    }
  }

  Future<void> deleteAlbum(String id) async {
    final response = await http
        .delete(Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'));
    if (response.statusCode == 200) {
      setState(() {
        albums.removeWhere((album) => album['id'].toString() == id);
      });
    } else {
      throw Exception('Failed to delete album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Albums List'),
      ),
      body: ListView.builder(
        itemCount: albums.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(albums[index]['title']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteAlbum(albums[index]['id'].toString()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addAlbum,
        tooltip: 'Add Album',
        child: Icon(Icons.add),
      ),
    );
  }
}
