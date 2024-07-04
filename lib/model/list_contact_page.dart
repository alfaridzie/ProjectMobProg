import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:semester4_tugas_akhir_crud/model/add_page.dart';
import 'package:semester4_tugas_akhir_crud/model/view_page.dart';

class ListContactPage extends StatefulWidget {
  const ListContactPage({super.key});

  @override
  State<ListContactPage> createState() => _ListContactPageState();
}

class _ListContactPageState extends State<ListContactPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 236, 178, 1.0),
      appBar: AppBar(
        title: const Text("Diary Notes"),
        titleTextStyle: TextStyle(
            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        backgroundColor: Color.fromRGBO(117, 71, 55, 1.0),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'tidak ada daftar catatan',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(8),
              // backgroundColor: Color.fromRGBO(247, 142, 13, 1.0),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                var createdString = item['created_at'] as String;
                var newCreatedString =
                    '${createdString.substring(0, 10)} ${createdString.substring(11, 23)}';
                DateTime dt = DateTime.parse(newCreatedString);
                var created = DateFormat("EEE, dd MMM yyyy").format(dt);
                var updatedString = item['updated_at'] as String;
                var newUpdatedString =
                    '${updatedString.substring(0, 10)} ${updatedString.substring(11, 23)}';
                DateTime updatedDt = DateTime.parse(newUpdatedString);
                var updated = DateFormat("EEE, dd MMM yyyy").format(updatedDt);
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: index % 2 == 0
                            ? Color.fromARGB(255, 202, 157, 66)
                            : Color.fromARGB(255, 166, 109, 11),
                        foregroundColor: Colors.white,
                        child: Text('${index + 1}')),
                    title: Text(item['title']),
                    subtitle: Text('dibuat $created \nupdate $updated'),
                    // trailing: SizedBox(
                    //   width: 70,
                    //   child: Row(
                    //     children: const [
                    //       Icon(Icons.remove_red_eye),
                    //       Icon(Icons.edit),
                    //       Icon(Icons.delete)
                    //     ],
                    //   ),
                    // ),
                    trailing: PopupMenuButton(onSelected: (value) {
                      if (value == 'edit') {
                        navigateToEditPage(item);
                      } else if (value == 'delete') {
                        deleteById(id);
                      } else if (value == 'baca') {
                        navigateToViewPage(item);
                      }
                    }, itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 'baca',
                          child: Text('baca'),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('edit'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('delete'),
                        ),
                      ];
                    }),
                  ),
                );
              },
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Icon(Icons.add),
        backgroundColor: Color.fromRGBO(243, 144, 74, 1),
      ),
    );
  }

  Future<void> navigateToViewPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => ViewContactPage(contact: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddContactPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddContactPage(contact: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
      
    });
    fetchData();
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage('delete gagal');
    }
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
