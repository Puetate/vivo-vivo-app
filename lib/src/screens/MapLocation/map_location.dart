import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:custom_marker/marker_icon.dart';
import 'package:location/location.dart' as LC;
import 'package:vivo_vivo_app/src/commons/permissions.dart';
import 'package:vivo_vivo_app/src/components/photo.dart';
import 'package:vivo_vivo_app/src/domain/models/user_alert.dart';
import 'package:vivo_vivo_app/src/domain/models/user_auth.dart';
import 'package:vivo_vivo_app/src/providers/geolocation_provider.dart';
import 'package:vivo_vivo_app/src/providers/socket_provider.dart';
import 'package:vivo_vivo_app/src/providers/user_provider.dart';
import 'package:vivo_vivo_app/src/screens/MapLocation/controllers/map_location_controller.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';

class LocationMap extends StatefulWidget {
  final UserAlert user;

  const LocationMap({super.key, required this.user});
  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  late UserAuth user;
  late IO.Socket socket;
  late Map<MarkerId, Marker> _markers;
  late MapLocationController mapLocationController;
  Completer<GoogleMapController> _controllerMap = Completer();
  // Map<PolylineId, Polyline> polylines = {};
  late Marker sourcePosition, destinationPosition;
  int count = 0;
  LC.Location location = LC.Location();
  BitmapDescriptor? imgSource;
  late BitmapDescriptor imgDestination;
  bool isSendLocation = false;
  // late StreamSubscription<LC.LocationData> locationSubscription;
  // BitmapDescriptor imagenMarker;

  //LatLng destination = LatLng(0.3368, -78.1237);
/*   static CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 15.0); */

  @override
  void initState() {
    super.initState();
    mapLocationController = MapLocationController(context: context);
    isSendLocation = context.read<GeoLocationProvider>().isSendLocation;
    if (!isSendLocation) {
      startListeningPosition(context);
    }
    user = Provider.of<UserProvider>(context, listen: false)
        .getUserPrefProvider!
        .getUser;
    _markers = <MarkerId, Marker>{};
    _markers.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getImage(user.avatar);
    });
    
  }

  void getImage(String avatar) async {
      imgSource = await getImagesMap(avatar);
      imgDestination = await getImagesMap(widget.user.avatar);
    setState(()  {
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (!isSendLocation) {
      mapLocationController.cancelSendLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    /*  GeoLocationProvider geoLocationProvider =
        context.watch<GeoLocationProvider>(); */
    LocationData? position =
        context.watch<GeoLocationProvider>().getLocationData;
    changeSourcePosition(position);

    /* WidgetsBinding.instance.addPostFrameCallback((_) {
    }); */
      initSocket(context, user);

    final Size size = AppLayout.getSize(context);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.user.names)),
      extendBody: true,
      body: Stack(
        children: [
          (imgSource != null)
              ? GoogleMap(
                  zoomControlsEnabled: false,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-1.273798, -78.645353),
                    zoom: 10,
                  ),
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controllerMap.complete(controller);
                  },
                  markers: Set<Marker>.of(_markers.values),
                )
              : const Center(child: CircularProgressIndicator()),
          /*         Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                direction: Axis.vertical,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromARGB(139, 255, 255, 255)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Distancia",
                                  style: Styles.textStyleBotttomTitle,
                                ),
                                Text("2KM"),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Tiempo",
                                  style: Styles.textStyleBotttomTitle,
                                ),
                                Text("1H"),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ],
              )
            ],
          ),
   */
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26.0),
          topRight: Radius.circular(26.0),
        ),
        child: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: UIComponents.photo(size, widget.user.avatar),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Recibiendo ubicación en tiempo real",
                    style: Styles.textStyleBottomTitle,
                  ),
                  Text(widget.user.names),
                  Text(
                    "Estado: En peligro",
                    style: Styles.textState,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startListeningPosition(BuildContext context) async {
    bool hasPermission = false;

    if (mounted) {
      hasPermission = await Permissions.checkPermission(context);
    }

    if (!hasPermission) {
      mapLocationController.openPermissionLocations();
      return;
    }
    mapLocationController.getLivePosition();
  }

  /*  void cancelSendLocation() async {
    await locationSubscription.cancel();
    location.enableBackgroundMode(enable: false);
  }
 */

  Future<void> changeSourcePosition(LC.LocationData position) async {
    sourcePosition = Marker(
      markerId: const MarkerId("source"),
      icon: (imgSource == null) ? BitmapDescriptor.defaultMarker : imgSource!,
      position: LatLng(
        position.latitude!,
        position.longitude!,
      ),
    );

    if (mounted) {
      setState(() {
        _markers[const MarkerId("source")] = sourcePosition;
      });
    }
  }

  void changeDestinationPosition(
      Map latlng, BitmapDescriptor imgDestination) async {
          log(latlng.toString());
    if (count <= 0) {
      final GoogleMapController controller = await _controllerMap.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latlng["lat"], latlng["lng"]),
            zoom: 15,
          ),
        ),
      );
      if (mounted) {
        setState(() {
          count++;
        });
      }
    }

    destinationPosition = Marker(
      markerId: MarkerId("destination"),
      icon: imgDestination,
      position: LatLng(
        latlng["lat"],
        latlng["lng"],
      ),
    );
    if (mounted) {
      setState(() {
        _markers[const MarkerId("destination")] = destinationPosition;
      });
    }
  }

  void initSocket(BuildContext context, UserAuth user) async {
    try {
      final socketProvider = context.read<SocketProvider>();
      socketProvider.connect(user);

      socketProvider.onLocation(
        widget.user.user,
        (data) {
          Map latlng = data["position"];
          changeDestinationPosition(latlng, imgDestination);
          log(latlng.toString());
          log("latlng.toString()");
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<BitmapDescriptor> getImagesMap(String avatar) async {
    try {
      BitmapDescriptor imgMarker =
          await MarkerIcon.downloadResizePictureCircle(avatar);
      return imgMarker;
    } catch (e) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  /* void getPolyPoints(LatLng destination) async {
    await dotenv.load(fileName: ".env");

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        dotenv.env['API_KEY_GOOGLE'],
        PointLatLng(0.326190, -78.174692),
        PointLatLng(destination.latitude, destination.longitude),
      );
      polylineCoordinates.clear();
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          setState(() {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
  } */
}
