import 'dart:math';
import 'package:elearning/Screens/StudyZoneScreen/LesonCompleted.dart';
import 'package:elearning/constants.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatefulWidget {
  final String url;
  final String title;
  final String desc;

  PDFViewerPage({required this.url, required this.desc, required this.title});
  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewerController;
  late TextEditingController _controller;
  late bool isDone;
  int maxPageReach = 0;
  int currPage = 0;

  @override
  void initState() {
    super.initState();
    isDone = false;
    _pdfViewerController = PdfViewerController();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isDone
                ? (currPage != 0)
                    ? FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          _pdfViewerController.previousPage();
                        },
                        child: Icon(Icons.arrow_back),
                      )
                    : Text('')
                : Text(''),
            (isDone)
                ? (((currPage + 1) > (_pdfViewerController.pageCount - 1)))
                    ? FloatingActionButton.extended(
                        heroTag: null,
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LessonCompleted()));
                        },
                        label: Text(
                          'Finish',
                          style: TextStyle(fontSize: 20),
                        ))
                    : FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          _pdfViewerController.nextPage();
                        },
                        child: Icon(Icons.arrow_forward),
                      )
                : Text('')
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StepProgressIndicator(
              customColor: (index) => (index == currPage)
                  ? (kPrimaryColor)
                  : (index < maxPageReach)
                      ? Colors.blue.shade400
                      : Colors.grey,
              customSize: (index, h) => (index == currPage) ? 10 : 5,
              selectedSize: 10,
              unselectedSize: 5,
              totalSteps: isDone ? _pdfViewerController.pageCount : 1,
              currentStep: isDone ? _pdfViewerController.pageNumber : 1,
            ),
          ),
          Expanded(
            child: SfPdfViewer.network(
              'https://careerliftprod.s3.amazonaws.com/' + widget.url,
              enableTextSelection: false,
              pageSpacing: 10,
              canShowScrollHead: false,
              onPageChanged: (e) {
                if (e.newPageNumber > e.oldPageNumber) {
                  if (mounted) {
                    setState(() {
                      currPage =
                          (currPage + 1) > _pdfViewerController.pageCount - 1
                              ? currPage
                              : (e.newPageNumber - 1);
                      maxPageReach = max(currPage, maxPageReach);
                    });
                  }
                } else if (e.newPageNumber < e.oldPageNumber) {
                  if (mounted) {
                    setState(() {
                      currPage = (currPage - 1) > 0 ? e.newPageNumber - 1 : 0;
                    });
                  }
                }
              },
              key: _pdfViewerKey,
              controller: _pdfViewerController,
              onDocumentLoaded: (e) {
                if (mounted)
                  setState(() {
                    isDone = true;
                  });
              },
            ),
          ),
        ],
      ),
    );
  }
}
