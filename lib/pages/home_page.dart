import 'package:api_project/controller/api_controller/user_api_controller.dart';
import 'package:api_project/pages/add_user_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    UsersApiController feedHttp = UsersApiController();
    TextEditingController name = TextEditingController();

    TextEditingController password = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Feed'),
      ),
      drawer: const Drawer(
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: feedHttp.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text('لا توجد بيانات'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(data.name!),
                  subtitle: Text(data.password!),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddUserPage(
            buttonWidget: const Text('Save'),
            name: name,
            password: password,
            onSubmit: () {},
          ),
        ),
      ),
    );
  }
}
