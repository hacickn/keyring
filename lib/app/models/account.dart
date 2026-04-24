import 'package:flutter/material.dart';

class Account {
  final String id;
  final String name;
  final String login;
  final String secretKey;
  final Color color;
  final bool requireBiometric;
  final bool hideByDefault;
  final DateTime addedDate;

  const Account({
    required this.id,
    required this.name,
    required this.login,
    required this.secretKey,
    required this.color,
    required this.addedDate,
    this.requireBiometric = false,
    this.hideByDefault = false,
  });

  Account copyWith({
    String? id,
    String? name,
    String? login,
    String? secretKey,
    Color? color,
    bool? requireBiometric,
    bool? hideByDefault,
    DateTime? addedDate,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      login: login ?? this.login,
      secretKey: secretKey ?? this.secretKey,
      color: color ?? this.color,
      requireBiometric: requireBiometric ?? this.requireBiometric,
      hideByDefault: hideByDefault ?? this.hideByDefault,
      addedDate: addedDate ?? this.addedDate,
    );
  }
}
