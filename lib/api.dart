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

import 'models/DailyTimeSheet.dart';
import 'models/EmpDailyEmployee.dart';
import 'models/EmployeeData.dart';
import 'models/EmployeeList.dart';
import 'models/JobList.dart';
import 'models/LocationList.dart';
import 'package:flutter/services.dart';
import 'dart:io';

/////
List<Employeelist> itemsList = [];
List<EmpDailyEmployee> empdaily = [];
List<JobMaster> jobms = [];
List<LocationMaster> locationms = [];
List<DailyTimeSheet> timesheet = [];
List<EmployeeData> empprofile = [];

var webconfig = "";
var filejson = "assets/config.json";

///// Get File Json
Future<String> readJsonFile(String filePath) async {
  String data = await rootBundle.loadString('assets/config.json');
  final parsedJson = jsonDecode(data);
  webconfig = parsedJson['WebAPIConfig'];

  return webconfig;
}

///// Get Profile
GetEmpProfile(var empcode) async {
  try {
    webconfig = await readJsonFile(filejson);

    var client = http.Client();
    var uri = Uri.parse(
        "${webconfig}/api/Interface/GetEmployeeData?EmpCode=${empcode}");
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final parsedJson = jsonDecode(response.body);

      print(parsedJson);

      return parsedJson;
    }
  } catch (err) {
    print('Something went wrong');

    return [];
  }
}

///// Employee List
Future<List<Employeelist>> GetEmployeeList() async {
  try {
    webconfig = await readJsonFile(filejson);
    var _baseUrl =
        "${webconfig}/api/Daily/GetListEmpDailyBySuppervisor?suppervisor=3900001";
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
    webconfig = await readJsonFile(filejson);

    var _baseUrl =
        "${webconfig}/api/Daily/GetEmpDailyEmployee?empcode=${empcode}";
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
    webconfig = await readJsonFile(filejson);

    final _baseUrl = '${webconfig}/api/Daily/PostTempEmployeeDaily';
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
    webconfig = await readJsonFile(filejson);

    var _baseUrl =
        "${webconfig}/api/Daily/GetDropDownJobMaster?projectcode=${projectcode}";
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
    webconfig = await readJsonFile(filejson);

    var _baseUrl =
        "${webconfig}/api/Daily/GetDropDownLocation?projectcode=${projectcode}";
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

///// Timesheet
Future<List<DailyTimeSheet>> GetDailyTimesheet(var empcode, var type) async {
  try {
    webconfig = await readJsonFile(filejson);

    var _baseUrl =
        "${webconfig}/api/Daily/GetDailyTimeSheet?empcode=${empcode}&type=${type}";
    final res = await http.get(
      Uri.parse("$_baseUrl"),
    );

    // if (res.statusCode == 200) {
    final jsonData = json.decode(res.body);

    List<dynamic> parsedListJson = jsonDecode(res.body);

    timesheet = List<DailyTimeSheet>.from(parsedListJson
        .map<DailyTimeSheet>((dynamic i) => DailyTimeSheet.fromJson(i)));

    return timesheet;
  } catch (err) {
    print('Something went wrong');

    return <DailyTimeSheet>[];
  }
}

///// Save Timesheet
Future<String> SaveTimesheet() async {
  var config = await readJsonFile(filejson);
  return config + '/api/Daily/SaveDailyTimeSheet';
}

///// Get ValidateLogIn
GetValidateLogIn(var User, var pass) async {
  try {
    webconfig = await readJsonFile(filejson);

    var _baseUrl =
        "${webconfig}/api/Interface/GetLogOn?Username=${User}&Password=${pass}";
    final res = await http.get(
      Uri.parse("$_baseUrl"),
    );

    return res;
  } catch (err) {
    print('Something went wrong');

    return [];
  }
}

///// Get ValidateLogIn
GetValidateToken(var para1) async {
  try {
    webconfig = await readJsonFile(filejson);

    var _baseUrl = "https://dev-unique.com:9018/api/Interface/GetUserByToken";

    Map<String, String> body = {
      'method': '${para1!}',
    };

    final res = await http.post(Uri.parse("${_baseUrl}"),
        headers: {"Content-Type": "application/json"}, body: json.encode(body));

    return res;
  } catch (err) {
    print('Something went wrong');

    return [];
  }
}
