import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';

class LocationController extends GetxController {
  late LocationData locationData;
  final Location location = Location();

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  @override
  void onInit() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    await Authenticator.instance.updateLocation();
    super.onInit();
  }
}
