import 'package:bucketlist/pages/add_bucket_list.dart';
import 'package:bucketlist/pages/view_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> bucketListData = [];
  bool isLoading = false;
  bool isError = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    //Get data from API
    try {
      Response response = await Dio().get(
          'https://flutterapitest123-7f217-default-rtdb.firebaseio.com/bucketlist.json');

      if (response.data is List) {
        bucketListData = response.data;
      } else {
        bucketListData = [];
      }

      isLoading = false;
      isError = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      isError = true;
      setState(() {});
      // showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //             actions: [
      //               TextButton(
      //                   onPressed: () => Navigator.pop(context),
      //                   child: const Text('OK')),
      //             ],
      //             title: const Text('Cannot get data'),
      //             content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget errorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning, size: 35, color: Colors.red),
          const Text('Cannot get data'),
          OutlinedButton(onPressed: getData, child: const Text('Retry'))
        ],
      ),
    );
  }

  Widget listDataWidget() {
    List<dynamic> completedData = bucketListData
        .where((element) => element is Map && !element['completed'])
        .toList();

    return completedData.isEmpty
        ? const Center(
            child: Text('No data on bucket list.'),
          )
        : ListView.builder(
            itemCount: bucketListData.length,
            itemBuilder: (context, index) {
              return (bucketListData[index] is Map &&
                      (!bucketListData[index]['completed']))
                  ? ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ViewItemScreen(
                            title: bucketListData[index]['item'] ?? '',
                            imageUrl: bucketListData[index]['image'] ?? '',
                            index: index,
                          );
                        })).then((value) {
                          if (value == 'updated') {
                            getData();
                          }
                        });
                      },
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(bucketListData[index]?['image'] ?? ''),
                      ),
                      title: Text(bucketListData[index]?['item'] ?? ''),
                      subtitle:
                          Text(bucketListData[index]?['cost'].toString() ?? ''),
                    )
                  : const SizedBox();
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddBucketList(
              newIndex: bucketListData.length,
            );
          })).then((value) {
            if (value == 'updated') {
              getData();
            }
          });
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Bucket List',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: getData,
              icon: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => getData(),
        child: (isLoading)
            ? const LinearProgressIndicator()
            : (isError)
                ? errorWidget()
                : listDataWidget(),
      ),
    );
  }
}
