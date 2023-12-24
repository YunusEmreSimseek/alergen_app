import 'package:alergen_app/product/model/product_model.dart';
import 'package:flutter/material.dart';

class HomeSearchDelegate extends SearchDelegate<ProductModel?> {
  HomeSearchDelegate(this.products);

  final List<ProductModel> products;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products.where(
      (element) => element.name?.toLowerCase().contains(query.toLowerCase()) ?? false,
    );
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(title: Text(results.elementAt(index).name ?? '')),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = products.where(
      (element) => element.name?.toLowerCase().contains(query.toLowerCase()) ?? false,
    );
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
              onTap: () => close(context, results.elementAt(index)), title: Text(results.elementAt(index).name ?? '')),
        );
      },
    );
  }
}
