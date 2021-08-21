import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:my_finalapp1/model/Connectapi.dart';
import 'package:my_finalapp1/model/Member.dart';
import 'package:my_finalapp1/widget/colors.dart';
import 'package:my_finalapp1/widget/custom_back_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReviewListNp extends StatefulWidget {
  // ReviewListNp({Key? key}) : super(key: key);

  @override
  _ReviewListNpState createState() => _ReviewListNpState();
}

class _ReviewListNpState extends State<ReviewListNp> {
  List<Rowsrev> datamember = [];
  var npId;
  var token;

  //connect server api
  Future<Void> _getListReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    npId = prefs.getInt('id');
    print('npId = $npId');
    print('token = $token');
    var url = '${Connectapi().domain}/getlistreviews/$_npId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      ReviewListmodel members =
          ReviewListmodel.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        datamember = members.rowsrev;
        print(datamember.length);
        // load = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
    _getListReviews();
  }

  Map<String, dynamic> _rec_member;
  var _npId;

  Future getDataNp() {
    _rec_member = ModalRoute.of(context).settings.arguments;
    _npId = _rec_member['_npId'];
  }

  @override
  Widget build(BuildContext context) {
    // _getListReviews();
    getDataNp();
    return Scaffold(
      appBar: AppBar(
        title: Text('รีวิวจากผู้ใช้บริการ'),
        leading: CustomBackButton(
          tapBack: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: _reviewList(),
      ),
      // body: ListView.builder(
      //   scrollDirection: Axis.vertical,
      //   itemCount: datamember.length,
      //   itemBuilder: (context, index) {
      //     return Padding(
      //       padding: const EdgeInsets.all(20),
      //       child: Container(
      //         child: new FittedBox(
      //           child: Material(
      //             color: Theme.of(context).backgroundColor,
      //             borderRadius: BorderRadius.circular(15),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: <Widget>[
      //                 Container(
      //                   width: MediaQuery.of(context).size.width,
      //                   // height: 200,
      //                   child: Padding(
      //                     padding: const EdgeInsets.all(10),
      //                     child: Column(
      //                       mainAxisAlignment: MainAxisAlignment.start,
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: <Widget>[
      //                         Container(
      //                           child: Text(
      //                             "${datamember[index].revTopic}",
      //                             style: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.bold,
      //                             ),
      //                           ),
      //                         ),
      //                         Container(
      //                           child: Text(
      //                             "${datamember[index].revDetail}",
      //                             style: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.normal,
      //                             ),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //                 // Container(
      //                 //   width: 200,
      //                 //   height: 150,
      //                 //   child: mynpPhotos(),
      //                 // ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     );
      //     // ],
      //   },
      // ),
    );
  }

  Widget _reviewList() {
    var dateformate = DateFormat.yMMMEd();

    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: datamember.length,
      itemBuilder: (context, index) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: tBackgroundLightColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Stack(
                            overflow: Overflow.visible,
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: imgsuser('${datamember[index].userImg}'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${datamember[index].userUsername}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              // "${datamember[index].revTime}",
                              '${dateformate.format(DateTime.parse(datamember[index].revTime))}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${datamember[index].revTopic}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${datamember[index].revDetail}",
                          maxLines: 5,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        // ],
      },
    );
  }

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
}