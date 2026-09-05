import 'dart:io';

import 'package:favorite_places/modules/place.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/provider/user_places.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleFieldController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    final enteredText = _titleFieldController.text;
    if (enteredText.isEmpty || _selectedImage == null || _selectedLocation == null) {
      return;
    }
    ref.read(userPlacesProvider.notifier).addPlace(enteredText, _selectedImage!, _selectedLocation!);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add place")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _titleFieldController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
              ),
            ),

            SizedBox(height: 20),
            ImageInput(onPickImage: (image) {
              _selectedImage = image;
            },),
            SizedBox(height: 20),
            LocationInput(onSelectLocation: (location) {
              _selectedLocation = location;
            },),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _savePlace,
              label: Text("Add place"),
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
