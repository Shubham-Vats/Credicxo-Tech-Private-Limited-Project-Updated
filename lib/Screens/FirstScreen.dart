import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'SecondScreen.dart';

Map data;
List necessaryData;

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

  String url="https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7";
  Future getData() async{
    try {
      http.Response response = await http.get(url);
      if(response.statusCode == 200)
      {
        print("Music List Successfully Fetched");
        data = json.decode(response.body);
        
        necessaryData = data["message"]["body"]["track_list"];
        
        return necessaryData;
      }
      else
      {
        print("Problem Occurs");
      }
    }catch (e) {
      debugPrint(e.toString());
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trending",style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData)
            {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length == null ? 0 : snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SecondScreen(trackId: snapshot.data[index]["track"]["track_id"],)));
                      },
                      child: Container(
                        height:100,
                        decoration: BoxDecoration(
                          color: Colors.red[200],
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(left:15.0),
                                child: Icon(Icons.my_library_music,color: Colors.black45,size: 25.0,),
                              ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left:25.0,right: 25.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("${snapshot.data[index]["track"]["track_name"]}", style: TextStyle(fontSize: 17.0),maxLines: 2,),
                                    Text("${snapshot.data[index]["track"]["album_name"]}", style: TextStyle(fontSize: 14.0,color: Colors.black45),),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right:15.0),
                                child: Text("${snapshot.data[index]["track"]["artist_name"]}", style: TextStyle(fontSize: 13.0)),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              );
            }
            else
            {
              return Center(
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

