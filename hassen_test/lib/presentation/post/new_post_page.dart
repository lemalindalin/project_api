import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hassen_test/models/post.dart';
import 'package:hassen_test/presentation/home/home_page.dart';
import 'package:http/http.dart' as http;

Future<Post> createPost(int userId, String title, String body) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'userId': userId,
      'title': title,
      'body': body,
    }),
  );

  if (response.statusCode == 201) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create a post');
  }
}

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key, required this.userId, required this.lastPostId})
      : super(key: key);

  final int userId;
  final int lastPostId;

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  Future<Post>? _futurePost;
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final _titleController = TextEditingController;

    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    @override
    void dispose() {
      // Clean up the controller when the widget is removed from the
      // widget tree.
      _titleController.dispose();
      _bodyController.dispose();
      super.dispose();
    }

    return MaterialApp(
      title: 'Create a post',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create a post'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futurePost == null)
              ? buildForm(_titleController, _bodyController, style)
              : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildForm(TextEditingController _titleController,
      TextEditingController _bodyController, ButtonStyle style) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Enter post title',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            controller: _bodyController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter post body',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: ElevatedButton(
            style: style,
            onPressed: () {
              setState(() {
                _futurePost = createPost(
                  widget.userId,
                  _titleController.text,
                  _bodyController.text,
                );
              });
            },
            child: const Text('Post'),
          ),
        ),
      ],
    );
  }

  FutureBuilder<Post> buildFutureBuilder() {
    return FutureBuilder<Post>(
        future: _futurePost,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                children: [
                  Text(snapshot.data!.title + " post created successfully"),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      });
                    },
                    child: Text('Home'),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }
}
