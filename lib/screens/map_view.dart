import 'package:favorite_places/modules/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  const MapView({super.key, required this.place});
  final Place place;
  @override
  State<MapView> createState() {
    return _MapViewState();
  } 
}

class _MapViewState extends State<MapView>{
  
  
@override
  Widget build(BuildContext context) {
    
    final LatLng point = LatLng(widget.place.location.latitude, widget.place.location.longitude);
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),

      body: FlutterMap(
        options: MapOptions(
          initialCenter: point,
          initialZoom: 16,
          // interactive — pan/zoom enabled, no InteractiveFlag.none
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.yourcompany.favorite_places',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: point,
                width: 40,
                height: 40,
                child: Icon(
                  Icons.location_pin,
                  color: Theme.of(context).colorScheme.primary,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


