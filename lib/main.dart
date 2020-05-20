import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DefaultTabController(
        length: 2, 
        child: Scaffold(
          appBar: AppBar(
            title: Text('BarHop')
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.pages),
                text: 'Testing'
              ),
              Tab(
                icon: Icon(Icons.map),
                text: 'Maps'
              )
            ],
            labelColor: Colors.lightBlue,
          ),
          body: TabBarView(children: <Widget>[
            MyHomePage(),
            Maps()
          ],
          )
        )
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have clicked the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Maps extends StatefulWidget {
  @override
  MapState createState() => MapState();
}

class MapState extends State<Maps> {
  @override
  void initState() {
    super.initState();
    _initMap();
  }

  GoogleMapController mapController;

  LatLng _center;// = LatLng(45.521563, -122.677433);
  PlacesSearchResponse _response;
  List<Marker> _markers = <Marker>[];
  final places = new GoogleMapsPlaces(apiKey: "AIzaSyDLkJosEooi2EEk1YOiu8GjyYC_EPPogO0");
  final geolocator = Geolocator();
  
  void _initMap() async {
    Position position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    Location location = Location(position.latitude, position.longitude);
    PlacesSearchResponse response = await places.searchNearbyWithRadius(location, 50);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _response = response;
      for (var item in _response.results) {
        print(item.name);
        _markers.add(
          Marker(
            markerId: MarkerId(item.placeId),
            position: LatLng(item.geometry.location.lat, item.geometry.location.lng),
            infoWindow: InfoWindow(title: item.name, snippet: item.vicinity),
            onTap: () {},
          ),
        );
      }
    });
  } 

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(_markers),
        initialCameraPosition: CameraPosition(target: _center, zoom: 15.0),
      ),
    );
  }
}

// MVP TODO
// grab places near current location
// query user about place sufficiently close to current location
// store rating for place 
// show ratings for all nearby places in listview and on map
// user sign in and account
// database for accounts and places
// search places to see rating