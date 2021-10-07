import 'package:cokg/src/areas/models/devotion.dart';
import 'package:cokg/src/areas/services/providers/devotionRepositry.dart';
import 'package:cokg/src/resources/widgets/scaffold.dart';
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
              expandedHeight: 160.0,
              collapsedHeight: kToolbarHeight+1,
              flexibleSpace: FlexibleSpaceBar(background: Image.asset('assets/images/logo0.jpg', fit: BoxFit.fill)),
            )
          ];
        },
        
        body: _pageBody(devotionProvider),
      ),
    );
    // return AppScaffold.scaffold(_pageBody(devotionProvider)); 
  }

  StreamBuilder _pageBody(DevotionRepositry devotionProvider) {
    return StreamBuilder<List<Devotion>>(
      stream: devotionProvider.devotion,
      builder: (context, devotion) {
        if (!devotion.hasData) return Center(child: CircularProgressIndicator());
        
        return ListView.builder(
          itemCount: devotion.data.length,
          itemBuilder: (context, index) {

            return Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.headphones_rounded, size: 35.0, color: Colors.black),
                      title: Text(devotion.data[index].title.length > 30 ? '${devotion.data[index].title.substring(0, 30)}...' : devotion.data[index].title ?? '', style: TextStyles.title),
                      subtitle: Text((devotion.data[index].description != null && devotion.data[index].description.length > 40) 
                      ? '${devotion.data[index].description.substring(0, 45)}...' 
                      : devotion.data[index].description ?? devotion.data[index].title, style: TextStyles.subtitle),
                      onTap: () => Navigator.of(context).pushNamed("/devotionPreview"),
                      // onTap: () => Navigator.of(context).pushNamed("/devotionSubPage/${devotion.data[index].id}"),
                      onLongPress: () => Navigator.of(context).pushNamed("/devotionDetail/${devotion.data[index].id}"),
                    ),
                  )
                ]
              ),

              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black26)))
            ); 
          }
        );
      }
    );
  }
}