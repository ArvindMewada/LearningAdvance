import 'package:elearning/objectbox.g.dart';
import 'package:elearning/schemas/clientDataSchema.dart';
import 'package:elearning/schemas/studentDataSchema.dart';
import 'package:elearning/schemas/studentPermissionSchema.dart';
import 'package:objectbox/objectbox.dart';
import "package:velocity_x/velocity_x.dart";

class MyStore extends VxStore {
  ClientData clientData = ClientData(homeElements: [], flag: 0);
  List clientPermissionList = [];
  StudentPermission studentPermission =
      StudentPermission(flag: 0, studentPermissions: []);
  String studentHash = '';
  String studentID = '';
  StudentData studentData = StudentData(
      userImagePath: '',
      userId: '',
      userHash: '',
      userFirstName: '',
      userLastName: '',
      userEmail: '',
      userContactNo: '',
      userAddress: '',
      zipCode: '',
      userQual: '',
      stream: '',
      orgName: '',
      jobTitle: '',
      prevExamPercentage: '',
      userStateName: '',
      userCountryName: '',
      userCityName: '',
      role: '',
      isAdmin: false,
      percentage: 0,
      flag: 0);
  String emailID = '';
  String recievedOTP = '';
  dynamic studyZoneContent;
  late Store dataStore;
}
