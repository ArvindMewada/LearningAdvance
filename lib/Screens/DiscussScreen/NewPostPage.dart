import 'dart:convert';
import 'dart:io';

import 'package:elearning/MyStore.dart';
import 'package:elearning/Screens/DiscussScreen/NewPostTextContainer.dart';
import 'package:elearning/constants.dart';
import 'package:elearning/utils/LoadAndDownloadNetworkCall.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';

class NewPostPage extends StatefulWidget {
  final String tag;
  final String communityID;
  final String groupHashTag;

  const NewPostPage(
      {Key? key,
      required this.tag,
      required this.communityID,
      required this.groupHashTag})
      : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  File? _image;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  MyStore store = VxState.store;

  @override
  void initState() {
    _titleController = TextEditingController();
    _descController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> getPermissionRequest(ImageSource imageSource) async {
    if (imageSource == ImageSource.camera &&
        await Permission.camera.request().isGranted) {
      getImageFiles(imageSource);
    }
  }

  Future<void> getImageFiles(ImageSource imageSource) async {
    try {
      PickedFile? pickedFile = await ImagePicker().getImage(
          source: imageSource,
          maxWidth: 1000,
          maxHeight: 1000,
          preferredCameraDevice: CameraDevice.rear);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (r) {
      print(r);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: TextButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              primary: Colors.white,
              backgroundColor: kPrimaryColor),
          onPressed: () async {
            if (_titleController.text.isEmpty)
              showCustomSnackBar(context, 'Please enter the title for post');
            else if (_descController.text.isEmpty)
              showCustomSnackBar(
                  context, 'Please enter the description for post');
            else {
              loadingDialogOpen();
              String base64Image = '';
              if (_image != null) {
                File compressedFile = await FlutterNativeImage.compressImage(
                    _image!.path,
                    quality: 100,
                    percentage: 50);
                List<int> imageBytes = compressedFile.readAsBytesSync();
                base64Image = base64Encode(imageBytes);
                print(base64Image);
              }
              await http.post(Uri.parse(addNewPost_URL), body: {
                'user_id': store.studentID,
                'user_hash': store.studentHash,
                'app_id': appID,
                'post_id': '',
                'user_first_name': store.studentData.userFirstName,
                'user_last_name': store.studentData.userLastName,
                'user_image_url': store.studentData.userImagePath,
                'user_type': store.studentData.role,
                'user_job_title': store.studentData.jobTitle,
                'user_org_name': store.studentData.orgName,
                'user_city_name': store.studentData.userCityName,
                'community_id': widget.communityID,
                'edu_title': _titleController.text,
                'edu_description': _descController.text,
                'tag': widget.tag,
                'post_image': base64Image,
                'video_url': '',
                'group_hash_tag': widget.groupHashTag,
                'post_status': '',
                'do_notify': '0',
                'is_admin': '0',
              }).then((value) async {
                print(value.body);
                SVProgressHUD.dismiss();
                if (value.statusCode != 200) {
                  showCustomSnackBar(context, 'Unable to post.');
                } else {
                  dynamic data = await compute(jsonDecode, value.body);
                  if (data['flag'] == 1) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    showCustomSnackBar(context,
                        'Posted Successfully and is in the review period.');
                  } else {
                    showCustomSnackBar(context, 'Unable to post.');
                  }
                }
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 5),
            child: Text(
              'Post',
              style: TextStyle(fontSize: 20),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text('Write a Post'),
        leading: BackButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text('Confirm Discard?'),
                      content: Text('Do you want to discard this post?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('Yes')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No'))
                      ],
                    ));
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: NewPostTextFieldContainer(
                color: Colors.grey.shade200,
                child: TextField(
                  controller: _titleController,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.name,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: NewPostTextFieldContainer(
              color: Colors.grey.shade200,
              child: TextField(
                controller: _descController,
                maxLines: 10,
                style: TextStyle(fontSize: 20),
                keyboardType: TextInputType.name,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Card(
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Tag: ' + widget.tag,
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Stack(alignment: Alignment.bottomRight, children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.grey.shade400,
                      radius: 50,
                      child: _image == null
                          ? Icon(
                              Icons.image_outlined,
                              size: 50,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                _image!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.fill,
                              )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _image == null
                            ? Container()
                            : IconButton(
                                alignment: Alignment.topRight,
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                icon: CircleAvatar(
                                  radius: 15,
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.orange,
                                  child: Icon(Icons.close),
                                )),
                        IconButton(
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => SimpleDialog(
                                          title: Text('Upload Image'),
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: MaterialButton(
                                                    padding: EdgeInsets.all(8),
                                                    child: Column(
                                                      children: [
                                                        Icon(Icons.photo),
                                                        Text('Gallery')
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      getImageFiles(
                                                          ImageSource.gallery);
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: MaterialButton(
                                                    padding: EdgeInsets.all(8),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Icon(Icons.camera),
                                                        Text('Camera')
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      getPermissionRequest(
                                                          ImageSource.camera);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel'))
                                          ]));
                            },
                            icon: CircleAvatar(
                              radius: 20,
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.orange,
                              child: Icon(
                                Icons.camera_alt_outlined,
                              ),
                            )),
                      ],
                    )
                  ]),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
        ],
      )),
    );
  }
}
