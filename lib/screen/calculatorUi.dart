import 'package:bmi/widget/scaffoldMessenger.dart';
import 'package:bmi/utils/bmi_utils.dart';
import 'package:flutter/material.dart';
import 'package:bmi/widget/inputTextField.dart';

enum WeightUnit { kg, lbs }

enum HeightUnit { m, cm, ftInch }

class BMICalculatorUi extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();

  BMICalculatorUi({super.key});

  @override
  State<BMICalculatorUi> createState() => _BMICalculatorUiState();
}

class _BMICalculatorUiState extends State<BMICalculatorUi> {
  //enum
  WeightUnit? weightUnit = WeightUnit.kg;
  HeightUnit? heightUnit = HeightUnit.m;
  //controller
  final TextEditingController _weightControllerInKG = TextEditingController();
  final TextEditingController _weightControllerInPound =
      TextEditingController();
  final TextEditingController _heightControllerInMeter =
      TextEditingController();
  final TextEditingController _heightControllerInCm = TextEditingController();
  final TextEditingController _heightControllerInFeet = TextEditingController();
  final TextEditingController _heightControllerInInch = TextEditingController();

  //local variable
  String _result = "";
  String _category = "";
  bool _pressed = false;

  //Refresh indicator
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _result = "";
      _category = "";
      _pressed = false;
      _weightControllerInKG.clear();
      _weightControllerInPound.clear();
      _heightControllerInMeter.clear();
      _heightControllerInCm.clear();
      _heightControllerInFeet.clear();
      _heightControllerInInch.clear();
    });
  }

  final Map<String, String> comment = {
    "Underweight":
        "You are underweight. Eat nutrient-rich foods, increase calorie intake, and do strength training exercises.",
    "Normal":
        "Great! Maintain your weight with a balanced diet and regular exercise.",
    "Overweight":
        "You are overweight. Consider adopting a balanced diet, engaging in physical activity, and seeking professional guidance for weight management.",
    "Obese":
        "You are obese. Consult a healthcare professional, follow a strict diet, and exercise regularly."
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BMI Calculator",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.orange,

        //refresh button
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _result = "";
                  _category = "";
                  _pressed = false;
                  _weightControllerInKG.clear();
                  _weightControllerInPound.clear();
                  _heightControllerInMeter.clear();
                  _heightControllerInCm.clear();
                  _heightControllerInFeet.clear();
                  _heightControllerInInch.clear();
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: widget._formKey,
              child: ListView(
                children: [
                  const Text(
                    "Weight Unit",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SegmentedButton<WeightUnit>(
                    segments: const [
                      ButtonSegment<WeightUnit>(
                        value: WeightUnit.kg,
                        label: Text("Kg"),
                      ),
                      ButtonSegment(
                        value: WeightUnit.lbs,
                        label: Text("Lbs"),
                      ),
                    ],
                    selected: {weightUnit!},
                    onSelectionChanged: (value) {
                      setState(() {
                        weightUnit = value.first;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (weightUnit == WeightUnit.kg) ...[
                    InputTextField(
                        labelText: 'Enter Weight (in KG)',
                        controller: _weightControllerInKG),
                  ] else ...[
                    InputTextField(
                        labelText: 'Enter Weight (in Pound)',
                        controller: _weightControllerInPound),
                  ],
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Height Unit",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SegmentedButton<HeightUnit>(
                    segments: const [
                      ButtonSegment<HeightUnit>(
                          value: HeightUnit.m, label: Text("Meter")),
                      ButtonSegment<HeightUnit>(
                          value: HeightUnit.cm, label: Text("CM")),
                      ButtonSegment<HeightUnit>(
                          value: HeightUnit.ftInch, label: Text("FeetInch")),
                    ],
                    selected: {heightUnit!},
                    onSelectionChanged: (value) {
                      setState(() {
                        heightUnit = value.first;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (heightUnit == HeightUnit.m) ...[
                    InputTextField(
                        labelText: 'Enter Height (in Meter)',
                        controller: _heightControllerInMeter),
                  ] else if (heightUnit == HeightUnit.cm) ...[
                    InputTextField(
                        labelText: 'Enter Height (in CM)',
                        controller: _heightControllerInCm),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: InputTextField(
                              labelText: "Enter Height (in Feet)",
                              controller: _heightControllerInFeet),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: InputTextField(
                              labelText: "Enter Height (in Inch)",
                              controller: _heightControllerInInch),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 60,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        if (widget._formKey.currentState!.validate()) {
                          List args = AllFunctions.calculateBMI(
                              context,
                              weightUnit!,
                              heightUnit!,
                              _weightControllerInKG,
                              _weightControllerInPound,
                              _heightControllerInMeter,
                              _heightControllerInCm,
                              _heightControllerInFeet,
                              _heightControllerInInch);
                          _pressed = true;
                          setState(() {
                            _result = args[0];
                            _category = args[1];
                          });
                          // print(_pressed);
                        } else {
                          MySnackbar.popUp(
                              context, 'Please fill all fields properly.');
                        }
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF9800),
                              Color(0xFFFFC107),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "Calculate BMI",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  if (_pressed) ...[
                    Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFF3E0),
                              Color(0xFFFFCC80),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "BMI Result",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4)),
                                ],
                              ),
                              child: Text(
                                "BMI: $_result",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: _category == "Underweight"
                                    ? LinearGradient(colors: [
                                        Colors.blue.shade300,
                                        Colors.blue.shade600
                                      ])
                                    : _category == "Normal"
                                        ? LinearGradient(colors: [
                                            Colors.green.shade400,
                                            Colors.green.shade700
                                          ])
                                        : _category == "Overweight"
                                            ? LinearGradient(colors: [
                                                Colors.yellow.shade400,
                                                Colors.orange.shade600
                                              ])
                                            : LinearGradient(colors: [
                                                Colors.red.shade400,
                                                Colors.red.shade700
                                              ]),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _category == "Underweight"
                                        ? Icons.warning_amber_rounded
                                        : _category == "Normal"
                                            ? Icons.check_circle_outline
                                            : _category == "Overweight"
                                                ? Icons.fitness_center
                                                : Icons.health_and_safety,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "Category: $_category",
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                comment[_category] ?? "",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
