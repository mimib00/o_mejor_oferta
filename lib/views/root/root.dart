import 'package:flutter/material.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/meta/models/user.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: FutureBuilder<User?>(
        future: Authenticator.instance.getUser(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container();
          final user = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(user.name),
                Text(user.email),
                Text(user.phone),
              ],
            ),
          );
        },
      ),
    );
  }
}
