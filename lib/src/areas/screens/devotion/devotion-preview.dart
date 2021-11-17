import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

 
class DevotionPreview extends StatelessWidget {
  const DevotionPreview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
        ),
        body: ListView(
          children: [
            Image.asset(
              'assets/images/IMG-20210106-WA0001.jpg',
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
            titleSection(),
            buttonSection(context),
            textSection(),
          ],
        ),
      ),
    );
  }

  Widget titleSection() {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text('Oeschinen Lake Campground', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text('Kandersteg, Switzerland', style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          ),
        ],
      ),
    );
  } 

  Widget buttonSection(BuildContext context){
    Color color = Theme.of(context).primaryColorDark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, FaIcon(FontAwesomeIcons.download, color: Colors.black), 'Download', () {}),
        _buildButtonColumn(color, FaIcon(FontAwesomeIcons.headphones, color: Colors.black), 'Listen', () {}),
        _buildButtonColumn(color, FaIcon(FontAwesomeIcons.share, color: Colors.black), 'SHARE', () {}),
      ],
    );
  } 

  Widget textSection() {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
        'Alps. Situated 1,578 meters above sea level, it is one of the '
        'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
        'half-hour walk through pastures and pine forest, leads you to the '
        'lake, which warms to 20 degrees Celsius in the summer. Activities '
        'enjoyed here include rowing, and riding the summer toboggan run.',
        softWrap: true,
      ),
    );
  }  

  Column _buildButtonColumn(Color color, Widget icon, String label, Function onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon(icon, color: color),
        // Container(
        //   margin: const EdgeInsets.only(top: 8),
          // child: Text(
          //   label,
          //   style: TextStyle(
          //     fontSize: 12,
          //     fontWeight: FontWeight.w400,
          //     color: color,
          //   ),
          // ),)
        // ),
        TextButton.icon(onPressed: onPressed, icon: icon, 
          label: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ), 
      ],
    );
  }
}