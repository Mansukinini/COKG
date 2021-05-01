import 'package:cokg/src/areas/models/devotion.dart';
import 'package:cokg/src/areas/services/providers/devotionRepositry.dart';
import 'package:cokg/src/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevotionList extends StatefulWidget {
  @override
  _DevotionListState createState() => _DevotionListState();
}

class _DevotionListState extends State<DevotionList> {
  @override
  Widget build(BuildContext context) {
    var devotionProvider = Provider.of<DevotionRepositry>(context);

    return Scaffold(
      body: NestedScrollView(
         headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              collapsedHeight: kToolbarHeight+1,
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(child: Image.asset('assets/images/logo0.jpg', fit: BoxFit.cover))
                ]
              ),
            )
          ];
        },
        
        body: _pageBody(devotionProvider),
      ),
    );
  }

  StreamBuilder _pageBody(DevotionRepositry devotionProvider) {
    return StreamBuilder<List<Devotion>>(
      stream: devotionProvider.devotion,
      builder: (context, devotion) {
        if (!devotion.hasData) return Center(child: CircularProgressIndicator());
        
        return ListView.builder(
          itemCount: devotion.data.length,
          itemBuilder: (context, index) {

            return Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 35.0,
                      child: Image.asset('assets/images/audiologo.png', fit: BoxFit.fill),
                      // backgroundImage: Image.asset('assets/images/audiologo.png', fit: BoxFit.cover),
                    ),
                    title: Text(devotion.data[index].title ?? '', style: TextStyles.subtitle),
                    subtitle: Text(devotion.data[index].description ?? '', style: TextStyle(fontSize: 12.0, color: Colors.black),),
                    onTap: () => Navigator.of(context).pushNamed("/devotionSubPage/${devotion.data[index].id}"),
                  ),
                )
              ]
            ); 
          }
        );
      }
    );
  }
}