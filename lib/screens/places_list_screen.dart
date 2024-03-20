import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_place_screen.dart';
import './place_detail_screen.dart';
import '../providers/great_places.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                : Consumer<GreatPlaces>(
                    child: const Center(
                      child: Text('Got no places yet,start adding some!'),
                    ),
                    builder: (ctx, greatplace, ch) => greatplace.items.isEmpty
                        ? ch!
                        : ListView.builder(
                            itemCount: greatplace.items.length,
                            itemBuilder: (ctx, i) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    FileImage(greatplace.items[i].image),
                              ),
                              title: Text(greatplace.items[i].title),
                              // subtitle:
                              //     Text(greatplace.items[i].location!.address!),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  PlaceDetailScreen.routeName,
                                  arguments: greatplace.items[i].id,
                                );
                              },
                            ),
                          ),
                  ),
      ),
    );
  }
}
