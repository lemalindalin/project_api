import 'package:flutter/foundation.dart';
import 'package:hassen_test/models/address.dart';

class User {
  final int userId;
  final String userName;
  final Address address;

  const User({
    required this.userName,
    required this.address,
    required this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Address a = new Address(
        street: json['address']['street'],
        suite: json['address']['suite'],
        city: json['address']['city'],
        zipcode: json['address']['zipcode']);
    return User(userName: json['username'], address: a, userId: json['id']);
  }
}
