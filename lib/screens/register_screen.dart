import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'package:FoodForGood/components/address_selector.dart';
import 'package:FoodForGood/components/rounded_button.dart';
import 'package:FoodForGood/components/text_feild.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/models/address_model.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:FoodForGood/services/helper_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  bool _showSpinner = false;
  String _name, _email, _password, _confirmPassword;
  Firestore _firestore = Firestore.instance;

  void _openAddressModal(AddressModel addressModel) async {
    showModalBottomSheet(
      clipBehavior: Clip.antiAlias,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (context) {
        return AddressSelector(addressModel: addressModel);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddressModel>(
      create: (context) => AddressModel(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: ModalProgressHUD(
            color: kPrimaryColor,
            inAsyncCall: this._showSpinner,
            child: Material(
              child: Container(
                color: kBackgroundColor,
                child: Center(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      // This will stop overscroll glow effect.
                      overscroll.disallowGlow();
                      return;
                    },
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50.0,
                        vertical: 30.0,
                      ),
                      shrinkWrap: true,
                      children: <Widget>[
                        Center(
                          child: Stack(
                            children: <Widget>[
                              Text(
                                'Start',
                                style: kHeadingStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: <Widget>[
                                    Text(
                                      'Sharing',
                                      style: kHeadingStyle,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      '!',
                                      style: kHeadingStyle.copyWith(
                                        fontSize: 65.0,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        CustomTextFeild(
                          label: 'NAME',
                          prefixIcon: Icon(Icons.person),
                          textCap: TextCapitalization.words,
                          changed: (value) {
                            this._name = value.trim();
                          },
                        ),
                        SizedBox(height: 10.0),
                        CustomTextFeild(
                          label: 'EMAIL',
                          prefixIcon: Icon(Icons.email),
                          kbType: TextInputType.emailAddress,
                          changed: (value) {
                            this._email = value.trim();
                          },
                        ),
                        SizedBox(height: 10.0),
                        CustomTextFeild(
                          label: 'PASSWORD',
                          prefixIcon: Icon(Icons.lock),
                          isPass: true,
                          changed: (value) {
                            this._password = value.trim();
                          },
                        ),
                        SizedBox(height: 10.0),
                        CustomTextFeild(
                          label: 'CONFIRM PASSWORD',
                          prefixIcon: Icon(Icons.lock),
                          isPass: true,
                          changed: (value) {
                            this._confirmPassword = value.trim();
                          },
                        ),
                        SizedBox(height: 20.0),
                        Consumer<AddressModel>(
                          builder: (context, addressModel, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                if (addressModel.text.length > 0)
                                  Expanded(
                                    child: CustomTextFeild(
                                      label: 'LOCATION',
                                      prefixIcon: Icon(Icons.home),
                                      lines: 2,
                                      editingController: TextEditingController(
                                        text: addressModel.text,
                                      ),
                                    ),
                                  ),
                                IconButton(
                                  icon: Icon(Icons.add_location_alt_rounded),
                                  color: kPrimaryColor,
                                  onPressed: () {
                                    //Remove focus from other nodes, close open keyboard if any.
                                    FocusManager.instance.primaryFocus
                                        .unfocus();
                                    this._openAddressModal(addressModel);
                                  },
                                  iconSize: addressModel.text.length == 0
                                      ? 45.0
                                      : 35.0,
                                ),
                                if (addressModel.text.length == 0)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ADD',
                                        style: kTextStyle.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'LOCATION',
                                        style: kTextStyle.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 35.0),
                        Consumer<AddressModel>(
                          builder: (context, addressModel, child) {
                            return RoundedButton(
                              title: 'SIGNUP',
                              colour: kPrimaryColor,
                              pressed: () async {
                                //Remove focus from other nodes, close open keyboard if any.
                                FocusManager.instance.primaryFocus.unfocus();
                                setState(() {
                                  this._showSpinner = true;
                                });
                                try {
                                  HelperService.validateData(
                                      this._name,
                                      this._email,
                                      addressModel.text,
                                      this._password,
                                      this._confirmPassword);

                                  // Creating new user.
                                  String currentUserUid = await AuthService()
                                      .createUserWithEmailAndPassword(
                                          this._email,
                                          this._password,
                                          this._name);

                                  // Saving user info to firestore.
                                  await this
                                      ._firestore
                                      .collection('users')
                                      .document(this._email)
                                      .setData(
                                    {
                                      'username': this._name,
                                      'address': {
                                        'location': GeoPoint(
                                            addressModel.location.latitude,
                                            addressModel.location.longitude),
                                        'text': addressModel.text
                                      },
                                      'sharedWith': 0,
                                      'requestedFrom': 0,
                                    },
                                  );
                                  if (currentUserUid != null) {
                                    kShowFlushBar(
                                        content:
                                            'Please verify your email and Sing-In to your account.',
                                        customError: true);
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  }
                                } catch (error) {
                                  print(error.toString());
                                  kShowFlushBar(
                                      content: error.toString(),
                                      context: context);
                                }
                                setState(() {
                                  this._showSpinner = false;
                                });
                              },
                            );
                          },
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Already a member?',
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(width: 5.0),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: Text(
                                'Login!',
                                style: TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
