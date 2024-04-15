import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddBucketList extends StatefulWidget {
  final int newIndex;
  const AddBucketList({super.key, required this.newIndex});

  @override
  State<AddBucketList> createState() => _AddBucketListState();
}

class _AddBucketListState extends State<AddBucketList> {
  final TextEditingController itemText = TextEditingController();
  final TextEditingController costText = TextEditingController();
  final TextEditingController imageURLText = TextEditingController();

  Future<void> addData() async {
    //Complete data
    try {
      Map<String, dynamic> data = {
        "item": itemText.text,
        "cost": costText.text,
        "image": imageURLText.text,
        "completed": false
      };

      await Dio().patch(
          'https://flutterapitest123-7f217-default-rtdb.firebaseio.com/bucketlist/${widget.newIndex}.json',
          data: data);
      Navigator.pop(context, 'updated');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var addFormKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Bucket List'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: addFormKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This must not be empty';
                    }
                    return null;
                  },
                  controller: itemText,
                  decoration: const InputDecoration(label: Text('Item')),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This must not be empty';
                    }
                    return null;
                  },
                  controller: costText,
                  decoration:
                      const InputDecoration(label: Text('Estimated Cost')),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This must not be empty';
                    }
                    return null;
                  },
                  controller: imageURLText,
                  decoration: const InputDecoration(label: Text('Image URL')),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            if (addFormKey.currentState!.validate()) {
                              addData();
                            }
                          },
                          child: const Text('Add Item')),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
