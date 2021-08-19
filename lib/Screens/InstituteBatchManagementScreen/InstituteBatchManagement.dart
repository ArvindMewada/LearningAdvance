import 'dart:convert';
import 'package:elearning/MyStore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:elearning/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class InstituteBatchManagement extends StatefulWidget {
  const InstituteBatchManagement({Key? key}) : super(key: key);

  @override
  _InstituteBatchManagementState createState() =>
      _InstituteBatchManagementState();
}

class _InstituteBatchManagementState extends State<InstituteBatchManagement> {
  MyStore store = VxState.store;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Institute Batch Management'),
      ),
      body: batchManagement(),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchBatchDetails();
  }

  var _batchDataJSON = new Map();
  bool dataFound = false;

  void fetchBatchDetails() async {
    try {
      final response = await http.post(Uri.parse(getBatchDetail_URL), body: {
        'app_id': appID,
        'app_hash': app_hash,
        'user_id': store.studentID,
        'user_hash': store.studentHash,
      });
      final jsonData = jsonDecode(response.body) as Map;
      print(jsonData);
      setState(() {
        _batchDataJSON = jsonData;
        dataFound = true;
      });
    } catch (err) {
      print('Error:');
      print(err);
    }
  }

  Widget batchManagement() {
    final batchList = <Widget>[];
    if(_batchDataJSON['flag']==1) {
      if (dataFound) {
        for (int i = 0; i < _batchDataJSON['batch_data'].length; i++) {
          // print(_batchDataJSON['batch_detail'][i]);
          // print(_batchDataJSON['batch_data'][i]['batch_name']);
          batchList.add(listContent(_batchDataJSON['batch_detail'][i],
              _batchDataJSON['batch_data'][i]['batch_name']));
        }
      }
      return Container(
        child: ListView(
          children: batchList,
        ),
      );
    }else if(batchList.length  == 0){
      return Center(child: CircularProgressIndicator());
    }else{
      return noDataFound();
    }
  }

  Widget listContent(Map batchDetails, String batchName) {
    String facultyName,batchDate,subject;
    facultyName=(batchDetails['faculty_name']==null)?'N/A':batchDetails['faculty_name'];
    batchDate=(batchDetails['batch_date']==null)?'N?A':batchDetails['batch_date'];
    subject =(batchDetails['subject']==null)?'N/A':batchDetails['subject'];
    // print('$facultyName  $batchDate $subject');
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).hintColor.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8,8,8,8),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
                backgroundColor: Colors.white,
                trailing: Icon(Icons.arrow_downward),
                initiallyExpanded: false,
                title: Text(
                  batchName,
                  style: TextStyle(fontSize: 20),
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 15.0,),
                      Expanded(
                          flex: 1,
                          child: Text('BatchDate:')),
                      Expanded(
                          flex:2,
                          child: Text(batchDate)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 15.0,),
                      Expanded(
                          flex: 1,
                          child: Text('Subject:')),
                      Expanded(
                          flex:2,
                          child: Text(subject)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(width: 15.0,),
                      Expanded(
                          flex: 1,
                          child: Text('FacultyName:')),
                      Expanded(
                          flex:2,
                          child: Text(facultyName)),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Widget noDataFound() {
    return Center(
      child: Text(''
          'No Batch Scheduled!!'),
    );
  }
}
