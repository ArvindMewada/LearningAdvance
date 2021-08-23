import 'package:elearning/MyStore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  MyStore store = VxState.store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.yellow.shade100,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Text(
                                '40',
                                style: TextStyle(fontSize: 40),
                              ),
                              Text('Test Attempted',
                                  style: TextStyle(fontSize: 20))
                            ],
                          ),
                        )))),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Column(children: [
                  Material(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      title: Text(
                        'Tests Cleared',
                        style: TextStyle(color: Colors.green.shade900),
                      ),
                      trailing: Text('30',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Material(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      title: Text(
                        'Tests Failed',
                        style: TextStyle(color: Colors.red),
                      ),
                      trailing: Text(
                        '10',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]))
              ],
            ),
            ListTile(
                title: Text('Your Community Activity',
                    style: TextStyle(fontSize: 20))),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text(
                          store.studentData.userFirstName! +
                              ' ' +
                              store.studentData.userLastName!,
                          style: TextStyle(fontSize: 15)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 30),
                      child: Text('Post description here',
                          style: TextStyle(fontSize: 20)),
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text(
                          store.studentData.userFirstName! +
                              ' ' +
                              store.studentData.userLastName!,
                          style: TextStyle(fontSize: 15)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 30),
                      child: Text('Post description here',
                          style: TextStyle(fontSize: 20)),
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text(
                          store.studentData.userFirstName! +
                              ' ' +
                              store.studentData.userLastName!,
                          style: TextStyle(fontSize: 15)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 30),
                      child: Text('Post description here',
                          style: TextStyle(fontSize: 20)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
