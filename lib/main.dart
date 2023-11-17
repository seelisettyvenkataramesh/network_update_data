import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
void main(){
  runApp( MyApp());
}

 Future<Album> fetchAlbum() async{
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  if(response.statusCode ==200){
    return Album.fromJson(jsonDecode(response.body));
  }else
  {
    throw Exception('Failed to Load album');
  }
 }



Future<Album> updateAlbum(String title) async{
  final response = await http.put(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),

    headers: <String,String>{
    'Content-Type':'application/json; Charset=UTF-8',
    },
    body: jsonEncode(<String,String>{
      'title':title
    })
  );
  if(response.statusCode ==200){
    return Album.fromJson(jsonDecode(response.body));
  }else
    {
      throw Exception('Failed to Update album');
    }
}
class Album{
 final int id;
 final String title;

 Album({required this.id,required this.title});
 factory Album.fromJson(Map<String,dynamic> json){
   return Album(id: json['id'], title: json['title']);

 }
}
class MyApp extends StatefulWidget{
  @override
  State<MyApp> createState()=> _MyAppState();

}

class _MyAppState extends State<MyApp> {
  TextEditingController _controller = TextEditingController();

 late Future<Album> _futureAlbum;

 @override
  void initState() {

    super.initState();
    _futureAlbum = fetchAlbum();
  }

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Update data'),
        ),
        body: Container(
          child: FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){

                if(snapshot.hasData){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data!.title),
                      TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Enter Title',
                        ),
                      ),
                      ElevatedButton(
                          onPressed: (){
                            setState(() {
                              _futureAlbum= updateAlbum(_controller.text);
                            });
                          }, child: Text('Update data')),
                    ],
                  );
                }else if(snapshot.hasError){
                  return Text('${snapshot.error}');
                }
              }

              return CircularProgressIndicator();


            },
          )

        ),
      ),
    );

  }

}







