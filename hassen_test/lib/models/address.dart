import 'package:flutter/foundation.dart';

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;

  const Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      suite: json['suite'],
      city: json['suite'],
      zipcode: json['suite'],
    );
  }
}
