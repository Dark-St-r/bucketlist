import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddBucketList extends StatefulWidget {
  final int newIndex;
  const AddBucketList({super.key, required this.newIndex});

  @override
  State<AddBucketList> createState() => _AddBucketListState();
}

class _AddBucketListState extends State<AddBucketList> {
  Future<void> addData() async {
    //Complete data
    try {
      Map<String, dynamic> data = {
        "item": "Visit Antigua & Barbuda",
        "cost": 1500,
        "image":
            "https://media.tacdn.com/media/attractions-content--1x-1/10/5a/8a/90.jpg",
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bucket List'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: addData,
          child: const Text('Add'),
        ),
      ),
    );
  }
}
