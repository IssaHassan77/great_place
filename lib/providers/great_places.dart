import 'dart:io';

import 'package:flutter/material.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';
// import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }
 Place findById(id){
  return _items.firstWhere((place) => place.id ==id );
 }
  Future<void> addPlace(String pickedTitle, File pickedImage,
      PlaceLocation pickedLocation) async {
    // final address = await LocationHelper.getPlaceAddress(
    //     pickedLocation.latitude, pickedLocation.longitude);
    final updateLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        // address: address
        );
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: pickedTitle,
        location: updateLocation,
        image: pickedImage);
    _items.add(newPlace);
    notifyListeners();
    DBHlepers.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'loc_lat': newPlace.location!.latitude,
        'loc_lng': newPlace.location!.longitude,
        'address': newPlace.location!.address!,
      },
    );
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHlepers.getData('user_places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            location: PlaceLocation(
              latitude: item['loc_lat'],
              longitude: item['loc_lng'],
              address: item['address'],
            ),
            image: File(
              item['image'],
            ),
          ),
        )
        .toList();
        notifyListeners();
  }
}
