import 'package:favorite_places/main.dart';
import 'package:favorite_places/screens/place_detail_screens.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:favorite_places/modules/place.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          "No data availabe",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: places.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlaceDetailScreens(place: places[index]),
              ),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: kIsWeb
                  ? NetworkImage(places[index].image.path)
                  : FileImage(places[index].image) as ImageProvider,
            ),
            title: Text(
              places[index].title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            subtitle: Text(places[index].location.address, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: colorScheme.onBackground,
            ),),
          ),
        );
      },
    );
  }
}
