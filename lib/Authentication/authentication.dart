import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homelyvendor/Home/home_page.dart';
import 'package:homelyvendor/Registration/registration.dart';
import 'package:homelyvendor/components/api.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  var allApi = AllApi();
  var _userEmail = '';
  var _userPassword = '';
  bool loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
    }
    return isValid;
  }

  String type;

  var types = ['Restaurant', 'Lifestyle'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),backgroundColor: kgreen,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: Get.width*0.2,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset('assets/images/homelyy.png'),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color:kgreen,
                        ),
                        label: Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      onSaved: (value) {

                        _userPassword = value;

                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: kgreen,
                        ),
                        label: Text(
                          'Password',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(kdarkgreen)
                            ),
                            onPressed: () async {
                              final canSignIn = _trySubmit();
                              if (canSignIn) {
                                setState(() {
                                  loading = true;
                                });
                                var vendorDetails =
                                    await allApi.getVendor(email: _userEmail);
                                if (vendorDetails != null) {
                                  if (_userPassword == vendorDetails.password) {
                                    setState(() {
                                      loading = false;
                                    });
                                     SharedPreferences pref  = await SharedPreferences.getInstance();

                                     pref.setString('email', vendorDetails.email);

                                    await allApi.putToken(
                                      vendorId: vendorDetails.vendorId,
                                      token: 'token',
                                    );

                                    Get.to(
                                      MyHomePage(
                                        vendorDetails: vendorDetails,
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Incorrect password.'),
                                      ),
                                    );
                                  }
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('User does not exist.'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                    TextButton(
                      onPressed: () {

                        showDialog(context: context, builder: (context){
                          return StatefulBuilder(
                            builder: (context, setState1) {
                              return AlertDialog(
                                title: Text("Select Type"),
                                content:  Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0)),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: const Text('Select Type'),
                                      value: type,
                                      onChanged: (value) {
                                        setState(() {
                                          type = value;
                                        });
                                        setState1(() {

                                        });
                                      },
                                      isExpanded: true,
                                      items: types.map(
                                            (e) {
                                          return DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(onPressed: (){
                                    type == null ? Get.snackbar('Error', 'Select Type',backgroundColor: Colors.redAccent):
                                    Get.to(() =>  Registration(type: type == 'Restaurant' ? 'restro' : 'lifestyle',));
                                  }, child: Text('Continue'))
                                ],
                              );
                            }
                          );
                        });


                      },
                      child: const Text('Register as a vendor'),
                    ),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                        onPressed: () {
                          if (Platform.isIOS) {
                            return launch("whatsapp://wa.me/+919967706767/?text=${Uri.encodeFull('Query From Guest')}");
                          } else {
                            return launch("whatsapp://send?phone=+919967706767&text=${Uri.encodeFull("Query From Guest")}");
                          }


                        },
                        child: const Text('Contact Us',style: TextStyle(color: Colors.black),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
