import 'package:bmi/screen/calculatorUi.dart';
import 'package:bmi/widget/scaffoldMessenger.dart';
import 'package:flutter/material.dart';

class AllFunctions {
  static double? poundToKg(
      BuildContext context, TextEditingController weightControllerInPound) {
    final pound = double.tryParse(weightControllerInPound.text.trim());
    if (pound == null || pound <= 0) {
      MySnackbar.popUp(context, 'Please enter valid weight in pound.');
      return null;
    }
    return pound * 0.45359237;
  }

  static double? cmToMeter(
      BuildContext context, TextEditingController heightControllerInCm) {
    final cm = double.tryParse(heightControllerInCm.text.trim());
    if (cm == null || cm <= 0) {
      MySnackbar.popUp(context, 'Please enter valid height in cm.');
      return null;
    }
    return cm / 100.0;
  }

  static double? inchFeetToMeter(
      BuildContext context,
      TextEditingController heightControllerInFeet,
      TextEditingController heightControllerInInch) {
    final feet = double.tryParse(heightControllerInFeet.text.trim());
    final inch = double.tryParse(heightControllerInInch.text.trim());
    if (feet == null || feet <= 0) {
      MySnackbar.popUp(context, 'Please enter valid height in feet.');
      return null;
    }
    // print("$feet $inch");
    return (feet * 12 + inch!) * 0.0254;
  }

  static List<dynamic> calculateBMI(
      BuildContext context,
      WeightUnit weightUnit,
      HeightUnit heightUnit,
      TextEditingController weightControllerInKG,
      TextEditingController weightControllerInPound,
      TextEditingController heightControllerInMeter,
      TextEditingController heightControllerInCm,
      TextEditingController heightControllerInFeet,
      TextEditingController heightControllerInInch) {
    final height;
    final weight = weightUnit == WeightUnit.kg
        ? double.tryParse(weightControllerInKG.text.trim())
        : AllFunctions.poundToKg(context, weightControllerInPound);
    if (heightUnit == HeightUnit.m) {
      height = double.tryParse(heightControllerInMeter.text.trim());
    } else if (heightUnit == HeightUnit.cm) {
      height = AllFunctions.cmToMeter(context, heightControllerInCm);
    } else {
      height = AllFunctions.inchFeetToMeter(
          context, heightControllerInFeet, heightControllerInInch);
    }
    if (weight == null || weight <= 0 || height == null || height <= 0) {
      MySnackbar.popUp(context, 'Please enter valid weight and height.');
    }
    final bmi = (weight! / (height * height));
    final category = bmi < 18.5
        ? "Underweight"
        : bmi < 25
            ? "Normal"
            : bmi < 30
                ? "Overweight"
                : "Obese";

    return [bmi.toStringAsFixed(1), category];
  }
}
