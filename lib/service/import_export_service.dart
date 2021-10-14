import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

class ImportExportService {
  static ImportExportService of(BuildContext context) => Provider.of<ImportExportService>(context, listen: false);

  ListerFilerFormat _determineFormat(String extension) {
    switch (extension) {
      case '.json':
        return ListerFilerFormat.json;
      default:
        return ListerFilerFormat.txt;
    }
  }

  //TODO
  void importListerFile(String filePath) {
    final extension = p.extension(filePath);
    final ListerFilerFormat fileFormat = _determineFormat(extension);
  }

  //TODO
  void exportListerFile(ListerFilerFormat fileFormat) {}
}

enum ListerFilerFormat { txt, json }
