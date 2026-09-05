import 'dart:async';
import 'package:favorite_places/modules/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInput();
  }
}

class _LocationInput extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  String? _address;
  String? _locationError;
  bool _isGettingLocation = false;

  Future<String?> _getAddressFromLatLng(double lat, double lng) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng',
    );

    try {
      final response = await http
          .get(url, headers: {'User-Agent': 'favorite_places Flutter app'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['display_name'] as String?; // full formatted address
    } catch (e) {
      return null;
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_isGettingLocation) return;

    setState(() {
      _isGettingLocation = true;
      _locationError = null;
    });
    final location = Location();

    try {
      var serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled.');
        }
      }

      var permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
      }
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permission was not granted.');
      }

      final locationData = await location.getLocation().timeout(
        const Duration(seconds: 20),
      );
      final latitude = locationData.latitude;
      final longitude = locationData.longitude;
      if (latitude == null || longitude == null) {
        throw Exception('The device did not provide a location.');
      }

      final address = await _getAddressFromLatLng(latitude, longitude);
      final selectedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address ?? 'Latitude: $latitude, Longitude: $longitude',
      );

      if (!mounted) return;
      setState(() {
        _pickedLocation = selectedLocation;
        _address = selectedLocation.address;
      });
      widget.onSelectLocation(selectedLocation);
    } on TimeoutException {
      if (mounted) {
        const message = 'Could not get a GPS location. Try again outdoors.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        setState(() => _locationError = message);
      }
    } catch (error) {
      if (mounted) {
        final message = 'Could not get location: $error';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        setState(() => _locationError = message);
      }
    } finally {
      if (mounted) {
        setState(() => _isGettingLocation = false);
      }
    }
  }

  String _staticMapUrl(double lat, double lng) {
    const apiKey = '4905b247f697428d97ee8d5d1ffabb9c';
    return 'https://maps.geoapify.com/v1/staticmap'
        '?style=osm-bright'
        '&width=600&height=300'
        '&center=lonlat:$lng,$lat'
        '&zoom=16'
        '&marker=lonlat:$lng,$lat;color:%23ff0000;size:medium'
        '&apiKey=$apiKey';
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      _locationError ?? 'No location selected',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    if (_pickedLocation != null && !_isGettingLocation) {
      previewContent = Image.network(
        _staticMapUrl(_pickedLocation!.latitude, _pickedLocation!.longitude),
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Text('Could not load map preview')),
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          child: previewContent,
        ),
        if (_address != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              _address!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _isGettingLocation ? null : _getCurrentLocation,
              label: const Text('Get current location'),
              icon: const Icon(Icons.location_on),
            ),
          ],
        ),
      ],
    );
  }
}
