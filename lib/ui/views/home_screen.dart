import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel()..fetchData(),
      child: Scaffold(
        appBar: AppBar(title: Text('Dashboard')),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              itemCount: viewModel.hotels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(viewModel.hotels[index].name),
                  subtitle: Text('Rating: ${viewModel.hotels[index].starRate}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}