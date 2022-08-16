import 'dart:io';

import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFView extends StatelessWidget {
  PDFView({Key? key}) : super(key: key);

  final PdfViewerController _pdfViewerController = PdfViewerController();
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    print(args['file']);
    return Scaffold(
      body: SafeArea(child: Builder(builder: (context) {
        try {
          return Center(
            child: args['type'] == 'file'
                ? SfPdfViewer.file(
                    args['file'] ?? File(''),
                    controller: _pdfViewerController,
                  )
                : SfPdfViewer.network(
                    args['file'],
                    controller: _pdfViewerController,
                  ),
          );
        } catch (e) {
          return bigLoader(color: orangeColor);
        }
      })),
    );
  }
}
