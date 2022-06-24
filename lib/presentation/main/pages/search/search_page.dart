import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:udvanced_flutter/presentation/resources/string_manager.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(AppString.search.tr()),);
  }
}
