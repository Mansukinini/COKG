import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Vision extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 30.0, color: Colors.white, onPressed: () => Navigator.pop(context)),
      ),
      body: pageBody()
    );
  }

  Widget pageBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 25.0, right: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 260.0,
              height: 95.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                      image: AssetImage('assets/images/cokg.PNG'), fit: BoxFit.contain))
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Vision Statement", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, decoration: TextDecoration.underline)),
                Text("Transforming Lives in our community city and nation"),
                Text(""),
                Text("Why do we exist?",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, decoration: TextDecoration.underline)),
                Text("Transforming Lives to fulfil destiny"),
                Text("Serving: Authentic leadership is saved to serve."),
                Text("Helping: Uplifting human dignity."),
                Text("Leading: Raising godly leaders who can impact society"),
                Text(""),
                Text("Mission",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, decoration: TextDecoration.underline)),
                Text(getMission()),
                Text(""),
                Text("Statement of Purpose", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, decoration: TextDecoration.underline)),
                Text("\u2022 To transform people lives through active stewardship and perfecting the work of Christ."),
                Text("\u2022 To help people realize their worth, hope, and inheritance and develop them to Christ-like maturity."),
                Text("\u2022 To equip them for their ministry in the church and life in the community unto the fullness of Christ."),
                Text(""),
                Text("Aims and Objectives", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, decoration: TextDecoration.underline)),
                Text("\u2022 Disciplieship"),
                Text("\u2022 Worship"),
                Text("\u2022 Spiritual Empowerment"),
                Text("\u2022 Evangelism and Outreach"),
                Text("\u2022 Social and Commnunity development"),
                Text("\u2022 Strive for Justice and Peace"),
                Text("\u2022 Leadership Formation"),
                Text("\u2022 Constant demonstration of Holy Spirit Power"),
                SizedBox(height: 20.0,)
              ],
            ),
          ],
        )
      )
    );
  }

  String getMission() {
    return "To preach the gospel across all cultures, nationalities, and denominations. To help people realize their worth in Christ Jesus and " +
           "their hope, and inheritance as children of God. To provide spiritual, enducational, physical, social, emotional needs through " +
           "practical community development, teaching and communal fellowship base on charity. 1 Corinthians 13";
  }
}