import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/ui/viewmodels/manage_account_viewmodel.dart';

class ManageAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ManageAccountViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Account'),
        ),
        body: Consumer<ManageAccountViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(child: Text(viewModel.errorMessage!));
            }

            if (viewModel.user == null) {
              return Center(child: Text('Could not load user data.'));
            }

            final user = viewModel.user!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 24),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Name'),
                      subtitle: Text('${user.firstName} ${user.lastName}'),
                    ),
                  ),
                  SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Email'),
                      subtitle: Text(user.email),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.logout),
                      label: Text('Logout'),
                      onPressed: () {
                        viewModel.logout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}