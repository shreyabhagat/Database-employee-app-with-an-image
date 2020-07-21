import 'dart:io';

import 'package:employee_db/model/employee.dart';
import 'package:employee_db/services/employeeOperation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEmployee extends StatefulWidget {
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController salaryController = TextEditingController();

  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee'),
      ),
      body: addEmployeeData(),
    );
  }

  Widget addEmployeeData() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          color: Colors.grey,
          child: imageFile == null
              ? Center(
                  child: Text('select image'),
                )
              : Image.file(imageFile, fit: BoxFit.cover),
        ),
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () {
            capturedImage();
          },
        ),
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
          child: Text('Add Student'),
          onPressed: () {
            addEmployeeToDatabase();
          },
        )
      ],
    );
  }

  void addEmployeeToDatabase() async {
    String n = nameController.text;
    String p = postController.text;
    int s = int.parse(salaryController.text);
    String imagepath;

    if (imageFile != null) {
      imagepath = imageFile.path;
    }
    Employee emp = Employee(name: n, post: p, salary: s, image: imagepath);
    await EmployeeOpertion.instance.addEmployee(emp);
    Navigator.pop(context);
  }

  void capturedImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedImage = await picker.getImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }
}
