import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:k2mobileapp/login.dart';
import 'package:k2mobileapp/pages/employee_list.dart';
import 'package:k2mobileapp/theme.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:http/http.dart' as http;

import 'models/EmpDailyEmployee.dart';
import 'models/EmployeeList.dart';
import 'models/JobList.dart';
import 'models/LocationList.dart';

///// เรียกรายชื่อลูกน้อง

List<Employeelist> itemsList = [];
List<EmpDailyEmployee> empdaily = [];
List<JobMaster> jobms = [];
List<LocationMaster> locationms = [];

Future<List<Employeelist>> GetEmployeeList() async {
  try {
    var _baseUrl =
        "https://dev-unique.com:9012/api/Daily/GetListEmpDailyBySuppervisor?suppervisor=3900001";
    final res = await http.get(
      Uri.parse("$_baseUrl"),
    );

    // if (res.statusCode == 200) {
    final jsonData = json.decode(res.body);

    List<dynamic> parsedListJson = jsonDecode(res.body);

    // print(parsedListJson);

    itemsList = List<Employeelist>.from(parsedListJson
        .map<Employeelist>((dynamic i) => Employeelist.fromJson(i)));

    // print(itemsList.length);

    return itemsList;
  } catch (err) {
    print('Something went wrong');

    return <Employeelist>[];
  }
}

/////search employee
Future<List<EmpDailyEmployee>> GetEmpDailyEmployee(var empcode) async {
  try {
    var _baseUrl =
        "https://dev-unique.com:9012/api/Daily/GetEmpDailyEmployee?empcode=${empcode}";
    final res = await http.get(
      Uri.parse("$_baseUrl"),
    );

    // if (res.statusCode == 200) {
    final jsonData = json.decode(res.body);

    List<dynamic> parsedListJson = jsonDecode(res.body);

    empdaily = List<EmpDailyEmployee>.from(parsedListJson
        .map<EmpDailyEmployee>((dynamic i) => EmpDailyEmployee.fromJson(i)));

    return empdaily;
  } catch (err) {
    print('Something went wrong');

    return <EmpDailyEmployee>[];
  }
}

PostTempEmployeeDaily(var tojsontext) async {
  try {
    final _baseUrl =
        'https://dev-unique.com:9012/api/Daily/PostTempEmployeeDaily';
    final res = await http.post(Uri.parse("${_baseUrl}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(tojsontext));

    return res;
  } catch (err) {
    print('Something went wrong');

    return [];
  }
}

/////Job MS
Future<List<JobMaster>> GetJobMaster(var projectcode) async {
  try {
    var _baseUrl =
        "https://dev-unique.com:9012/api/Daily/GetDropDownJobMaster?projectcode=${projectcode}";
    final res = await http.get(
      Uri.parse("$_baseUrl"),
    );

    // if (res.statusCode == 200) {
    final jsonData = json.decode(res.body);

    List<dynamic> parsedListJson = jsonDecode(res.body);

    jobms = List<JobMaster>.from(
        parsedListJson.map<JobMaster>((dynamic i) => JobMaster.fromJson(i)));

    return jobms;
  } catch (err) {
    print('Something went wrong');

    return <JobMaster>[];
  }
}

/////Location MS
Future<List<LocationMaster>> GetLocationMaster(var projectcode) async {
  try {
    var _baseUrl =
        "https://dev-unique.com:9012/api/Daily/GetDropDownJobMaster?projectcode=${projectcode}";
    final res = await http.get(
      Uri.parse("$_baseUrl"),
    );

    // if (res.statusCode == 200) {
    final jsonData = json.decode(res.body);

    List<dynamic> parsedListJson = jsonDecode(res.body);

    locationms = List<LocationMaster>.from(parsedListJson
        .map<LocationMaster>((dynamic i) => LocationMaster.fromJson(i)));

    return locationms;
  } catch (err) {
    print('Something went wrong');

    return <LocationMaster>[];
  }
}
