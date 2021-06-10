import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/LoginPage/countryPicker.dart';

class EditProfile extends StatefulWidget {
  
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var name;
  var email;
  var dob;
  var countryCode;
  var phone;

  final TextEditingController _nameController =
      new TextEditingController();
  final TextEditingController _emailController =
      new TextEditingController();
  final TextEditingController _dobController =
      new TextEditingController();
  final TextEditingController _mobileController = new TextEditingController();
  
  var selectedCountryCode = '+60';
  var countryList;
  List<String> countryName = [];

  getProfileInfo() async {
    var contentData = await Request()
        .getRequest(Config().url + "api/user/getProfile", context);

    if (contentData['status'] == true) {
      if (mounted) {
        setState(() {
          print(contentData);
          name = contentData['data']['name'];
          email = contentData['data']['email'];
          dob = contentData['data']['dob'];
          countryCode = contentData['data']['country_code'];
          phone = contentData['data']['mobile_no'];
          infoData();
        });
      }
    }
  }

  infoData() async{
    _nameController.text = name;
    _emailController.text = email;
    _dobController.text = dob;
    _mobileController.text = phone;
    // getCountryList();
  }

  // getCountryList() async {
  //   var contentData2 = await Request()
  //       .getRequest(Config().url + "api/global/country_list", context);

  //   if (contentData2['status'] == true) {
  //     countryList = contentData2['data'];
  //     // for (var i = 0; i < countryList.length; i++) {
  //     //   setState(() {
  //     //     if (countryList[i]["name_en"] == 'Malaysia') {
  //     //       selectedCountryCode = countryList[i]["country_code"];
  //     //     }
  //     //     countryName.add(countryList[i]["name_en"] +
  //     //         " " +
  //     //         "(" +
  //     //         countryList[i]["country_code"] +
  //     //         ")");
  //     //   });
  //     // }
  //     print(countryList);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
            ),
            preferredSize: Size.fromHeight(0)),
        body: SingleChildScrollView(
            child: Container(
                // height: MediaQuery.of(context).size.height,
                color: Theme.of(context).backgroundColor,
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(
                      child: Text("Edit Profile",
                          style: Theme.of(context).textTheme.headline1)),
                  SizedBox(height: 80),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Text("Edit Profile",
                                style:
                                    Theme.of(context).textTheme.headline2)),
                        SizedBox(height: 35),
                        Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Name',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        _inputTextFormField(
                            _nameController, 'Name'),
                        SizedBox(height: 25),
                        Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email Address',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        _inputTextFormField(
                            _emailController, 'Email Address'),
                        SizedBox(height: 25),
                        Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Date of Birth',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        _inputTextFormField(
                            _dobController, 'Date of Birth'),
                        SizedBox(height: 25),
                        Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Mobile Number',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        _inputMobile(),
                        SizedBox(height: 25),
                       
                      ],
                    ),
                  )
                ]))));
  }
   _inputMobile() {
    return Stack(
      children: [
        new TextFormField(
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          controller: _mobileController,
          validator: validateMobile,
          decoration: new InputDecoration(
            prefixText: 'Prefix',
            prefixStyle: TextStyle(color: Colors.white),
            contentPadding: const EdgeInsets.all(16.0),
            hintText: MyLocalizations.of(context).getData('mobile'),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
          ),
          
          keyboardType: TextInputType.number,
          //validator: UIData.validateEmail,
          // onSaved: (str) {
          //   userName = str;
          // },
        ),
        Container(
          width: 80,
          color: Colors.transparent,
          child: CountryPicker(
            name: selectedCountryCode,
            lists: countryName,
            iconColor: Colors.white,
            backgroundColor: Colors.white,
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(width: 1, color: Colors.white),
            onChange: (index) {
              setState(() {
                selectedCountryCode = countryList[index]["country_code"];
              });
            },
          ),
        ),
      ],
    );
  }
}
 String validateMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.replaceAll(" ", "").isEmpty) {
      return 'Mobile is required';
    } else if (value.trim().length < 9) {
      return 'Mobile number must 10 digits';
    } else if (!regExp.hasMatch(value.replaceAll(" ", ""))) {
      return 'Mobile number must be digits';
    }
    return null;
  }
_inputTextFormField(_controller, label) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.all(0),
      child: TextFormField(
        controller: _controller,
        obscureText: false,
        autofocus: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[300]),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
      ),
    );
  }

  
