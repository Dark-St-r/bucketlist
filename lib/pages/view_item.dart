import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ViewItemScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final int index;
  const ViewItemScreen(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.index});

  @override
  State<ViewItemScreen> createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  Future<void> deleteData() async {
    Navigator.pop(context);
    //Delete data
    try {
      await Dio().delete(
          'https://flutterapitest123-7f217-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json');
      Navigator.pop(context, 'updated');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> markAsComplete() async {
    //Complete data
    try {
      Map<String, dynamic> data = {
        'completed': true,
      };

      await Dio().patch(
          'https://flutterapitest123-7f217-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json',
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
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'Mark as completed') {
                //Mark as completed
                markAsComplete();
              } else if (value == 'delete') {
                //Delete
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Are you sure you want to delete?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                //Delete
                                deleteData();
                              },
                              child: const Text('Confirm')),
                        ],
                      );
                    });
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: 'Mark as completed',
                  child: Text('Mark as completed'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
