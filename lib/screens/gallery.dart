import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:e_store/services/regulus_vercel_api.dart';
import 'package:e_store/screens/filter.dart';
import 'package:e_store/screens/about.dart';
import 'package:e_store/screens/search.dart';
import 'package:e_store/widgets/products_grid.dart';
import 'package:e_store/providers/filter_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() {
    return _GalleryScreenState();
  }
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  Widget? _scaffoldBody;
  bool _isInformationFetched = false;
  bool _isError = false;
  bool _isFilterApplied = false;
  String _errorText = 'Information source failure\n\n';
  List _categories = [];
  List? _products;
  List? _filteredProducts = [];
  final int itemsPerPage = 20;
  int currentPage = 0;
  
  void _updateInformation() {
    setState(() {
      currentPage = 0;
      _isInformationFetched = false;
      _isFilterApplied = false;
    });
  }

  void _getInformation() async {
    print('getting information...');
    final categories = await fetchFromRegulusVercel('productlines');
    final products = await fetchFromRegulusVercel('products');

    if (categories.isNotEmpty && products.isNotEmpty) {      
      if (categories.keys.contains('error')) {
        setState(() {
          _isError = true;
          _errorText = '${_errorText}Categories: ${categories['code']} ${categories['text']}\n';
        });
      }
      if (products.keys.contains('error')) {
        setState(() {
          _isError = true;
          _errorText = '${_errorText}Products: ${products['code']} ${products['text']}\n';
        });
      }
      if (categories.keys.contains('categories')) {
        setState(() {
          _categories = categories['categories'];
        });
        //print(categories['categories']);
      }
      if (products.keys.contains('products')) {
        setState(() {
          _products = products['products'];
          _filteredProducts = _products;
        });
        //print(products['products'][0]['code']);
      }
      setState(() {
        _isInformationFetched = true;
        _isFilterApplied = false;
      });          
    }
  }

  void _applyFilter() async {
    print('filtering products...');
    List filteredCategories = [];
    final filter = ref.read(filterProvider.notifier).getFilter();
    final pref = await SharedPreferences.getInstance();
    final filterPref = pref.getString('filter');

    if (filter.isNotEmpty) {
      for (int i = 0; i < filter.length; i++) {
        if (filter[i]) {filteredCategories.add(_categories[i]['name']);}
      }
    } else {
      if (filterPref != null) {
        final List dynamicList = jsonDecode(filterPref);
        final List<bool> boolList = dynamicList.cast<bool>();

        if (boolList.isNotEmpty) {
          for (int i = 0; i < boolList.length; i++) {
            if (boolList[i]) {filteredCategories.add(_categories[i]['name']);}
          }
        }
      }
    }
    
    List filteredProducts = [];
    if (filteredCategories.isNotEmpty) {
      for (Map p in _products!) {
        if (filteredCategories.contains(p['productLine'])) {
          filteredProducts.add(p);
        }
      }
      setState(() {
        _filteredProducts = filteredProducts;
        _isFilterApplied = true;
      });      
    } else {
      setState(() {
        _filteredProducts = _products;
        _isFilterApplied = true;
      });
    }
  }

  List<dynamic> get currentItems {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;

    return _filteredProducts!
        .sublist(startIndex, endIndex > _filteredProducts!.length ? _filteredProducts!.length : endIndex);
  }

  void _nextPage() {
    if ((currentPage + 1) * itemsPerPage < _filteredProducts!.length) {
      setState(() {
        currentPage++;
      });
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build _GalleryScreenState...');
    ref.watch(filterProvider);

    if (!_isInformationFetched) {
      _getInformation();
      setState(() {
        _scaffoldBody = ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });
    } else {
      if (_isError) {
        setState(() {
          _scaffoldBody = ConstrainedBox(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Center(
              child: Text(
                _errorText,
                style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
            ),
          );
        });
      } else {
        if (!_isFilterApplied) { _applyFilter(); }
        setState(() {          
          _scaffoldBody = Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ProductsGrid(products: currentItems),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _previousPage,
                      child: Text('Previous'),
                    ),
                    Text('Page ${currentPage + 1}'),
                    ElevatedButton(
                      onPressed: _nextPage,
                      child: Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          );
        });  
      }    
    }

    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'E-Store',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        actions: [
          // Filter
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => FilterScreen(
                    options: _categories, updateInformation: _updateInformation,),
                )
              );
            },
            icon: Icon(Icons.filter_alt),
          ),
          // Search
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => SearchScreen(),
                )
              );
            },
            icon: Icon(Icons.search),
          ),
          // About screen
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AboutScreen(),
                )
              );
            },
            icon: Icon(Icons.info),
          ),
        ],
      ),
      body: SafeArea(
        child: _scaffoldBody!,
      )
    );
  }
}