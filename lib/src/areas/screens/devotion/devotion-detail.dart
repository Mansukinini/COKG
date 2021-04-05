import 'package:cokg/src/areas/services/providers/devotionRepositry.dart';
import 'package:cokg/src/resources/widgets/button.dart';
import 'package:cokg/src/resources/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevotionDetail extends StatefulWidget {
  @override
  _DevotionDetailState createState() => _DevotionDetailState();
}

class _DevotionDetailState extends State<DevotionDetail> {

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    var devotionProvider = Provider.of<DevotionRepositry>(context);
    
    return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),

          title: Center(child: Text("Add devotion")),
          actions: <Widget>[
            // ignore: deprecated_member_use
            RaisedButton(
              child: Text('Cancel', style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold)),
              color: Theme.of(context).accentColor,
              onPressed: () => Navigator.of(context).pop()
            ),

            // ignore: deprecated_member_use
            RaisedButton(
              child: Text('Save', style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold)),
              color: Theme.of(context).accentColor,
              onPressed: () {
                devotionProvider.saveDevotion();
              }
            )
          ]),
          body: _pageBody(context, devotionProvider),
    );
  }
    
  Widget _pageBody(BuildContext context, DevotionRepositry devotionRepositry) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<String>(
              stream: devotionRepositry.getTitle,
              builder: (context, devotion) {

                return AppTextField(labelText: "Title",
                  onChanged: devotionRepositry.setTitle,
                );
              }
            ),

            StreamBuilder<String>(
              stream: devotionRepositry.getDescription,
              builder: (context, snapshot) {

                return AppTextField(labelText: "Description",
                  maxLines: 2,
                 onChanged: devotionRepositry.setDescription,);
              }
            ),

            // Stack(
            //   children: <Widget>[
            //     ClipPath(
            //       clipper: CustomShapeClipper(),
            //       child: Container(
            //         height: 150.0,
            //         decoration: BoxDecoration(color: primaryColor),
            //       ),
            //     ),
                
            //     Padding(
            //       padding: EdgeInsets.only(top: 20.0, right: 25.0, left: 25.0),
            //       child: Container(
            //         width: double.infinity,
            //         height: 250.0,
            //         decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.all(Radius.circular(20.0)),
            //             boxShadow: [
            //               BoxShadow(
            //                   color: Colors.black.withOpacity(0.1),
            //                   offset: Offset(0.0, 3.0),
            //                   blurRadius: 15.0)
            //             ]),
            //         child: Column(
            //           children: <Widget>[
            //             // Padding(
            //             //   padding: EdgeInsets.symmetric(
            //             //       horizontal: 40.0, vertical: 40.0),
            //             //   child: Row(
            //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             //     children: <Widget>[
                              
            //             //     ],
            //             //   ),
            //             // ),
            //             // Padding(
            //             //   padding: EdgeInsets.symmetric(horizontal: 40.0),
            //             //   child: Row(
            //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             //     children: <Widget>[
                              
                             
            //             //     ],
            //             //   ),
            //             // ),

            //             SizedBox(height: 15.0),
                        
            //             Divider(),
            //             SizedBox(height: 15.0),
            //             // Padding(
            //             //   padding: EdgeInsets.symmetric(horizontal: 25.0),
            //             //   child: Row(
            //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             //     children: <Widget>[
                             
                             
            //             //     ],
            //             //   ),
            //             // )
            //           ],
            //         ),
            //       ),
            //     ),

                AppButton(
                  labelText: "Upload Audio file", 
                  onPressed: () {
                    devotionRepositry.uploadFile();
                  }
                ),

            //   ],
            // ),
          ],
        ),
      );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, 390.0 - 200);
    path.quadraticBezierTo(size.width / 2, 280, size.width, 390.0 - 200);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class UpcomingCard extends StatelessWidget {
  final String title;
  final double value;
  final Color color;

  UpcomingCard({this.title, this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15.0),
      child: Container(
        width: 120.0,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 30.0),
              Text('$value',
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
