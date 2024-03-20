import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:location/location.dart';

// import '../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  const LocationInput(this.onSelectPlace, {super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  // String? _previewImageUrl;
  GoogleMap? _previewMap;
  void _showPreview(double lat, double lng) {
    // final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
    // latitude: lat, longitude: lng);
    print("lat : $lat   long: $lng");
    final staticMap = GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 16,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('m2'),
          position: LatLng(lat, lng),
        ),
      },
    );
    setState(() {
      //   _previewImageUrl = staticMapImageUrl;
      _previewMap = staticMap;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude!, locData.longitude!);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => const MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          height: 170,
          width: double.infinity,
          child: _previewMap ??
              const Text(
                'No Location Chosen',
                textAlign: TextAlign.center,
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
                onPressed: _getCurrentUserLocation,
                icon: const Icon(Icons.location_on),
                label: const Text('Current Location')),
            TextButton.icon(
                onPressed: _selectOnMap,
                icon: const Icon(Icons.map),
                label: const Text('Select on Map')),
          ],
        )
      ],
    );
  }
}
