import 'dart:async';

import 'package:notes/src/data/app_database.dart';
import 'package:notes/src/data/dao/slider/slider_dao.dart';
import 'package:notes/src/data/model/slider/slider.dart';

class SliderRepository {
  final SliderDao _sliderDao = SliderDao(database: AppDatabase.db.database);

  Future<int> insert(CustomSlider slider) => _sliderDao.insert(slider.toMap());

  Future<List<CustomSlider>> getAllSliders() => _sliderDao.getAllSliders();
}
