import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:e_store/services/regulus_vercel_api.dart';
import 'package:e_store/widgets/products_grid.dart';

class SearchScreen extends ConsumerStatefulWidget{
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  Map? _results;
  bool _showResults = false;
  bool _nothing = false;

  void _onSearch() async {
    final searchString = _searchController.text;
    final regex = RegExp(r'^[a-zA-Z0-9]$');

    if (searchString.isEmpty ||
      !regex.hasMatch(searchString[0])) { return; }
    
    try {
      final results = await fetchFromRegulusVercel('products?search=$searchString');
      if (results['products'] != null && results['products'].isNotEmpty) {
        setState(() {
          _results = results;
          _showResults = true;
          _nothing = false;
        });
      } else {
        setState(() {
          _showResults = false;
          _nothing = true;
        });
      }
    } catch(e) {
      setState(() {
        _showResults = false;
        _nothing = true;
      });
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search'),),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search input
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search key words',
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height:40),
              // Search button
              ElevatedButton.icon(
                onPressed: _onSearch,
                icon: const Icon(Icons.search),
                label: const Text('Search'),
              ),
              const SizedBox(height:40),
              // Show block results?
              if (_showResults) 
                Expanded(
                  child: ProductsGrid(
                    products: _results!['products'],                  
                  ),
                ),
              // No results
              if (_nothing)
                Center(
                  child: Text(
                    'No results',
                    style: TextStyle(
                      fontSize: 18, 
                      color: Theme.of(context).colorScheme.error,
                    ),
                  )
                )
            ],
          ),
        ),
      ),
    );
  }

}