import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:my_finalapp1/MainPage.dart';
import 'package:my_finalapp1/widget/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:my_finalapp1/model/Connectapi.dart';
import 'package:my_finalapp1/model/Member.dart';

class Profile extends StatefulWidget {
  // Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

String userId;
  UserInfo udata;
  //connect server api
  Future<Void> _getInfoUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var userId = prefs.getInt('id');
    print('uId = $userId');
    print('token = $token');
    var url = '${Connectapi().domain}/getprofileuser/$userId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      UserMember members =
          UserMember.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        udata = members.info;
      });
    }
  }

  Future onGoBack(dynamic value) {
    setState(() {
      _getInfoUser();
    });
  }

  @override
  void initState() {
    // TODO implement initState
    super.initState();
    //call _getAPI
    _getInfoUser();
  }


  Future _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => MainPage()),
        (Route<dynamic> route) => false);
    // _showbar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: bodyuProScn(),
      ),
    );
  }

  Widget bodyuProScn() {
    return Column(
      children: [
        SizedBox(height: 30),
        // Spacer(),
        profilePic(), //? -- > Profile Picture
        SizedBox(height: 30),
        ProfileMenu(
          icon: "assets/icons/user.png",
          text: "บัญชีผู้ใช้",
          press: () {
            Navigator.pushNamed(context, '/showdataUser');
            print("บัญชีผู้ใช้");
          },
        ),
        ProfileMenu(
          icon: "assets/icons/bookmarks.png",
          text: "รายการสำรองที่นั่ง",
          press: () {
            print("รายการสำรองที่นั่ง");
          },
        ),
        btnLogout(),
      ],
    );
  }

 // ? Proile Picture
  SizedBox profilePic() {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        overflow: Overflow.visible,
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: imgsuser('${udata.userImg}'),
          ),
        ],
      ),
    );
  } //! >> class Proile Picture
  
  Widget imgsuser(imageName) {
    Widget child;
    print('Imagename : $imageName');
    if (imageName != null) {
      child = Image.network('${Connectapi().domainimguser}${imageName}');
    } else {
      child = Image.asset('assets/images/person.png');
    }
    return new Container(child: child);
  }

  Padding btnLogout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: new FlatButton(
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.transparent,
        onPressed: () {
          _logout();
        }, // onPress
        child: Row(
          children: [
            ImageIcon(
              new AssetImage(
                  "assets/icons/logout.png",), // new AssetImage("assets/images/user.png"),
              color: Theme.of(context).errorColor,
              size: 20,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                "ออกจากระบบ", // "บัญชีผู้ใช้",
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // Icon(
            //   Icons.arrow_forward_ios,
            //   color: Theme.of(context).primaryColor,
            //   size: 20,
            // ),
          ],
        ),
      ),
    );
  }
} //! >> mian class

// ? Proile Menu
class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    @required this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: new FlatButton(
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.transparent,
        onPressed: press, // onPress
        child: Row(
          children: [
            ImageIcon(
              new AssetImage(icon), // new AssetImage("assets/images/user.png"),
              color: tWhiteColor,
              size: 20,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                text, // "บัญชีผู้ใช้",
                style: TextStyle(
                  color: tWhiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: tWhiteColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
} //! >> class Profile Menu