import 'dart:io';
import 'dart:async';
import 'dart:convert'; // Json parser

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await DotEnv().load('.env');
  runApp(new MaterialApp(home: new MerryChristmasPage(),));
}

class MerryChristmasPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MCState();
  }
}

class MCState extends State<MerryChristmasPage> {

  int page = 1;
  bool isLoading = false;
  List<Model> models = [];

  @override
  Widget build(BuildContext context) {
    String apiKey = DotEnv().env['API_KEY'];
    String platformName = "Some Platform";
    if (Platform.isAndroid) platformName = "Android";
    if (Platform.isIOS) platformName = "iOS";

    return new Scaffold(
      appBar: new AppBar(title: new Text("🎅Flutter on $platformName🎄"),),
      body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
              if (index == this.models.length) {
                _load(apiKey);

                return new Center(
                  child: new Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    width: 32.0,
                    height: 32.0,
                    child: const CircularProgressIndicator(),
                  ),
                );
              } else if (index > this.models.length) {
                return null;
              }

              var model = models[index];
              return new Container(child: new Image(image: new CachedNetworkImageProvider(model.imageUrl),),
              );
          })
    );
  }

  Widget _sizedContainer(double width, Widget child) {
    return new SizedBox(
      width: width,
      height: width,
      child: new Center(
        child: child,
      ),
    );
  }


  Future<void> _load(String apiKey) async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    try {
      var url = "https://pixabay.com/api/?key=${apiKey}&image_type=photo&q=christmas&page=${page}";
      var resp = await http.get(url);
      var hits = json.decode(resp.body)['hits'];
      setState(() {
        page += 1;
        if (hits is List) {
          hits.forEach((dynamic hit) {
            if (hit is Map) {
              Model model = new Model();
              model.id = hit['id'] as int;
              model.imageUrl = hit['webformatURL'] as String;
              models.add(model);
            }
          });
        }
      });
    } finally {
      isLoading = false;
    }
  }


}

class Model {

  int id;
  String imageUrl;

}
