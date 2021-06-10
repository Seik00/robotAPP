import 'package:flutter/material.dart';
import 'package:robot/API/config.dart';
import 'package:robot/API/request.dart';
import 'package:robot/vendor/i18n/localizations.dart';
import 'package:robot/views/SystemSetting/editProfile.dart';

class Profile extends StatefulWidget {
  final url;
  final onChangeLanguage;
  Profile(this.url, this.onChangeLanguage);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var name;
  var countryCode;
  var phone;
  var email;
  getProfileInfo() async {
    var contentData = await Request()
        .getRequest(Config().url + "api/user/getProfile", context);

    if (contentData['status'] == true) {
      if (mounted) {
        setState(() {
          print(contentData);
          name = contentData['data']['name'];
          countryCode = contentData['data']['country_code'];
          phone = contentData['data']['mobile_no'];
          email = contentData['data']['email'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
        child: AppBar(),
        preferredSize:Size.fromHeight(0)
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height:MediaQuery.of(context).size.height / 3.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'lib/assets/img/profile/profile_banner.png'),
                  fit: BoxFit.fill),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                  Container(
                      margin: EdgeInsets.only(top: 50),
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        name ?? 'User',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.end,
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '(Region ASP)',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.end,
                      )),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfile())),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Edit',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 30,
                        width: 30,
                        margin: EdgeInsets.only(right: 30),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: AssetImage(
                                    "lib/assets/img/profile/phone.png"))),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          countryCode ?? 'countryCode',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          phone ?? 'phone',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: <Widget>[
                       Container(
                        height: 30,
                        width: 30,
                        margin: EdgeInsets.only(right: 30),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: AssetImage(
                                    "lib/assets/img/profile/email.png"))),
                      ),
                      Expanded(
                        child: Text(email ?? 'email',
                            style: Theme.of(context).textTheme.headline6),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
