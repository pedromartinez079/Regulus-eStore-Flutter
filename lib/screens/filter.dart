import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:e_store/providers/filter_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({
    super.key,
    required this.options,
    required this.updateInformation,
  });

  final List options;
  final Function updateInformation;

  @override
  ConsumerState<FilterScreen> createState() {
    return _FilterScreenState();
  }
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  List<bool> _selected = [];
  bool _isFilterFetched = false;

  void _setFilter() async {
    final pref = await SharedPreferences.getInstance();

    ref.read(filterProvider.notifier).setFilter(Filter(filter: _selected));
    await pref.setString('filter', jsonEncode(_selected));
  }

  void _getFilter() async {
    final pref = await SharedPreferences.getInstance();
    final list = pref.getString('filter');
    List<bool> boolList = [];
    
    if (list != null) {
      List dynamicList = jsonDecode(list);
      boolList = dynamicList.cast<bool>();
      int delta = widget.options.length - boolList.length;
      if (delta != 0) {
        boolList = List<bool>.filled(widget.options.length, false);
      }            
    } else {
      boolList = List<bool>.filled(widget.options.length, false);
    }
    setState(() {
      _selected = boolList;
      _isFilterFetched = true;
    });
    //print(_selected);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.options);
    //print(_selected);
    if (!_isFilterFetched) _getFilter();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Category',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(widget.options[index]['name']),
                  value: index < _selected.length ? _selected[index] : false,
                  onChanged: (bool? value) {
                    setState(() {
                      _selected[index] = value ?? false;
                    });
                    _setFilter();
                    widget.updateInformation();
                  },
                );
              },
            ),
        ),
      )
    );
  }
}