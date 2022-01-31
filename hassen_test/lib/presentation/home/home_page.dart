import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hassen_test/models/post.dart';
import 'package:hassen_test/posts_page.dart';
import 'package:hassen_test/models/user.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<User>> getUsers() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/users/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return User.fromJson(jsonDecode(response.body));
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => new User.fromJson(data)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  late Future<List<User>> users;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users = getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Home",
      home: Scaffold(
          appBar: AppBar(
            title: Text("Home"),
          ),
          body: FutureBuilder<List<User>>(
            future: getUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostsPage(
                                      userId: snapshot.data![index].userId,
                                    )));
                      },
                      title: Text(
                        "Username:" + snapshot.data![index].userName.toString(),
                      ),
                      subtitle: Text("Adresse:  " +
                          snapshot.data![index].address.street +
                          ", " +
                          snapshot.data![index].address.suite +
                          ", " +
                          snapshot.data![index].address.city +
                          ", " +
                          snapshot.data![index].address.suite +
                          ", " +
                          "Zipcode: " +
                          snapshot.data![index].address.zipcode),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Center(
                child: const CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}
