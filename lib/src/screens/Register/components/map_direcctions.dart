import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';
import 'package:vivo_vivo_app/src/utils/snackbars.dart';


class SearchPlaces extends StatefulWidget {
  const SearchPlaces({super.key});
  @override
  State<SearchPlaces> createState() => _SearchPlacesState();
}


class _SearchPlacesState extends State<SearchPlaces> {
final homeScaffoldKey = GlobalKey<ScaffoldState>();
  late LatLng direction;
  Set<Marker> markersList = {};
  GoogleMapController? googleMapController;
  static const CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(-1.085854, -78.316637), zoom: 8.0);
  final Mode _mode = Mode.overlay;
  String? _currentAddress;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: homeScaffoldKey,
      appBar: AppBar(
        backgroundColor: Styles.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.black,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Styles.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Ubique su domicilio",
              style: Styles.textStyleBody.copyWith(color: Styles.black),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GoogleMap(
              zoomControlsEnabled: true,
              initialCameraPosition: _initialCameraPosition,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: markersList,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
              onTap: (argument) {
                displayPredictionOnTap(argument, homeScaffoldKey.currentState!);
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  heroTag: "btn1",
                  onPressed: _handlePressButton,
                  label: const Text("Buscar dirección"),
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: (() {
              getDirection(context);
            }),
            backgroundColor: Colors.green,
            child: (!loading)
                ? const Icon(Icons.check_rounded)
                : CircularProgressIndicator(
                    color: Styles.white,
                  ),
          ),
        ],
      ),
    );
  }

  Future<bool> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> marksList =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        _currentAddress = '${marksList[1].street}, ${marksList[2].street}';
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _handlePressButton() async {

    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: dotenv.env['API_KEY_GOOGLE']!,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white))),
        components: [
          Component(Component.country, "ec"),
          Component(Component.country, "ecu")
        ]);

    displayPrediction(p, homeScaffoldKey.currentState!);
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));

    // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction? p, ScaffoldState currentState) async {

    if (p != null) {
      GoogleMapsPlaces places = GoogleMapsPlaces(
          apiKey: dotenv.env['API_KEY_GOOGLE'],
          apiHeaders: await const GoogleApiHeaders().getHeaders());

      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(p.placeId!);

      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      setState(() {
        markersList.clear();
        markersList.add(Marker(
          markerId: const MarkerId("0"),
          position: LatLng(lat, lng),
        ));
        direction = LatLng(lat, lng);
      });

      googleMapController!
          .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
    }
  }

  Future<void> displayPredictionOnTap(
      LatLng? latLng, ScaffoldState currentState) async {
    if (latLng != null) {
      final lat = latLng.latitude;
      final lng = latLng.longitude;

      setState(() {
        markersList.clear();
        markersList.add(Marker(
          markerId: const MarkerId("0"),
          position: LatLng(lat, lng),
        ));
        direction = LatLng(lat, lng);
      });

      googleMapController!
          .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 18.0));
    }
  }

  void getDirection(BuildContext context) async {
    setState(() {
      loading = true;
    });
    bool isDirectionValid = await _getAddressFromLatLng(direction);

    if (isDirectionValid) {
      if (mounted) {
        /* personArguments.address = _currentAddress; */
        Navigator.pop(context, _currentAddress);
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.simpleSnackbar(
          "No se pudo obtener la dirección, Intente de nuevo",
          Icons.info,
          Styles.red!));
      setState(() {
        loading = false;
      });
    }
  }
}
