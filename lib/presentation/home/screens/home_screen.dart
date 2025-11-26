import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authentication/manager/auth_bloc.dart';
import '../../authentication/widgets/common_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: CommonButton(title: 'Logout', onPressed: () {context.read<AuthBloc>().add(DeleteUserEvent()); },),
      ),
    );
  }
}