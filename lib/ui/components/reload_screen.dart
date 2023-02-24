import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class ReloadScreen extends StatelessWidget {
  final String error;
  final Future<void> Function() reload;

  const ReloadScreen({
    required this.error,
    required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: TextStyle(fontSize: 26),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: reload,
            child: Text(
              R.strings.reload,
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
