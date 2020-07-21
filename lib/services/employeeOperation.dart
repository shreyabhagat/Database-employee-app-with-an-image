import 'package:employee_db/model/employee.dart';
import 'package:employee_db/services/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:core';

class EmployeeOpertion {
  EmployeeOpertion._();

  static final EmployeeOpertion instance = EmployeeOpertion._();

  Future<int> addEmployee(Employee employee) async {
    Database db = await DatabaseHelper.instance.database;
    return db.insert('employee', employee.toMap());
  }

  Future<int> deleteEmployee(Employee employee) async {
    Database db = await DatabaseHelper.instance.database;
    return db.delete('employee', where: 'id=?', whereArgs: [employee.id]);
  }

  Future<int> editEmployee(Employee employee) async {
    Database db = await DatabaseHelper.instance.database;
    return db.update('employee', employee.toMap(),
        where: 'id=?', whereArgs: [employee.id]);
  }

  Future<List<Employee>> getAllEmployee() async {
    Database db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> map = await db.query('employee');

    List<Employee> employees = [];

    for (int i = 0; i < map.length; i++) {
      employees.add(Employee.fromMap(map[i]));
    }
    return employees;
  }
}
