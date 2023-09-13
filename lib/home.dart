import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController _controller;
  
  LocationData? currentLocation;
  MapType _mapType=MapType.normal;

//güzergahı tutmak için
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};


  //HARİTA ÜZERİNDE BİR KONUMU TANIMLAMA KONUM İŞARETİ İLE BELİRTEREK GÖSTERİLMESİ İÇİN YAZILIR.
  // Marker’ımızın üstüne tıkladığımızda infoWindow’a verdiğimiz değer okunuyor.
  //İSTENİLEN KADAR MARKER TANIMLANABİLİR

  Set<Marker> _cretaeMarker() {
    return <Marker>[
    
      Marker(
          infoWindow: InfoWindow(title: "Ev"),
          markerId: MarkerId("asdasdd"),
          position: LatLng(38.392300, 27.047840),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
      Marker(
          infoWindow: InfoWindow(title: "Konak Pier"),
          markerId: MarkerId("asdsasdd"),
          position: LatLng(38.422733197746986, 27.129490953156576),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
    ].toSet();
  }
_addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.pink,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

Future getLocation()async{
Location location=Location();
  location.getLocation().then((value) => 
  currentLocation=value
  
  );
}
void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCcWNVedZM5QbKKMeSS265x_scn3JKZlJU",
      PointLatLng(37.8890178,33.48802),
      PointLatLng(37.8890178,32.48802
      ),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);

  }




@override
  void initState() {
    super.initState();
 
    _getPolyline();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konum Takip"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
       floatingActionButton: FloatingActionButton(
      onPressed: _onMapTypeButtonPressed,
      child: Icon(Icons.map),
      ),
      body:SizedBox(
        //height: 300,
        child: GoogleMap(
           polylines: Set<Polyline>.of(polylines.values),
          myLocationEnabled: true, //kişinin konumunun görüntülenmesini sağlar
          myLocationButtonEnabled:
              true, // Haritanın sağ altındaki zoom butonlarının hemen altında yer alan butonu temsil eder.
          // Bu buton yardımıyla, eğer myLocationEnabled değerini true olarak ayarladıysanız,
          //butona tıkladığınızda harita otomatik olarak sizin bulunduğunuz konuma zoom yapacaktır.
          tiltGesturesEnabled: true,
          compassEnabled: true,//pusula etkinleştirme
          scrollGesturesEnabled: true,//kaydırma hareketleri açık. KAPALI OLURSA HARİTAYI SAĞA SOLA HAREKET ETTİRMEYİZ
          zoomGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            //harita ilk açıldığında hangi konumu göstermeye başlayacağını belirtiriz
            target: LatLng(37.8890178,35.48802),
            zoom: 15,
          ),
          markers: _cretaeMarker(),//harita üzeindeki birkaç yeri tanımlamak için kullanılır
          mapType: _mapType,
          onMapCreated: (controller) {
           
            //harita çağrıldığında çalışacak olan metottur.
            _controller = controller;
           
            
          },
        ),
      ),
    );
  }

  void _onMapTypeButtonPressed() {
  

    if(_mapType==MapType.normal){
      setState(() {
        _mapType=MapType.satellite;
      });
      
    }
    else{
      setState(() {
        _mapType=MapType.normal;
      });

    }

  }
}
