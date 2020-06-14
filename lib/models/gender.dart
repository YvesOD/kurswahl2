import 'package:json_annotation/json_annotation.dart';

enum GenderOptions {
  @JsonValue('m')
  Male,
  @JsonValue('f')
  Female,
}

GenderOptions getGenderOptionsFromString(String genderOptionsAsString) {
  for (GenderOptions element in GenderOptions.values) {
    if (element.toString() == genderOptionsAsString) {
      return element;
    }
  }
  return null;
}