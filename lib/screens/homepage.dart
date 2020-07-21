import 'dart:io';

import 'package:employee_db/model/employee.dart';
import 'package:employee_db/screens/addEmployee.dart';
import 'package:employee_db/services/employeeOperation.dart';
import 'package:flutter/material.dart';
import 'package:employee_db/services/push_to_next_page.dart';
import 'package:employee_db/screens/editEmployee.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Employee> employee = [];

  void getData() async {
    List<Employee> temp = await EmployeeOpertion.instance.getAllEmployee();

    setState(() {
      employee = temp;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await jumpToAdd();
        },
      ),
      body: employee.length == 0
          ? NoEmployee()
          : DisplayEmployee(
              employee: employee,
            ),
    );
  }

  Future<void> jumpToAdd() async {
    await PushToNextPage.push(context, AddEmployee());
    getData();
  }
}

class NoEmployee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No Employee'),
    );
  }
}

class DisplayEmployee extends StatefulWidget {
  List<Employee> employee;

  DisplayEmployee({this.employee});

  @override
  _DisplayEmployeeState createState() => _DisplayEmployeeState();
}

class _DisplayEmployeeState extends State<DisplayEmployee> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.employee.length,
      itemBuilder: (BuildContext context, int index) {
        Employee emp = widget.employee[index];
        return Card(
          child: ListTile(
            leading: emp.image == null ? employeeName(emp) : getImage(emp),
            title: Text(emp.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(emp.post),
                Text('\u20B9${emp.salary}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteEmployee(emp);
              },
            ),
            onTap: () {
              jumpTpEdit(context, emp);
            },
          ),
        );
      },
    );
  }

  void deleteEmployee(Employee employee) async {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        'Warning',
        style: TextStyle(color: Colors.red),
      ),
      content: Text('Do you really want to delete ${employee.name}?'),
      actions: <Widget>[
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () async {
            await EmployeeOpertion.instance.deleteEmployee(employee);
            List<Employee> temp =
                await EmployeeOpertion.instance.getAllEmployee();
            setState(() {
              widget.employee = temp;
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
    await showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  Future<void> jumpTpEdit(BuildContext context, Employee employee) async {
    await PushToNextPage.push(
      context,
      EditEmployee(
        employee: employee,
      ),
    );
    List<Employee> temp = await EmployeeOpertion.instance.getAllEmployee();
    setState(() {
      widget.employee = temp;
    });
  }

  Widget employeeName(Employee employee) {
    return CircleAvatar(
      child: Text(employee.name[0]),
    );
  }

  Widget getImage(Employee employee) {
    return CircleAvatar(
      backgroundImage: FileImage(
        File(employee.image),
      ),
    );
  }
}
