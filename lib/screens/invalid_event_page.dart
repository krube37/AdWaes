import 'package:flutter/material.dart';

class InvalidEventPage extends StatelessWidget {
  const InvalidEventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Event isn\'t available anymore'),
    );
  }
}
