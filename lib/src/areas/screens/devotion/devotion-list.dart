import 'package:cokg/src/areas/models/devotion.dart';
import 'package:cokg/src/areas/services/providers/devotionRepositry.dart';
import 'package:cokg/src/resources/widgets/list-tile.dart';
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
         headerSliverBuilder: (context, _){
          return [
            SliverAppBar(
              expandedHeight: 100,
              collapsedHeight: kToolbarHeight+1,
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.asset('assets/images/logo.jpeg', fit: BoxFit.cover)
                  )
                ]
              ),
            )
          ];
        },
        
        body: StreamBuilder<List<Devotion>>(
          stream: devotionProvider.devotion,
          builder: (context, devotion) {
            if (!devotion.hasData) return Center(child: CircularProgressIndicator());
            
            return ListView.builder(
              itemCount: devotion.data.length,
              itemBuilder: (context, index) {
                
                return AppListTile(
                  title: devotion.data[index].title,
                  subtitle: devotion.data[index].description,
                  onTap: () {
                    Navigator.of(context).pushNamed("/devotionSubPage/${devotion.data[index].id}");
                  }
                ); 
              }
            );
          }
        ),
      ),
    );
  }
}