import 'account.dart';

class CopyEvent {
  final Account account;
  final String code;
  final DateTime time;

  const CopyEvent({
    required this.account,
    required this.code,
    required this.time,
  });
}
