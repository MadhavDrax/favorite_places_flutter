import 'package:favorite_places/modules/place.dart';
import 'package:favorite_places/screens/map_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class PlaceDetailScreens extends StatelessWidget {
  const PlaceDetailScreens({super.key, required this.place});
  final Place place;

  String _staticMapUrl(double lat, double lng) {
    const apiKey = String.fromEnvironment('GEOAPIFY_API_KEY');
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
      'No data found',
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );

    if (place.location != null) {
      previewContent = Image.network(
        _staticMapUrl(place.location.latitude, place.location.longitude),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Text('Could not load map preview')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Stack(
        alignment: AlignmentGeometry.directional(0, 0),
        children: [
          Positioned.fill(
            child: kIsWeb
                ? Image.network(
                    place.image.path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Image.file(
                    place.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              spacing: 8,
              children: [
                //circular map
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      MapView(place: place),
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                      ),
                      shape: BoxShape.circle,
                    ),
                    height: 170,
                    width: 170,
                    alignment: Alignment.center,
                    clipBehavior: Clip.hardEdge,
                    child: previewContent,
                  ),
                ),

                //bottom text
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),

                    color: Colors.black.withOpacity(0.7),
                  ),
                  width: 300,
                  child: Text(
                    textAlign: TextAlign.center,
                    place.location.address,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
