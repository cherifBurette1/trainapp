import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:railway/ApiFunctions/Api.dart';
import 'package:railway/ApiFunctions/shared.dart';
import 'package:railway/models/users.dart';
import 'package:railway/ui/home_page.dart';
import 'package:railway/ui/login.dart';
import 'package:railway/utils/colors_file.dart';
import 'package:railway/utils/custom_widgets/backgrount.dart';
import 'package:railway/utils/custom_widgets/custom_button.dart';
import 'package:railway/utils/custom_widgets/custom_snackBar.dart';
import 'package:railway/utils/global_vars.dart';
import 'package:railway/utils/navigator.dart';
import 'dart:math';
import 'verify.dart';
import 'package:mailer/mailer.dart';

sendMail(String mail) async {
  String username = "railwaymti@gmail.com";
  String password = "Ab1234566.";
  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, 'railwayMTI')
    ..recipients.add(mail)
    ..subject = "Railway email verification"
    ..html =
        "<p>Railway MTI</p> <hr> <p>Dear user,</p> <p>we are sending you this email to verify your account.</p> <p>please enter this code on your application.</p> <p>Your verification code is</p> <p><strong>$vcode</strong></p> <p>have a good day!</p> <p><br></p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('message not sent becase of ' + e.toString());
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  UsersModel usersModel;

  bool checkValue = false;
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  bool _autoValidate = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scafoldState = new GlobalKey<ScaffoldState>();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var repasswordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var phoneCodeController = TextEditingController();

  String valueChoosedPhoneCode;
  List phoneCodeItems = [
    "+20",
    "+213",
    "+216",
    "+962",
    "+961",
    "+963",
    "+964",
  ];
  String phoneno;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldState,
      body: Stack(
        children: [
          Background(),
          SafeArea(
              child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                  padding: EdgeInsets.only(left: 23, right: 23),
                  child: Builder(
                    builder: (context) => Column(
                      children: [
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SvgPicture.asset(
                            "images/train.svg",
                            color: blueAppColor,
                            height: 50,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 15),
                        Text("SIGN UP",
                            style: TextStyle(
                                color: primaryAppColor, fontSize: 32)),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: nameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.name,
                          validator: validateName,
                          style: TextStyle(color: whiteColor),
                          cursorColor: primaryAppColor,
                          decoration: InputDecoration(
                              fillColor: greyPrimaryColor.withOpacity(.1),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: 'Name',
                              hintStyle: TextStyle(color: greyPrimaryColor)),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail,
                          style: TextStyle(color: whiteColor),
                          cursorColor: primaryAppColor,
                          decoration: InputDecoration(
                              fillColor: greyPrimaryColor.withOpacity(.1),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: 'Email',
                              hintStyle: TextStyle(color: greyPrimaryColor)),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: validatePassword,
                          obscureText: _isHidden,
                          style: TextStyle(color: whiteColor),
                          cursorColor: primaryAppColor,
                          decoration: InputDecoration(
                              fillColor: greyPrimaryColor.withOpacity(.1),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: _toggleVisibility,
                                icon: _isHidden
                                    ? Icon(
                                        Icons.visibility_off,
                                        color: greyPrimaryColor,
                                      )
                                    : Icon(
                                        Icons.visibility,
                                        color: whiteColor,
                                      ),
                              ),
                              hintStyle: TextStyle(color: greyPrimaryColor)),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: repasswordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: validatePassword,
                          obscureText: _isHidden,
                          style: TextStyle(color: whiteColor),
                          cursorColor: primaryAppColor,
                          decoration: InputDecoration(
                              fillColor: greyPrimaryColor.withOpacity(.1),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: 're-type Password',
                              suffixIcon: IconButton(
                                onPressed: _toggleVisibility,
                                icon: _isHidden
                                    ? Icon(
                                        Icons.visibility_off,
                                        color: greyPrimaryColor,
                                      )
                                    : Icon(
                                        Icons.visibility,
                                        color: whiteColor,
                                      ),
                              ),
                              hintStyle: TextStyle(color: greyPrimaryColor)),
                        ),
                        SizedBox(height: 20),
                        Container(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              children: [
                                custom_checkBox(),
                                SizedBox(width: 10),
                                Text('I Accept Terms And Conditions',
                                    style: TextStyle(color: whiteColor)),
                              ],
                            )),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height / 10),
                            child: InkWell(
                              onTap: () {
                                _validateInputs();
                                if (formKey.currentState.validate()) {
                                  if (passwordController.text ==
                                      repasswordController.text) {
                                    Api(context)
                                        .userRegister(
                                            scafoldState,
                                            nameController.text,
                                            emailController.text,
                                            passwordController.text,
                                            passwordController.text,
                                            phoneno)
                                        .then((value) {
                                      if (value is UsersModel) {
                                        usersModel = value;
                                        Future.delayed(
                                            Duration(milliseconds: 250), () {
                                          print(
                                              "_isSelected_isSelected ${_isSelected}");
                                          if (_isSelected) {
                                            setUserTocken(
                                              auth_token: usersModel
                                                  .token.plainTextToken
                                                  .split("|")[1],
                                              userId: usersModel.user.id,
                                              userName: usersModel.user.name,
                                              userEmail: usersModel.user.email,
                                              userJoinedTime: usersModel
                                                  .token.accessToken.createdAt,
                                            ).then((value) {
                                              UserTocken =
                                                  "Bearer ${usersModel.token.plainTextToken.split("|")[1]}";
                                              userName = usersModel.user.name;
                                              userEmail = usersModel.user.email;

                                              userJoinedTime = usersModel
                                                  .token.accessToken.createdAt;
                                              userId = usersModel.user.id;
                                              generate();
                                              sendMail(usersModel.user.email);
                                              navigateAndKeepStack(
                                                  context, box2());
                                              // navigateAndKeepStack(context,Competitions());
                                            });
                                          }
//talent_id: 46
                                          else {
                                            CustomSnackBar(
                                                scafoldState,
                                                context,
                                                "Accept terms and conditions");
                                            // navigateAndKeepStack(context,Competitions());
                                          }
                                        });
                                      }
                                    });
                                  } else {
                                    CustomSnackBar(scafoldState, context,
                                        "Password do not match");
                                  }
                                } else
                                  CustomSnackBar(
                                      scafoldState, context, "Invalid Data !");
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: blueAppColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 20, color: primaryAppColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "If You Have Account ",
                              style: TextStyle(color: greyPrimaryColor),
                            ),
                            InkWell(
                              onTap: () {
                                navigateAndClearStack(context, Login());
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "Sign in",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: whiteColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  )),
            ),
          ))
        ],
      ),
    );
  }

  bool _isSelected = false;

  GestureDetector custom_checkBox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: _isSelected ? blueAppColor : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            border: _isSelected
                ? null
                : Border.all(color: greyPrimaryColor, width: 1.0)),
        width: 20,
        height: 20,
        child: _isSelected
            ? Icon(Icons.check, size: 15, color: primaryAppColor)
            : null,
      ),
    );
  }

  void generate() {
    Random random = new Random();
    int randomNumber = random.nextInt(10000);
    setState(() {
      vcode = randomNumber;
    });
  }

  void _validateInputs() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateEmail(String value) {
    Random random = new Random();
    int randomNumber = random.nextInt(10000);
    this.phoneno = "0114156" + randomNumber.toString();
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.length == 0)
      return 'You must enter your Email';
    else if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.length == 0)
      return 'You must enter your Password';
    else if (value.length < 5)
      return 'Enter your Correct Password';
    else
      return null;
  }

  String validatePhoneCode(String value) {
    if (value.length == 0)
      return 'Pick code';
    else
      return null;
  }

  String validatePhone(String value) {
    if (value.length == 0)
      return 'Enter Phone Number';
    else if (value.length < 11)
      return 'Enter a valid Phone Number';
    else
      return null;
  }

  String validateName(String value) {
    if (value.length == 0)
      return 'Enter your Name';
    else if (value.length < 3)
      return 'Enter a Correct Name';
    else
      return null;
  }
}
