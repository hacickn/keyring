import 'package:flutter/material.dart';

class Account {
  final String id;
  final String name;
  final String login;
  final String code;
  final Color color;

  const Account({
    required this.id,
    required this.name,
    required this.login,
    required this.code,
    required this.color,
  });
}
