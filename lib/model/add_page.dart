import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddContactPage extends StatefulWidget {
  final Map? contact;
  const AddContactPage({super.key, this.contact});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final contact = widget.contact;
    if (contact != null) {
      isEdit = true;
      final name = contact['title'];
      final description = contact['description'];
      nameController.text = name;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    // var elevatedButton = ElevatedButton(
    //   // Navigator.pop(context)
    //   // Navigator.push(context,
    //   //     MaterialPageRoute(builder: (context) => ListContactPage()));
    //   // onPressed:  () => {ListContactPage()},
    //   onPressed: isEdit ? updateData : submitData,
    //   //   print("isEdit ? updateData : submitData");
    //   //   / / pindah ke halaman
    //   //   Navigator.push(context,
    //   //       MaterialPageRoute(builder: (context) => ListContactPage()));
    //   // },
    //   child: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Text(isEdit ? 'update' : 'Submit'),
    //   ),

    //   // ElevatedButton(
    //   //   onPressed: () {
    //   //     // pindah ke halaman simple
    //   //     Navigator.push(context,
    //   //         MaterialPageRoute(builder: (context) => ListContactPage()));
    //   //   },
    //   //   child: Text(
    //   //     'Basic Navigation',
    //   //     style: TextStyle(color: Colors.white),
    //   //   ),
    // );
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 236, 178, 1.0),
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
        titleTextStyle: TextStyle(
            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        backgroundColor: Color.fromRGBO(117, 71, 55, 1.0),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Judul'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Catatan'),
            keyboardType: TextInputType.multiline,
            minLines: 10,
            maxLines: 20,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                isEdit ? 'update' : 'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(243, 144, 74, 1),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final contact = widget.contact;
    if (contact == null) {
      showErrorMessage('ada kesalahan edit');
      return;
    }
    final id = contact['_id'];
    final name = nameController.text;
    final description = descriptionController.text;
    final body = {
      "title": name,
      "description": description,
      "is_completed": false,
    };

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      showSuccessMessage('update catatan berhasil');
    } else {
      showErrorMessage('update catatan gagal');
    }
  }

  Future<void> submitData() async {
    final name = nameController.text;
    final description = descriptionController.text;
    final body = {
      "title": name,
      "description": description,
      "is_completed": false,
    };

    const url = 'https://api.nstack.in/v1/todos/';
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      showSuccessMessage('tambah catatan berhasil');
    } else {
      print(response.body);
      showErrorMessage('tambah catatan gagal');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
