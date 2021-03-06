import 'package:flutter/material.dart';
import 'package:my_finalapp1/owner/Dashboard.dart';
import 'package:my_finalapp1/widget/colors.dart';
import 'package:my_finalapp1/widget/custom_back_button.dart';
import 'package:my_finalapp1/model/LoginOWModel.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MainPageOwner extends StatefulWidget {
  @override
  _MainPageOwnerState createState() => _MainPageOwnerState();
}

class _MainPageOwnerState extends State<MainPageOwner> {
  TextEditingController _fusername = TextEditingController();
  TextEditingController _fpassword = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  LoginOwModel login = LoginOwModel();

  //ดึง token เพื่อ Login
  Future doLoginOw() async {
    if (_formkey.currentState.validate()) {
      try {
        var rs = await login.doLoginOw(_fusername.text, _fpassword.text);
        print(_fusername.text);
        print(_fpassword.text);
        if (rs.statusCode == 200) {
          print(rs.body);
          var jsonRes = json.decode(rs.body);

          if (jsonRes['ok']) {
            String token = jsonRes['token'];
            var id = jsonRes['id'];
            print(token);
            print(id);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token);
            await prefs.setInt('id', id);

            //re
            // Navigator.pushNamedAndRemoveUntil(context, '/owdashboard', (route) => false);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Dashboard()));
          } else {
            print(jsonRes['error']);
          }
        } else {
          print('connect error');
        }
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        leading: CustomBackButton(
          tapBack: () {
            Navigator.pop(context);
          },
        ),
        // title: Text("เข้าสู่ระบบ"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                'assets/images/cover_owner.png',
                width: MediaQuery.of(context).size.width * 0.9,
              ),
              // SizedBox(height: 50),
              loginfrom(),
              // SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _btnMRegis(),
                  _btnMLogin(),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget loginfrom() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณากรอกชื่อผู้ใช้';
              }
            },
            controller: _fusername,
            style: TextStyle(
              color: tTextColor,
              fontSize: 16,
            ),
            cursorColor: tPimaryColor,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: tBGDeepColor,
              hintText: 'ชื่อผู้ใช้',
              hintStyle: TextStyle(
                fontSize: 16,
                color: tGreyColor,
              ),
              icon: ImageIcon(
                new AssetImage('assets/icons/user.png'),
                color: tPimaryColor,
                // size: 30,
              ),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณากรอกรหัสผ่าน';
              }
            },
            controller: _fpassword,
            obscureText: true,
            style: TextStyle(
              color: tTextColor,
              fontSize: 16,
            ),
            cursorColor: tPimaryColor,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: tBGDeepColor,
              hintText: 'รหัสผ่าน',
              hintStyle: TextStyle(
                fontSize: 16,
                color: tGreyColor,
              ),
              icon: ImageIcon(
                new AssetImage('assets/icons/lock.png'),
                color: tPimaryColor,
                // size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btnMLogin() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: tPimaryColor,
        ),
        child: Text(
          'เข้าสู่ระบบ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        onPressed: () {
          // Navigator.pushNamed(context, '/uloginpage');
          // Navigator.pushNamed(context, '/owloginpage');
          doLoginOw();
        },
      ),
    );
  }

  Widget _btnMRegis() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 45,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: BorderSide(color: tPimaryColor),
          primary: tPimaryColor,
        ),
        child: Text(
          'สมัครสมาชิก',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/owregisterpage');
        },
      ),
    );
  }
} // ! m class