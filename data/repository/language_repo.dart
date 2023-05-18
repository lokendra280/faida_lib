import 'package:faidanepal/data/model/response/language_model.dart';
import 'package:faidanepal/util/app_constants.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext context}) {
    return AppConstants.languages;
  }
}
