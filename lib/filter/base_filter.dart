import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:lister_app/filter/sort_direction.dart';

abstract class BaseFilter extends ChangeNotifier{

  abstract String defaultSorting;
  abstract SortDirection defaultDirection;

  late Tuple2<String,SortDirection> _sorting;

  BaseFilter(){
    _sorting = Tuple2(defaultSorting, defaultDirection);
  }

  set sorting(Tuple2<String,SortDirection> value){
    _sorting = value;
    notifyListeners();
  }

  Tuple2<String,SortDirection> get sorting => _sorting;

  void resetSorting(){
    _sorting = Tuple2(defaultSorting, defaultDirection);
    notifyListeners();
  }
}