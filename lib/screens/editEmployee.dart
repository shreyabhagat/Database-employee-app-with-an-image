import 'dart:io';

import 'package:employee_db/services/employeeOperation.dart';
import 'package:flutter/material.dart';
import 'package:employee_db/model/employee.dart';
import 'package:image_picker/image_picker.dart';
import 'package:employee_db/services/push_to_next_page.dart';

class EditEmployee extends StatefulWidget {
  final Employee employee;

  EditEmployee({this.employee});

  @override
  _EditEmployeeState createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController postController = TextEditingController();

  final TextEditingController salaryController = TextEditingController();

  File imageFile;

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.employee.name;
    postController.text = widget.employee.post;
    salaryController.text = widget.employee.salary.toString();
    if (widget.employee.image != null) {
      imageFile = File(widget.employee.image);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Employee'),
      ),
      body: editEmployeeData(),
    );
  }

  Widget editEmployeeData() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          color: Colors.grey,
          child: imageFile == null
              ? Center(
                  child: Text('Select image'),
                )
              : Image.file(imageFile, fit: BoxFit.cover),
        ),
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () {
            capturedImage();
          },
        ),
        SizedBox(height: 16),
        TextField(
          controller: nameController,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Name',
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: postController,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Post',
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: salaryController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Salary',
          ),
        ),
        SizedBox(height: 16),
        RaisedButton(
          child: Text('Edit Student'),
          onPressed: () {
            editDataToDatabase();
          },
        )
      ],
    );
  }

  void editDataToDatabase() async {
    String n = nameController.text;
    String p = postController.text;
    int s = int.parse(salaryController.text);
    String image = imageFile.path;
    Employee temp = widget.employee;
    Employee e =
        Employee(id: temp.id, name: n, post: p, salary: s, image: image);

    await EmployeeOpertion.instance.editEmployee(e);
    Navigator.pop(context);
  }

  void capturedImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
