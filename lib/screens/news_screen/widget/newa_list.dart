import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewsList extends StatelessWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Card(
          elevation: 5,
          child: ListTile(
            leading: Icon(Icons.task),
            title: Text('Sample Event'),
            subtitle: Text('This event contect by mma org.'),
          ),
        ),
        Card(
          elevation: 5,
          child: ListTile(
            leading: Icon(Icons.task),
            title: Text('Kick Boxing'),
            subtitle: Text('This event contect by mma org.'),
          ),
        ),
      ],
    );
  }
}
