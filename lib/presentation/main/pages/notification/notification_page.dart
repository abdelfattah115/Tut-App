import 'package:flutter/material.dart';
import 'package:udvanced_flutter/presentation/resources/string_manager.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text(AppString.notifications),);
  }
}
