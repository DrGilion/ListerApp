import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

class ImportExportService {
  static ImportExportService of(BuildContext context) => Provider.of<ImportExportService>(context, listen: false);

  ListerFilerFormat _determineFormat(String extension) {
    switch (extension) {
      case '.backup':
        return ListerFilerFormat.backup;
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
    switch (fileFormat) {
      case ListerFilerFormat.backup:
        // TODO: Handle this case.
        break;
      case ListerFilerFormat.txt:
        // TODO: Handle this case.
        break;
      case ListerFilerFormat.json:
        // TODO: Handle this case.
        break;
    }
  }

  //TODO
  void exportListerFile(ListerFilerFormat fileFormat) {}
}

enum ListerFilerFormat { backup, txt, json }
