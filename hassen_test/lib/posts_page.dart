import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hassen_test/models/post.dart';
import 'package:hassen_test/presentation/post/new_post_page.dart';
import 'package:http/http.dart' as http;

class PostsPage extends StatefulWidget {
  PostsPage({Key? key, required this.userId}) : super(key: key);

  //final List<Post> postsOfUser;
  int userId;

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  Future<List<Post>> getPosts(int id) async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?userId=' + id.toString()));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return User.fromJson(jsonDecode(response.body));
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => new Post.fromJson(data)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  late Future<List<Post>> posts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    posts = getPosts(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: FutureBuilder<List<Post>>(
        future: getPosts(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].title),
                    subtitle: Text(snapshot.data![index].body),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(
            child: const CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NewPostPage(userId: widget.userId, lastPostId: 1)));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
