import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import './map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';
  const PlaceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final selectedPlace = Provider.of<GreatPlaces>(context).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          // Text(
          //   selectedPlace.location!.address!,
          //   textAlign: TextAlign.center,
          //   style: const TextStyle(
          //     color: Colors.grey,
          //     fontSize: 20,
          //   ),
          // ),
          SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => MapScreen(
                      initialLocation: selectedPlace.location!,
                      isSelecting: false,
                    ),
                  ),
                );
              },
              child: Text(
                'View on Map',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ))
        ],
      ),
    );
  }
}
