import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vivo_vivo_app/src/components/text_input.dart' as TX;
import 'package:vivo_vivo_app/src/domain/models/person.dart';
import 'package:vivo_vivo_app/src/domain/models/person_disability.dart';
import 'package:vivo_vivo_app/src/domain/models/person_info.dart';
import 'package:vivo_vivo_app/src/screens/Register/components/dropdown_button.dart';
import 'package:vivo_vivo_app/src/screens/Register/components/user_photo.dart';
import 'package:vivo_vivo_app/src/screens/Register/services/get_disability.dart';
import 'package:vivo_vivo_app/src/screens/Register/services/get_ethnic.dart';
import 'package:vivo_vivo_app/src/screens/Register/services/get_gender.dart';
import 'package:vivo_vivo_app/src/screens/Register/services/get_marital_status.dart';
import 'package:vivo_vivo_app/src/screens/Register/step_two_register_view.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';
import 'package:vivo_vivo_app/src/utils/app_validations.dart';

class StepOneRegisterView extends StatefulWidget {
  const StepOneRegisterView({super.key});
  static const String id = 'register_view';

  @override
  State<StepOneRegisterView> createState() => _StepOneRegisterViewState();
}

class _StepOneRegisterViewState extends State<StepOneRegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController idCard = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController maritalStatus = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController ethnic = TextEditingController();
  TextEditingController disabilityPercentage = TextEditingController();
  TextEditingController disability = TextEditingController();
  DateTime? pickerDate;
  bool isDisability = false;
  XFile? imageFile;
  bool isPhoto = false;

  @override
  void initState() {
    super.initState();
    birthDate.text;
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Styles.transparent,
        elevation: 0,
        title: const Text("Información Personal"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(0, 150, 136, 1),
                Color.fromRGBO(56, 56, 76, 1),
              ]),
            ),
          ),
          Center(
            child: SizedBox(
              child: Card(
                semanticContainer: false,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(
                    left: 15, right: 15, top: 80, bottom: 10),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text("Añade una foto retrato"),
                        ),
                        UserPhoto(
                            imageFile: imageFile,
                            onImageSelected: ((file) {
                              setState(() {
                                imageFile = file;
                              });
                            })),
                        if (isPhoto)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "La imagen es obligatoria",
                                style: TextStyle(color: Colors.red[400]),
                              )
                            ],
                          ),
                        const Gap(10),
                        Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TX.TextInput(
                                        hinText: "Ej. Kevin",
                                        label: "Primer Nombre",
                                        textIsEmpty: "Ingrese su Nombre",
                                        inputController: firstName,
                                        keyboardType: TextInputType.name,
                                        lenLimitTextInpFmt: 15,
                                        prefixIcon:
                                            Icons.person_outline_rounded,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                    const Gap(15),
                                    Expanded(
                                      child: TX.TextInput(
                                        hinText: "Ej. Daniel",
                                        label: "Segundo Nombre",
                                        textIsEmpty: "Ingrese su Nombre",
                                        inputController: middleName,
                                        keyboardType: TextInputType.name,
                                        lenLimitTextInpFmt: 15,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                TX.TextInput(
                                  hinText: "Ej. Chicaiza Suarez",
                                  label: "Apellidos",
                                  textIsEmpty: "Ingrese su Apellido",
                                  inputController: lastName,
                                  keyboardType: TextInputType.name,
                                  lenLimitTextInpFmt: 30,
                                  prefixIcon: Icons.person_outline_rounded,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                TX.TextInput(
                                  hinText: "Ej. 1002677784",
                                  label: "Cédula",
                                  textIsEmpty: "Ingrese su Cédula",
                                  inputController: idCard,
                                  keyboardType: TextInputType.number,
                                  lenLimitTextInpFmt: 30,
                                  prefixIcon: Icons.calendar_view_week_outlined,
                                  textInputAction: TextInputAction.next,
                                  validation: Validations.exprOnlyDigits,
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                TX.TextInput(
                                  hinText: "dd/MM/yyyy",
                                  label: "Fecha de nacimiento",
                                  textIsEmpty: "Ingrese su Fecha",
                                  inputController: birthDate,
                                  keyboardType: TextInputType.datetime,
                                  prefixIcon: Icons.calendar_today_outlined,
                                  textInputAction: TextInputAction.next,
                                  readonly: true,
                                  onTap: (() async {
                                    pickerDate = (await showDatePicker(
                                        locale: const Locale("es", "ES"),
                                        context: context,
                                        initialDate: DateTime(2000),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2101)));
                                    if (pickerDate != null) {
                                      final dateFormat =
                                          DateFormat('dd/MM/yyyy')
                                              .format(pickerDate!);
                                      setState(() {
                                        birthDate.text = dateFormat.toString();
                                      });
                                    }
                                  }),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: DropDownBtn(
                                            future: getMaritalStatus(),
                                            label: "Estado Civil",
                                            selectedValue: maritalStatus)),
                                    const Gap(10),
                                    Expanded(
                                        child: DropDownBtn(
                                      future: getGender(),
                                      label: "Genero",
                                      selectedValue: gender,
                                    )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropDownBtn(
                                        future: getEthnic(),
                                        label: "Etnia",
                                        selectedValue: ethnic,
                                      ),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "¿Sufre alguna\n discapacidad?",
                                          style: Styles.textLabel,
                                        ),
                                        Checkbox(
                                            activeColor: Styles.primaryColor,
                                            value: isDisability,
                                            onChanged: (value) {
                                              setState(() {
                                                isDisability = value!;
                                              });
                                            }),
                                      ],
                                    )),
                                  ],
                                ),
                                if (isDisability)
                                  Row(
                                    children: [
                                      Expanded(
                                          child: DropDownBtn(
                                        future: getDisability(),
                                        label: "Discapacidad",
                                        selectedValue: disability,
                                      )),
                                      const Gap(10),
                                      Expanded(
                                        child: TX.TextInput(
                                          hinText: "Ej. 10",
                                          label: "Porcentaje de Discapacidad",
                                          textIsEmpty:
                                              "Ingrese su Discapacidad",
                                          inputController: disabilityPercentage,
                                          keyboardType: TextInputType.number,
                                          lenLimitTextInpFmt: 3,
                                          textInputAction: TextInputAction.done,
                                          validation:
                                              Validations.exprOnlyDigits,
                                        ),
                                      ),
                                    ],
                                  ),
                              ]),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  maximumSize: Size(
                                    (size.width * 0.35),
                                    (size.width * 0.35),
                                  ),
                                  elevation: 10,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Continuar"),
                                    Icon(Icons.arrow_forward_rounded)
                                  ],
                                ),
                                onPressed: () {
                                  _showSecondPageRegister(context);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSecondPageRegister(BuildContext context) async {
    if (checkImage()) return;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String birthDateCast = DateFormat('yyyy-MM-dd').format(pickerDate!);
      Person person = Person(
        firstName: firstName.text,
        middleName: middleName.text,
        lastNames: lastName.text,
        dni: idCard.text,
        avatar: imageFile,
        personInfo: PersonInfo(
          birthDate: DateTime.parse(birthDateCast),
          maritalStatusID: int.parse(maritalStatus.text),
          genderID: int.parse(gender.text),
          ethnicID: int.parse(ethnic.text),
          address: "",
          phone: "",
        ),
        personDisability: (disability.text.isNotEmpty)
            ? PersonDisability(
                disability: disability.text,
                percentage: int.parse(disabilityPercentage.text))
            : null,
      );

      Navigator.of(context)
          .pushNamed(StepTwoRegisterView.id, arguments: person);
    }
  }

  bool checkImage() {
    // ignore: unnecessary_null_comparison
    if (imageFile == null) {
      setState(() {
        isPhoto = true;
      });
      return true;
    } else {
      setState(() {
        isPhoto = false;
      });
      return false;
    }
  }
}
