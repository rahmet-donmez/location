import 'package:flutter/material.dart';
import 'package:locationdemo/home.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionWaitPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PermissionWaitPage();
  
}

class _PermissionWaitPage extends State<PermissionWaitPage>{

Future<bool> permisson_location()async{
 
 
 
  await Permission.locationAlways.request();

  if(await Permission.location.isGranted){
    Navigator.pop(context, MaterialPageRoute(builder:(context) => HomePage()));
    return true;
  }
  else{
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Uyarı'),
        content: Text('Uygulamayı kullanmak için konum bilginize erişim izni veriniz.'),
        actions: [TextButton(onPressed: () {

          permisson_location().then((value) => {
            if(value==true){
                  Navigator.pop(context, MaterialPageRoute(builder:(context) => HomePage()))


            }
            else{
              permisson_location()

            }
          });
        }, child: Text("Tamam"))]);
    },);
    return false;
   
    
  }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permisson_location();

  }
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}